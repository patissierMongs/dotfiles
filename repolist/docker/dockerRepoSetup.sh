#!/bin/bash
## 2024-10-13
## RockyLinux 8.10
## ubuntu 24.04.1 LTS
## dependency
## -- get_os_info()
## -- version_manager

# OS identifier
repo_install() {
    case "$ID" in
        rocky)
            docker_repo_install_rocky
            ;;
        ubuntu)
            docker_repo_install_ubuntu
            ;;
        *)
            echo "Unsupported OS yet"
            exit 1
            ;;
    esac
}

docker_repo_install_rocky() {
    yum remove docker \
               docker-client \
               docker-client-latest \
               docker-common \
               docker-latest \
               docker-latest-logrotate \
               docker-engine \
               -y
    yum install yum-utils -y --skip-broken
    yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
    yum clean all
    yum update -y
    yum  install docker-ce \
                docker-ce-cli \
                containerd.io \
                docker-buildx-plugin \
                docker-compose-plugin \
                -y --allowerasing
    curl -L "https://github.com/docker/compose/releases/download/${DOCKER_COMPOSE_VER}/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
    chmod +x /usr/local/bin/docker-compose
}

docker_repo_install_ubuntu() {
    # Uninstall
    for pkg in docker.io docker-doc docker-compose docker-compose-v2 podman-docker containerd runc; do sudo apt-get remove $pkg; done
    # Add Docker's official GPG key:
    sudo apt-get update
    sudo apt-get install ca-certificates curl
    sudo install -m 0755 -d /etc/apt/keyrings
    sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
    sudo chmod a+r /etc/apt/keyrings/docker.asc

    # Add the repository to Apt sources:
    echo \
      "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
      $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
      sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
    sudo apt-get update

    # Install Latest
    sudo apt-get -y install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
}

repo_install
