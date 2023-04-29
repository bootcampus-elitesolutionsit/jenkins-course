#!/bin/bash

# Get variables from environment
DOCKER_USERNAME="${DOCKER_USERNAME:-dockerhub-username}"
DOCKER_PASSWORD="${DOCKER_PASSWORD:-dockerhub-token}"
SERVER_USERNAME="ubuntu"
SERVER_HOST="34.200.228.201"
datadog_api_key="${DATADOG_API_KEY:-datadog_api_key}"

# Run as non root user
sudo usermod -aG docker $USER
cd $HOME && git clone https://github.com/techstarterepublic-dev/jenkins-course.git

sed "s/\${datadog_api_key}/$datadog_api_key/g" /home/ubuntu/jenkins-course/docker-compose.yml
sed "s/\${datadog_api_key}/$datadog_api_key/g" /home/ubuntu/jenkins-course/datadog-sidecar/datadog.yaml

# Check if variables are set
if [[ -z $DOCKER_USERNAME || -z $DOCKER_PASSWORD || -z $SERVER_USERNAME || -z $SERVER_HOST || -z $datadog_api_key ]]; then
    echo "Error: One or more required variables are not set."
    exit 1
else
    # Run docker-compose on the target server
    cd /home/ubuntu/jenkins-course && docker-compose --env-file <(echo "DD_API_KEY=${datadog_api_key}") up -d
    echo "Deployment successful"
fi