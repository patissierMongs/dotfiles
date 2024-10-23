#!/bin/bash

# Initializer.sh

# This script initializes the system by updating repositories,
# installing essential packages, applying configurations, and
# making system settings changes.

# It is designed to be extensible and adaptable to different
# Linux distributions and versions.

# READ files
. ./version_manager

# Function to get OS information
get_os_info() {
    if [ -f /etc/os-release ]; then
        . /etc/os-release
        OS_NAME=$ID
        OS_VERSION=$VERSION_ID
    elif command -v lsb_release >/dev/null 2>&1; then
        OS_NAME=$(lsb_release -si | tr '[:upper:]' '[:lower:]')
        OS_VERSION=$(lsb_release -sr)
    else
        echo "Cannot determine OS distribution and version."
        exit 1
    fi

    # Extract major, minor, patch version numbers
    #IFS='.' read -r OS_MAJOR_VERSION OS_MINOR_VERSION OS_PATCH_VERSION <<< "$OS_VERSION"

    # If minor or patch version is empty, set to zero
    #OS_MINOR_VERSION=${OS_MINOR_VERSION:-0}
    #OS_PATCH_VERSION=${OS_PATCH_VERSION:-0}
}

# Function to select package manager
select_package_manager() {
    if [ -n "$(command -v dnf)" ]; then
        PKG_MANAGER="dnf"
    elif [ -n "$(command -v yum)" ]; then
        PKG_MANAGER="yum"
    elif [ -n "$(command -v apt)" ]; then
        PKG_MANAGER="apt"
    elif [ -n "$(command -v apt-get)" ]; then
        PKG_MANAGER="apt-get"
    elif [ -n "$(command -v pacman)" ]; then
        PKG_MANAGER="pacman"
    else
        echo "No suitable package manager found."
        exit 1
    fi
}

# Function to update repositories
update_repositories() {
    case "$PKG_MANAGER" in
        dnf|yum)
            $PKG_MANAGER -y makecache
            ;;
        apt|apt-get)
            $PKG_MANAGER update
            ;;
        pacman)
            $PKG_MANAGER -Sy --noconfirm
            ;;
        *)
            echo "Unsupported package manager for updating repositories."
            exit 1
            ;;
    esac
}

# Function to upgrade packages
upgrade_packages() {
    case "$PKG_MANAGER" in
        dnf|yum)
            $PKG_MANAGER -y upgrade
            ;;
        apt|apt-get)
            $PKG_MANAGER -y upgrade
            ;;
        pacman)
            $PKG_MANAGER -Su --noconfirm
            ;;
        *)
            echo "Unsupported package manager for upgrading packages."
            exit 1
            ;;
    esac
}

# Function to install essential packages
install_essential_packages() {
    if [ ! -f configure/essentialpkg.list ]; then
        echo "Essential package list not found."
        exit 1
    fi

    ESSENTIAL_PACKAGES=$(grep -v '^#' configure/essentialpkg.list | tr '\n' ' ')

    case "$PKG_MANAGER" in
        dnf|yum)
            $PKG_MANAGER -y install $ESSENTIAL_PACKAGES --skip-broken --allowerasing
            ;;
        apt|apt-get)
            $PKG_MANAGER -y install $ESSENTIAL_PACKAGES 
            ;;
        pacman)
            $PKG_MANAGER -S --noconfirm $ESSENTIAL_PACKAGES --skip-broken --allowerasing
            ;;
        *)
            echo "Unsupported package manager for installing essential packages."
            exit 1
            ;;
    esac
}

# Function to change boot target to multi-user.target
change_boot_target() {
    if command -v systemctl >/dev/null 2>&1; then
        systemctl set-default multi-user.target
    else
        echo "Systemd not found. Cannot change boot target."
    fi
}

# Function to disable and stop firewall
disable_firewall() {
    if command -v systemctl >/dev/null 2>&1; then
        systemctl stop firewalld 2>/dev/null
        systemctl disable firewalld 2>/dev/null
    elif command -v service >/dev/null 2>&1; then
        service iptables stop 2>/dev/null
        chkconfig iptables off 2>/dev/null
    else
        echo "Cannot disable firewall. Unknown service manager."
    fi
}

# Function to set SELinux to permissive
set_selinux_permissive() {
    if [ -f /etc/selinux/config ]; then
        sed -i 's/^SELINUX=.*/SELINUX=permissive/' /etc/selinux/config
        setenforce 0 2>/dev/null
    else
        echo "SELinux config file not found."
    fi
}

# Function to change DNS
change_dns() {
    DNS_SERVER='168.126.63.1'
    if [ -f /etc/resolv.conf ]; then
        echo "nameserver $DNS_SERVER" > /etc/resolv.conf
    else
        echo "Cannot change DNS. /etc/resolv.conf not found."
    fi
}

# Function to synchronize time
synchronize_time() {
    # Refer to timezone in general.conf
    if [ -f configure/general.conf ]; then
        TIMEZONE=$(grep 'timezone=' configure/general.conf | cut -d'=' -f2)
        if [ -n "$TIMEZONE" ]; then
            if command -v timedatectl >/dev/null 2>&1; then
                timedatectl set-timezone "$TIMEZONE"
            else
                echo "timedatectl not found. Cannot set timezone."
            fi
        else
            echo "Timezone not specified in general.conf"
        fi
    else
        echo "general.conf not found."
    fi

    # Synchronize time
    if command -v timedatectl >/dev/null 2>&1; then
        timedatectl set-ntp true
    elif command -v ntpdate >/dev/null 2>&1; then
        ntpdate pool.ntp.org
    else
        echo "No time synchronization tool found."
    fi
}

# Function to update repositories for old versions
update_old_repositories() {
    # Get the repository files from repolist directory
    REPO_DIR="repolist/$OS_MAJOR_VERSION/$OS_MINOR_VERSION/$OS_PATCH_VERSION"

    # If the exact version is not found, search in order of patch, minor, major
    if [ ! -d "$REPO_DIR" ]; then
        REPO_DIR="repolist/$OS_MAJOR_VERSION/$OS_MINOR_VERSION"
        if [ ! -d "$REPO_DIR" ]; then
            REPO_DIR="repolist/$OS_MAJOR_VERSION"
            if [ ! -d "$REPO_DIR" ]; then
                echo "No suitable repository files found in repolist."
                return
            fi
        fi
    fi

    # Copy the repository files to the appropriate location
    if [ -d /etc/yum.repos.d ]; then
        cp "$REPO_DIR"/*.repo /etc/yum.repos.d/
    elif [ -d /etc/apt ]; then
        cp "$REPO_DIR"/*.list /etc/apt/.s.list.d/ 2>/dev/null
        if [ -f "$REPO_DIR"/.s.list ]; then
            cp "$REPO_DIR"/.s.list /etc/apt/sources.list
        fi
    fi
}

source_mysetup () {
	if [ -f $(pwd)/mySetup.sh ]; then
		. $(pwd)/mySetup.sh
	fi
}

docker_repo_install() {
    if [ -f $(pwd)/repolist/docker/dockerRepoSetup.sh ]; then
        . $(pwd)/repolist/docker/dockerRepoSetup.sh
    fi
}

# Main script execution

get_os_info

select_package_manager

#update_old_repositories

update_repositories

upgrade_packages

install_essential_packages

change_boot_target

disable_firewall

set_selinux_permissive

#change_dns

synchronize_time

source_mysetup

docker_repo_install

echo "System initialization completed successfully."
