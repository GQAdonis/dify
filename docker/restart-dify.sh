#!/bin/bash
# Script to restart Dify Docker Compose services with proper error handling


error_exit() {
    echo "$1" >&2
    exit 1
}


# Verify script location matches deployment directory
[[ "$PWD" == "/usr/local/src/dify/docker" ]] || error_exit "Script must run in /usr/local/src/dify/docker"


# Stop existing containers
docker compose down || error_exit "Failed to stop containers"


# Start new containers in detached mode
docker compose up -d || error_exit "Failed to start containers"


# Wait for containers to initialize
sleep 10

# Verify service status
if ! docker compose ps | grep -q "(healthy)"; then
    error_exit "Services failed to start properly"
fi


echo "Dify services successfully restarted. Access at: https://dify.prometheusags.ai"

