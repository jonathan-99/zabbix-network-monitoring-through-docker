#!/bin/bash

# Function to check if a command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Check if Docker is installed
if ! command_exists docker; then
    echo "Error: Docker is not installed. Please install Docker."
    exit 1
fi

# Check if Docker Compose is installed
if ! command_exists docker-compose; then
    echo "Error: Docker Compose is not installed. Please install Docker Compose."
    exit 1
fi

# Install dependencies to use repositories over HTTPS
sudo apt install -y apt-transport-https ca-certificates curl software-properties-common

# Add Docker's official GPG key for Raspberry Pi
curl -fsSL https://download.docker.com/linux/raspbian/gpg | sudo apt-key add -

# Add Docker repository for Raspberry Pi
echo "deb [arch=armhf] https://download.docker.com/linux/raspbian $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list

# Update package lists again to include Docker repository
sudo apt update -y

# Install Docker Community Edition
sudo apt install -y docker-ce

# Add current user to the docker group to run Docker without sudo
sudo usermod -aG docker $USER

# Install Ansible
sudo apt install -y ansible

# Run Docker Compose YAML files
docker-compose -f docker-composers/mysql-server.yml \
               -f docker-composers/zabbix-java-gateway.yml \
               -f docker-composers/zabbix-mysql-server.yml \
               -f docker-composers/zabbix-network.yml \
               -f docker-composers/zabbix-web-ng-mysql.yml \
               up -d

# Check if Docker Compose ran successfully
if [ $? -eq 0 ]; then
    echo "Docker Compose ran successfully."
else
    echo "Error: Docker Compose encountered an error."
    exit 1
fi
curl -s localhost:7000 >/dev/null && echo "Port 7000 is up and serving content" || echo "Port 7000 is either down or not serving content"
