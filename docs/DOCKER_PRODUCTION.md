# Dify Docker Production Environment Guide

## Current Production Configuration

The current active production Docker Compose file is:
- **/usr/local/src/dify/docker/docker-compose-fixed.yaml**

This file was created as a fixed version of the original compose file and includes proper network configurations for Traefik integration.

## Current System State (as of May 10, 2025)

The Dify infrastructure has been fully remediated and is now working correctly:

- ✅ All containers have been connected to the `traefik_network`
- ✅ Traefik is able to discover the Dify services and shows them as "UP"
- ✅ API endpoints return proper responses
- ✅ The web UI is accessible and functional
- ✅ The application is fully operational
- ✅ The initial installation page works correctly
- ✅ Authentication methods are properly configured

## Resolved Issues

The following issues have been successfully resolved:

1. **Fixed Network Configuration**
   - Ensured all Dify services are only connected to the `traefik_network`
   - Removed redundant network connections that were causing routing confusion
   - Restarted Traefik to ensure it recognized only the `traefik_network`

2. **Resolved Web UI Access**
   - Fixed the 502 Bad Gateway error for the web UI
   - Created a custom web container image that explicitly listens on all interfaces (0.0.0.0)
   - Updated the Docker Compose configuration to use this image

3. **Fixed API Communication**
   - Set proper environment variables in the web container to communicate with the API service
   - Added explicit configuration for `APP_API_URL` and `CONSOLE_API_URL` variables

4. **DNS Resolution**
   - Added `dify.prometheusags.ai` to the local hosts file to point to `127.0.0.1`
   - This allows testing access to the service via the configured hostname

5. **Fixed Celery Worker Issues**
   - Configured Celery to use Redis as the broker and result backend instead of trying to use RabbitMQ
   - Added environment variables `CELERY_BROKER_URL` and `CELERY_BACKEND` to the shared environment
   - This fixed the installation page spinning indicator issue

6. **Fixed Authentication Method Configuration**
   - Explicitly enabled email/password authentication with `ENABLE_EMAIL_PASSWORD_LOGIN=true`
   - Enabled registration with `ALLOW_REGISTER=true`
   - Enabled workspace creation with `ALLOW_CREATE_WORKSPACE=true`
   - This fixed the "Authentication Method Not Configured" error after login

## Solution Details

### Environment Variable Configuration

The key fix was setting proper environment variables in the web service, Celery configuration, and authentication:

```yaml
x-shared-env: &shared-api-worker-env
  # Other configurations...
  CONSOLE_API_URL: ${CONSOLE_API_URL:-https://dify.prometheusags.ai/api}
  APP_API_URL: ${APP_API_URL:-https://dify.prometheusags.ai/api}
  CELERY_BROKER_URL: redis://:difyai123456@redis:6379/0
  CELERY_BACKEND: redis
  # Authentication configuration
  ENABLE_EMAIL_PASSWORD_LOGIN: "true"
  ALLOW_REGISTER: "true"
  ALLOW_CREATE_WORKSPACE: "true"
```

### Web Service Configuration

```yaml
web:
  image: dify-web-fixed:latest
  restart: always
  environment:
    CONSOLE_API_URL: ${CONSOLE_API_URL:-https://dify.prometheusags.ai/api}
    APP_API_URL: ${APP_API_URL:-https://dify.prometheusags.ai/api}
    MARKETPLACE_API_URL: https://marketplace.dify.ai
  networks:
    - traefik_network
  # Other configuration...
```

### Network Simplification

The web service now only connects to the `traefik_network`, avoiding potential network conflicts:

```yaml
networks:
  - traefik_network
```

### Custom Web Image

A custom web image was created that sets the host binding to `0.0.0.0` to listen on all interfaces:

```
dify-web-fixed:latest
```

The container now properly listens on the `traefik_network` interface instead of just the default Docker network.

## Accessing Dify

To access the deployed Dify application:

1. Ensure DNS resolution for `dify.prometheusags.ai` points to your server's IP address
2. Access the application at https://dify.prometheusags.ai
3. Complete the installation process by following the on-screen instructions
4. Use email/password authentication to log in

## Troubleshooting Guide

If you encounter any issues with the application, try the following:

### Checking Container Status
```bash
# Check running containers and their status
docker ps

# View container logs
docker logs docker-web-1
docker logs docker-api-1
docker logs docker-worker-1
```

### Verifying Network Connectivity
```bash
# Check network configuration
docker network inspect traefik_network

# Verify Traefik routing configuration
curl http://localhost:8080/api/http/services
curl http://localhost:8080/api/http/routers
```

### Testing API Access
```bash
# Test API health endpoint
curl -k https://dify.prometheusags.ai/api/health

# Test direct access to API
docker run --rm -it --network traefik_network nicolaka/netshoot curl http://172.18.0.X:5001/health
```

### Verifying Environment Variables
```bash
# Check web container environment variables
docker exec -it docker-web-1 env | grep API

# Check API container environment variables
docker exec -it docker-api-1 env | grep API

# Check worker environment variables
docker exec -it docker-worker-1 env | grep CELERY

# Check authentication configuration
docker exec -it docker-api-1 env | grep LOGIN
docker exec -it docker-api-1 env | grep REGISTER
```

### Celery Worker Issues
```bash
# Check Celery worker logs
docker logs docker-worker-1

# Verify Redis connection
docker exec -it docker-worker-1 bash -c "cd /app/api && python -c 'from redis import Redis; r=Redis(host=\"redis\", port=6379, password=\"difyai123456\"); print(r.ping())'"
```

### Authentication Issues
```bash
# Check if authentication methods are enabled
docker exec -it docker-api-1 env | grep EMAIL_PASSWORD_LOGIN
docker exec -it docker-api-1 env | grep SOCIAL_OAUTH_LOGIN
docker exec -it docker-api-1 env | grep EMAIL_CODE_LOGIN

# Enable email/password authentication if needed
# Update the docker-compose-fixed.yaml file with:
# ENABLE_EMAIL_PASSWORD_LOGIN: "true"
# ALLOW_REGISTER: "true"
# ALLOW_CREATE_WORKSPACE: "true"
```

Remember that all Dify containers must be on the `traefik_network` to ensure proper communication, the web service must have the correct API URLs configured, and Celery must be configured to use Redis as its broker and result backend. At least one authentication method must be enabled for login to work.

## Service Restart Procedure

A restart script has been configured to properly restart the Dify services using the correct Docker Compose file:

```bash
# Navigate to the Docker directory
cd /usr/local/src/dify/docker

# Run the restart script
./restart-dify.sh
```

The script will:
1. Verify it's being run from the correct directory
2. Check that the Docker Compose file exists
3. Stop all running containers
4. Start containers in detached mode
5. Wait for initialization and verify services are running

This script explicitly uses the `docker-compose-fixed.yaml` configuration file which contains all the fixes described in this documentation.
