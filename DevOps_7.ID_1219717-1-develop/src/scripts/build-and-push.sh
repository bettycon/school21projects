#!/bin/bash

echo "=== Building and pushing ALL Docker images to Docker Hub ==="

DOCKER_NAMESPACE="bettycon"
VERSION="1.0.0"

# Теперь 9 сервисов включая database и rabbitmq
SERVICES=(
    "session-service"
    "hotel-service" 
    "booking-service"
    "payment-service"
    "loyalty-service"
    "report-service"
    "gateway-service"
    "database"
    "rabbitmq"
)

./scripts/docker-login.sh

echo "---"

for SERVICE in "${SERVICES[@]}"; do
    echo "🔨 Building $SERVICE..."
    
    if [ ! -d "./services/$SERVICE" ]; then
        echo "❌ Service directory ./services/$SERVICE not found, skipping..."
        continue
    fi
    
    docker build -t $DOCKER_NAMESPACE/$SERVICE:$VERSION ./services/$SERVICE
    docker build -t $DOCKER_NAMESPACE/$SERVICE:latest ./services/$SERVICE
    
    if [ $? -eq 0 ]; then
        echo "✅ Successfully built $SERVICE"
        
        echo "📤 Pushing $SERVICE to Docker Hub..."
        docker push $DOCKER_NAMESPACE/$SERVICE:$VERSION
        docker push $DOCKER_NAMESPACE/$SERVICE:latest
        
        if [ $? -eq 0 ]; then
            echo "✅ Successfully pushed $SERVICE"
        else
            echo "❌ Failed to push $SERVICE"
        fi
    else
        echo "❌ Failed to build $SERVICE"
    fi
    echo "---"
done

echo "=== All 9 images built and pushed successfully ==="
