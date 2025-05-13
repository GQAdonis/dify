#!/bin/bash
# This script resets the Docker environment and starts fresh with the fixes

# Stop the current containers and remove volumes
echo "Stopping containers and removing volumes..."
cd /filesystem/Projects/prometheus/dify/docker
docker compose -f docker-compose-fixed.yaml down -v

# Rebuild and start containers
echo "Rebuilding and starting containers..."
docker compose -f docker-compose-fixed.yaml up -d

# Give some time for the containers to initialize
echo "Waiting for services to start..."
sleep 10

echo "Docker environment has been reset with the fixes."
echo "Check the logs to confirm everything is working:"
echo "docker compose -f docker-compose-fixed.yaml logs api"
