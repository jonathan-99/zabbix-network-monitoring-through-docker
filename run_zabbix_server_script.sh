#!/bin/bash

# Install Docker and dependencies for Raspberry Pi 5
sudo apt-get update
sudo apt-get install -y apt-transport-https ca-certificates software-properties-common
curl -fsSL https://get.docker.com -o get-docker.sh
sudo sh get-docker.sh
sudo usermod -aG docker $USER

# Install Docker Compose
sudo apt-get install -y libffi-dev libssl-dev python3 python3-pip
sudo pip3 install docker-compose

# Run Docker Compose
docker-compose -f docker-composers/mysql-server.yml \
               -f docker-composers/zabbix-java-gateway.yml \
               -f docker-composers/zabbix-mysql-server.yml \
               -f docker-composers/zabbix-network.yml \
               -f docker-composers/zabbix-web-ng-mysql.yml \
               up -d

# run a test
sudo sh test_installation_script.sh