#!/bin/bash
## 2024-10-13
## RockyLinux 8.10
## dependency
## -- get_os_info()
## -- version_manager

# OS identifier
repo_install() {
    case "$ID" in
        rocky)
            docker_repo_install_rocky
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

repo_install
