#!/bin/sh

retry() {
  local n=1
  local max=$MAX_RETRIES
  local delay=$RETRY_DELAY
  while true; do
    "$@" && break || {
      if [ $n -lt $max ]; then
        n=$((n+1))
        echo "Command failed. Attempt $n/$max:"
        sleep $delay
      else
        echo "The command has failed after $n attempts."
        return 1
      fi
    }
  done
}

for service in adservice emailservice productcatalogservice frontend recommendationservice checkoutservice loadgenerator shippingservice currencyservice paymentservice shoppingassistantservice; do
  if [ -d "$service" ] && [ -f "$service/Dockerfile" ]; then
    retry docker build -t $DOCKER_HUB_USERNAME/$PROJECT_NAME:$service-$CI_COMMIT_SHA ./$service
    
    echo "=== Pushing $service with retries ==="
    retry docker push $DOCKER_HUB_USERNAME/$PROJECT_NAME:$service-$CI_COMMIT_SHA
    
    echo "=== $service completed ==="
  else
    echo "=== Skipping $service - directory or Dockerfile not found ==="
  fi
done
