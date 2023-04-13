#!/bin/bash
exec > >(tee /var/log/docker.log) 2>&1

# Variables
DOCKER_IMAGE_NAME="your_image_name"
DOCKER_HUB_USERNAME="your_docker_hub_username"
DOCKER_HUB_PASSWORD="your_docker_hub_password"
DOCKER_IMAGE_TAG="latest"

# Build the Docker image
if docker build -t "$DOCKER_IMAGE_NAME:$DOCKER_IMAGE_TAG" . ; then
  echo "Successfully built the Docker image"
else
  echo "Failed to build the Docker image"
  exit 1
fi

# Login to Docker Hub
if docker login -u "$DOCKER_HUB_USERNAME" -p "$DOCKER_HUB_PASSWORD"; then
  echo "Successfully logged in to Docker Hub"
else
  echo "Failed to log in to Docker Hub"
  exit 1
fi

# Push the Docker image to Docker Hub
if docker push "$DOCKER_IMAGE_NAME:$DOCKER_IMAGE_TAG"; then
  echo "Successfully pushed the Docker image to Docker Hub"
else
  echo "Failed to push the Docker image to Docker Hub"
  exit 1
fi

# Deploy the Docker image
if docker run -d -p 80:80 "$DOCKER_IMAGE_NAME:$DOCKER_IMAGE_TAG"; then
  echo "Successfully deployed the Docker image"
else
  echo "Failed to deploy the Docker image"
  exit 1
fi

# Clean up old images
if docker image prune -a -f; then
  echo "Successfully cleaned up old Docker images"
else
  echo "Failed to clean up old Docker images"
  exit 1
fi

# Clean up unused images
if docker image prune -f; then
  echo "Successfully cleaned up unused Docker images"
else
  echo "Failed to clean up unused Docker images"
  exit 1
fi

# Clean up exited containers
if docker container prune -f; then
  echo "Successfully cleaned up exited Docker containers"
else
  echo "Failed to clean up exited Docker containers"
  exit 1
fi

exit 0
