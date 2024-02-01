#!/bin/bash

# Check if username and IP address are provided as arguments
if [ $# -ne 2 ]; then
    echo "Usage: $0 <username> <remote_host>"
    exit 1
fi

# Assign command-line arguments to variables
REMOTE_USER="$1"
REMOTE_HOST="$2"
REMOTE_SCRIPT="test_installation_script.sh"  # Path to the test script on the remote machine
ZABBIX_PORT=10051  # Port number of the Zabbix server

# Function to run commands remotely via SSH
run_remote_command() {
    ssh "$REMOTE_USER@$REMOTE_HOST" "$1"
}

# Install Docker and dependencies for Raspberry Pi 5
run_remote_command 'sudo apt-get update'
run_remote_command 'sudo apt-get install -y apt-transport-https ca-certificates software-properties-common'
run_remote_command 'curl -fsSL https://get.docker.com -o get-docker.sh'
run_remote_command 'sudo sh get-docker.sh'
run_remote_command 'sudo usermod -aG docker $USER'

# Install Docker Compose
run_remote_command 'sudo apt-get install -y libffi-dev libssl-dev python3 python3-pip'
run_remote_command 'sudo pip3 install docker-compose'

# Run Docker Compose
run_remote_command 'docker-compose -f docker-composers/mysql-server.yml \
               -f docker-composers/zabbix-java-gateway.yml \
               -f docker-composers/zabbix-mysql-server.yml \
               -f docker-composers/zabbix-network.yml \
               -f docker-composers/zabbix-web-ng-mysql.yml \
               up -d'

# Check if Zabbix server is up on its port
echo "Checking if Zabbix server is up..."
while ! nc -z "$REMOTE_HOST" "$ZABBIX_PORT"; do
    echo "Zabbix server is not yet available. Waiting..."
    sleep 10
done
echo "Zabbix server is up and running on port $ZABBIX_PORT."

# Run a test script
run_remote_command "sudo sh $REMOTE_SCRIPT"
