#!/bin/bash
# This script fixes the migration issue by marking the initial migration as complete.
# Run this script after your containers are running but before they try to apply migrations.

# Copy the Python fix script into the API container
docker cp /filesystem/Projects/prometheus/dify/api/mark_migrations_complete.py dify-api:/app/api/

# Execute the script inside the container to mark migrations as complete
docker exec dify-api python /app/api/mark_migrations_complete.py

# Now restart the API container to continue with remaining migrations
docker restart dify-api

echo "Migration fix applied. The API container has been restarted."
