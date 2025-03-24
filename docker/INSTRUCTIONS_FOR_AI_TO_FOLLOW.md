# Dify Plugin System Setup Instructions

## Overview
This document details the setup process for the Dify plugin system, including all required components, build steps, and configuration. The setup involves multiple repositories and custom configurations to enable plugin functionality.

## Required Repositories
1. Main Dify repository (you are here)
2. Dify Plugin Daemon
3. Dify Sandbox
4. Dify Model Provider (for plugin implementation)

## Directory Structure
All components should be cloned into `/usr/local/src/`:
```
/usr/local/src/
├── dify/                    # Main Dify application
├── dify-plugin-daemon/      # Plugin system daemon
├── dify-sandbox/            # Code execution sandbox
└── dify-model-provider/     # Example plugin implementation
```

## Component Setup Steps

### 1. Plugin Daemon Setup
```bash
cd /usr/local/src
git clone https://github.com/langgenius/dify-plugin-daemon.git
cd dify-plugin-daemon
mkdir -p storage persistence cwd plugin .tiktoken
chown -R paperspace:paperspace storage persistence cwd plugin .tiktoken
```

### 2. Sandbox Setup
```bash
cd /usr/local/src
git clone https://github.com/langgenius/dify-sandbox.git
cd dify-sandbox
chmod +x ./build/build_amd64.sh
./build/build_amd64.sh
```

### 3. Model Provider Plugin Setup
```bash
cd /usr/local/src
git clone https://github.com/langgenius/dify-model-provider.git
cd dify-model-provider
cp -r . /usr/local/src/dify-plugin-daemon/plugin/model-provider
chown -R paperspace:paperspace /usr/local/src/dify-plugin-daemon/plugin/model-provider
```

## Docker Compose Configuration
The file `docker-compose.minimal.yaml` in the dify/docker directory contains all necessary service definitions, including:
- Database (PostgreSQL)
- Redis
- Weaviate vector store
- Plugin Daemon
- Sandbox
- API service
- Web interface
- Worker service
- SSRF Proxy

This configuration is crucial as it:
1. Properly connects all components
2. Sets up necessary network isolation
3. Configures volume mounts for persistence
4. Establishes correct dependencies between services
5. Manages environment variables and secrets

## Build and Run Process
1. Build the components:
```bash
cd /usr/local/src/dify/docker
docker compose -f docker-compose.minimal.yaml build
```

2. Start the services:
```bash
docker compose -f docker-compose.minimal.yaml up -d
```

## Important Notes
1. The plugin system requires specific directory structures and permissions
2. The sandbox component requires NVIDIA GPU support
3. All components must be built in the correct order due to dependencies
4. Environment variables and API keys are managed through the compose file
5. Network isolation is implemented using Docker networks

## Troubleshooting
- Check service logs: `docker compose -f docker-compose.minimal.yaml logs [service_name]`
- Verify plugin installation: Check `/app/plugin` directory in plugin_daemon container
- Monitor plugin daemon logs for connectivity issues
- Ensure all required directories exist with correct permissions

## Why This Setup?
This configuration enables:
1. Secure plugin execution in an isolated environment
2. Easy plugin development and deployment
3. Scalable plugin architecture
4. Integration with the main Dify application
5. Safe code execution through the sandbox

This document should be kept updated as the system evolves.
