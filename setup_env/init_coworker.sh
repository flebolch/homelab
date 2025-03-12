#!/bin/bash

# Define variables
USER_COWORKER="coworker"
DOCKER_DIR="/home/$USER_COWORKER/docker"
SSH_DIR="/home/$USER_COWORKER/.ssh"
AUTHORIZED_KEYS="$SSH_DIR/authorized_keys"

# Colors for logs
GREEN="\e[32m"
RED="\e[31m"
NC="\e[0m"

echo -e "${GREEN}🔹 Updating system packages...${NC}"
sudo apt-get update && sudo apt-get upgrade -y

# List of essential packages
PACKAGES="ufw curl htop vim git unzip zip gnupg apt-transport-https net-tools ncdu fail2ban"

echo -e "${GREEN}🔹 Installing essential packages...${NC}"
for package in $PACKAGES; do
    if dpkg -l | grep -q "^ii  $package"; then
        echo -e "${GREEN}✅ $package is already installed.${NC}"
    else
        echo -e "${GREEN}🔹 Installing $package...${NC}"
        sudo apt-get install -y $package
    fi
done

################## testing befor this line ######################

# Check if user 'coworker' exists, if not, create it
if id "$USER_COWORKER" &>/dev/null; then
    echo -e "${GREEN}✅ User $USER_COWORKER already exists.${NC}"
else
    echo -e "${GREEN}🔹 Creating user $USER_COWORKER...${NC}"
    sudo useradd -m -s /bin/bash "$USER_COWORKER"
    sudo usermod -aG sudo "$USER_COWORKER"
    echo -e "${GREEN}✅ User $USER_COWORKER created and added to the sudo group.${NC}"
fi

# Generate SSH key for 'coworker'
if [ ! -f "$SSH_DIR/id_rsa.pub" ]; then
    echo -e "${GREEN}🔹 Generating SSH key for $USER_COWORKER...${NC}"
    sudo -u "$USER_COWORKER" mkdir -p "$SSH_DIR"
    sudo -u "$USER_COWORKER" ssh-keygen -t rsa -b 4096 -f "$SSH_DIR/id_rsa" -N ""
    sudo chmod 700 "$SSH_DIR"
    sudo chmod 600 "$AUTHORIZED_KEYS"
    echo -e "${GREEN}✅ SSH key generated and stored in $SSH_DIR.${NC}"
else
    echo -e "${GREEN}✅ SSH key already exists.${NC}"
fi

# Install Docker via the official script
if ! command -v docker &> /dev/null; then
    echo -e "${GREEN}🔹 Installing Docker...${NC}"
    curl -fsSL https://get.docker.com -o get-docker.sh
    sudo bash get-docker.sh
    rm get-docker.sh
    echo -e "${GREEN}✅ Docker installed.${NC}"
else
    echo -e "${GREEN}✅ Docker is already installed.${NC}"
fi

# Add 'coworker' to the docker group
if groups "$USER_COWORKER" | grep -q "docker"; then
    echo -e "${GREEN}✅ User $USER_COWORKER is already in the docker group.${NC}"
else
    echo -e "${GREEN}🔹 Adding $USER_COWORKER to the docker group...${NC}"
    sudo usermod -aG docker "$USER_COWORKER"
    echo -e "${GREEN}✅ $USER_COWORKER added to the docker group.${NC}"
fi

# Create the Docker directory inside the home of 'coworker'
if [ ! -d "$DOCKER_DIR" ]; then
    echo -e "${GREEN}🔹 Creating directory $DOCKER_DIR...${NC}"
    sudo mkdir -p "$DOCKER_DIR"
    sudo chown -R "$USER_COWORKER":"$USER_COWORKER" "$DOCKER_DIR"
    echo -e "${GREEN}✅ Docker directory created for $USER_COWORKER.${NC}"
else
    echo -e "${GREEN}✅ Directory $DOCKER_DIR already exists.${NC}"
fi

echo -e "${GREEN}🚀 Installation completed successfully! Connect using: ssh $USER_COWORKER@<IP>${NC}"
