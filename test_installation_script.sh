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
