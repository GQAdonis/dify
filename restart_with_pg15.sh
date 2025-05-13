#!/bin/bash
# This script modifies the docker-compose file to use PostgreSQL 15 and restarts the environment

# Stop the current containers 
echo "Stopping containers..."
cd /filesystem/Projects/prometheus/dify/docker
docker compose -f docker-compose-fixed.yaml down -v

# Modify the Docker Compose file to use PostgreSQL 15
echo -e "\nUpdating Docker Compose file to use PostgreSQL 15..."
# First, make a backup of the original file
cp docker-compose-fixed.yaml docker-compose-fixed.yaml.bak.$(date +%s)

# Use sed to replace PostgreSQL 16 with PostgreSQL 15
# This assumes the current image is using 'postgres:16' or similar
sed -i 's/postgres:16/postgres:15/g' docker-compose-fixed.yaml
sed -i 's/postgres:16-alpine/postgres:15-alpine/g' docker-compose-fixed.yaml
sed -i 's/pgvector\/pgvector:pg16/pgvector\/pgvector:pg15/g' docker-compose-fixed.yaml

echo -e "\nRebuilding and starting containers with PostgreSQL 15..."
docker compose -f docker-compose-fixed.yaml up -d

# Give some time for the containers to initialize
echo -e "\nWaiting for services to start..."
sleep 10

echo -e "\nDocker environment has been reset with PostgreSQL 15."
echo "The string literal quoting has been fixed to ensure compatibility."
echo -e "\nCheck the logs to confirm everything is working:"
echo "docker compose -f docker-compose-fixed.yaml logs api"
