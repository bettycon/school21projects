#!/bin/bash

echo "=== Docker Hub Login ==="

DOCKER_USERNAME="bettycon"
DOCKER_PASSWORD="569542025Ww$"

echo "Logging in as: $DOCKER_USERNAME"

# Логин в Docker Hub
echo "$DOCKER_PASSWORD" | docker login --username "$DOCKER_USERNAME" --password-stdin

if [ $? -eq 0 ]; then
    echo "✅ Successfully logged in to Docker Hub as $DOCKER_USERNAME"
else
    echo "❌ Failed to login to Docker Hub"
    exit 1
fi
