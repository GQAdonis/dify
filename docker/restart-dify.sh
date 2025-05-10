#!/bin/bash
# Script to restart Dify Docker Compose services with proper error handling

# Define the Docker Compose file to use
COMPOSE_FILE="docker-compose-fixed.yaml"

error_exit() {
    echo "$1" >&2
    exit 1
}

# Verify script location matches deployment directory
[[ "$PWD" == "/usr/local/src/dify/docker" ]] || error_exit "Script must run in /usr/local/src/dify/docker"

# Verify compose file exists
[[ -f "$COMPOSE_FILE" ]] || error_exit "Docker Compose file $COMPOSE_FILE not found"

# Stop existing containers
docker compose -f $COMPOSE_FILE down || error_exit "Failed to stop containers"

# Start new containers in detached mode
docker compose -f $COMPOSE_FILE up -d || error_exit "Failed to start containers"

# Wait for containers to initialize
sleep 10

# Verify service status
if ! docker compose -f $COMPOSE_FILE ps | grep -q "docker-api"; then
    error_exit "Services failed to start properly"
fi

echo "Dify services successfully restarted. Access at: https://dify.prometheusags.ai"
