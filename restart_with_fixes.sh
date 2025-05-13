#!/bin/bash
# This script resets the Docker environment and starts fresh with a schema-based approach

# Stop the current containers 
echo "Stopping containers..."
cd /filesystem/Projects/prometheus/dify/docker
docker compose -f docker-compose-fixed.yaml down

# List all Docker volumes
echo -e "\nCurrent Docker volumes:"
docker volume ls

# Remove all docker compose volumes associated with this project
echo -e "\nRemoving Docker volumes related to Dify..."
docker compose -f docker-compose-fixed.yaml down -v

# Additional step to remove any volume that might be stuck
VOLUMES=$(docker volume ls -q | grep dify)
if [ -n "$VOLUMES" ]; then
    echo "Removing specific Dify volumes: $VOLUMES"
    docker volume rm $VOLUMES || echo "Failed to remove some volumes, they might be in use"
fi

# Rebuild and start containers
echo -e "\nRebuilding and starting containers..."
docker compose -f docker-compose-fixed.yaml up -d

# Give some time for the containers to initialize
echo -e "\nWaiting for services to start..."
sleep 10

echo -e "\nDocker environment has been reset with a clean database."
echo "The application should now create its tables in the 'dify' schema"
echo "to avoid conflicts with PostgreSQL internal types."
echo -e "\nCheck the logs to confirm everything is working:"
echo "docker compose -f docker-compose-fixed.yaml logs api"
