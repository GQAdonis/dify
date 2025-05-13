#!/bin/bash
# This script resets the Docker environment and starts fresh with the fixes

# Stop the current containers 
echo "Stopping containers..."
cd /filesystem/Projects/prometheus/dify/docker
docker compose -f docker-compose-fixed.yaml down

# List all Docker volumes
echo "\nCurrent Docker volumes:"
docker volume ls

# Remove all docker compose volumes associated with this project
echo "\nRemoving Docker volumes related to Dify..."
docker volume rm $(docker volume ls -q | grep dify) || echo "No Dify volumes found to remove"

# Double-check for any postgres volumes
echo "\nRemoving any PostgreSQL volumes if present..."
docker volume rm $(docker volume ls -q | grep postgres) || echo "No PostgreSQL volumes found to remove"

# Rebuild and start containers
echo "\nRebuilding and starting containers..."
docker compose -f docker-compose-fixed.yaml up -d

# Give some time for the containers to initialize
echo "\nWaiting for services to start..."
sleep 10

echo "\nDocker environment has been reset with a clean database."
echo "Check the logs to confirm everything is working:"
echo "docker compose -f docker-compose-fixed.yaml logs api"
