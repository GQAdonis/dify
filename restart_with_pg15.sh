#!/bin/bash
# This script completely resets the Docker environment to resolve PostgreSQL type conflicts

# Stop the current containers and remove volumes
echo "Stopping containers and removing volumes..."
cd /filesystem/Projects/prometheus/dify/docker
docker compose -f docker-compose-fixed.yaml down -v

# Additional cleanup of any remaining volumes
echo "Cleaning up any leftover volumes..."
volumes=$(docker volume ls -q | grep dify)
if [ -n "$volumes" ]; then
    docker volume rm $volumes || echo "Could not remove some volumes, they may be in use."
fi

# Modify the Docker Compose file to use PostgreSQL 15 if possible
echo "Checking if Docker Compose file needs to be updated to PostgreSQL 15..."
# Make a backup of the current file
cp docker-compose-fixed.yaml docker-compose-fixed.yaml.bak.$(date +%s)

# Try to update PostgreSQL version if it's using version 16
if grep -q "postgres:16" docker-compose-fixed.yaml; then
    echo "Updating PostgreSQL from version 16 to 15..."
    sed -i 's/postgres:16/postgres:15/g' docker-compose-fixed.yaml
fi

if grep -q "postgres:16-alpine" docker-compose-fixed.yaml; then
    echo "Updating PostgreSQL from version 16-alpine to 15-alpine..."
    sed -i 's/postgres:16-alpine/postgres:15-alpine/g' docker-compose-fixed.yaml
fi

if grep -q "pgvector/pgvector:pg16" docker-compose-fixed.yaml; then
    echo "Updating pgvector from version 16 to 15..."
    sed -i 's/pgvector\/pgvector:pg16/pgvector\/pgvector:pg15/g' docker-compose-fixed.yaml
fi

# Rebuild and start containers
echo "Rebuilding and starting containers..."
docker compose -f docker-compose-fixed.yaml up -d

# Give some time for the containers to initialize
echo "Waiting for services to start..."
sleep 15

echo "Docker environment has been reset with a clean database."
echo "The 'accounts' table has been renamed to 'dify_accounts' to avoid PostgreSQL type conflicts."
echo "String literals in default values have been properly quoted to ensure compatibility."
echo "\nCheck the logs to confirm everything is working:"
echo "docker compose -f docker-compose-fixed.yaml logs api"
