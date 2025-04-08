#!/bin/bash

:<<'COMMENT'

This script sets up a new user 'coworker' on a Debian-based system.

COMMENT

######## VARIABLES ########

USER_COWORKER="coworker"
USER_COWORKER_PASS=""
DOCKER_DIR="/home/$USER_COWORKER/docker"
SSH_DIR="/home/$USER_COWORKER/.ssh"
AUTHORIZED_KEYS="$SSH_DIR/authorized_keys"
PACKAGES_TO_INSTALL="ufw curl htop vim git unzip zip gnupg apt-transport-https net-tools ncdu fail2ban docker-compose"

# Colors for logs
GREEN="\e[32m"
RED="\e[31m"
NC="\e[0m"

######## FUNCTIONS ########

update_system() {
    echo -e "${GREEN}🔹 Updating system packages...${NC}"
    sudo apt-get update && sudo apt-get upgrade -y
}

install_packages() {
    echo -e "${GREEN}🔹 Installing essential packages...${NC}"
    for package in $PACKAGES_TO_INSTALL; do
        if dpkg -l | grep -q "^ii  $package"; then
            echo -e "${GREEN}✅ $package is already installed.${NC}"
        else
            echo -e "${GREEN}🔹 Installing $package...${NC}"
            sudo apt-get install -y $package
        fi
    done
}

create_user() {
    if id "$USER_COWORKER" &>/dev/null; then
        echo -e "${GREEN}✅ User $USER_COWORKER already exists.${NC}"
    else
        echo "Enter password for user $USER_COWORKER:"
        read -s USER_COWORKER_PASS
        echo -e "${GREEN}🔹 Creating user $USER_COWORKER...${NC}"
        ENCRYPTED_PASS=$(openssl passwd -1 "$USER_COWORKER_PASS")
        sudo useradd -m -s /bin/bash -p "$ENCRYPTED_PASS" "$USER_COWORKER"
        sudo usermod -aG sudo "$USER_COWORKER"
        echo -e "${GREEN}✅ User $USER_COWORKER created and added to the sudo group.${NC}"
    fi
}

install_docker() {
    if ! command -v docker &> /dev/null; then
        echo -e "${GREEN}🔹 Installing Docker...${NC}"
        curl -fsSL https://get.docker.com -o get-docker.sh
        sudo bash get-docker.sh
        rm get-docker.sh
        echo -e "${GREEN}✅ Docker installed.${NC}"
    else
        echo -e "${GREEN}✅ Docker is already installed.${NC}"
    fi
}

add_user_to_docker_group() {
    if groups "$USER_COWORKER" | grep -q "docker"; then
        echo -e "${GREEN}✅ User $USER_COWORKER is already in the docker group.${NC}"
    else
        echo -e "${GREEN}🔹 Adding $USER_COWORKER to the docker group...${NC}"
        sudo usermod -aG docker "$USER_COWORKER"
        echo -e "${GREEN}✅ $USER_COWORKER added to the docker group.${NC}"
    fi
}

create_docker_directory() {
    if [ ! -d "$DOCKER_DIR" ]; then
        echo -e "${GREEN}🔹 Creating directory $DOCKER_DIR...${NC}"
        sudo mkdir -p "$DOCKER_DIR"
        sudo chown -R "$USER_COWORKER":"$USER_COWORKER" "$DOCKER_DIR"
        echo -e "${GREEN}✅ Docker directory created for $USER_COWORKER.${NC}"
    else
        echo -e "${GREEN}✅ Directory $DOCKER_DIR already exists.${NC}"
    fi
}

setup_bash_aliases() {
    echo -e "${GREEN}🔹 Setting up bash aliases for $USER_COWORKER...${NC}"
    wget -P /home/$USER_COWORKER/ https://raw.githubusercontent.com/flebolch/homelab/main/setup_env/bash_aliases
    sudo chown "$USER_COWORKER:$USER_COWORKER" /home/$USER_COWORKER/bash_aliases
    echo -e "${GREEN}✅ Bash aliases set up.${NC}"
}

verify_docker_compose() {
    if ! command -v docker-compose &> /dev/null; then
        echo -e "${RED}❌ Docker Compose installation failed.${NC}"
    else
        echo -e "${GREEN}✅ Docker Compose installed.${NC}"
    fi
}

######## MAIN FUNCTION ########

main() {
    update_system
    install_packages
    create_user
    install_docker
    add_user_to_docker_group
    create_docker_directory
    setup_bash_aliases
    verify_docker_compose
    echo -e "${GREEN}🚀 Installation completed successfully! Connect using: ssh $USER_COWORKER@<IP>${NC}"
}

main