#!/usr/bin/env python3

with open("docker-compose-combined.yaml", "r") as f:
    content = f.read()
    
# Fix missing quote issues
content = content.replace('entrypoints=websecure\n', 'entrypoints=websecure"\n')

with open("docker-compose-combined.fixed.yaml", "w") as f:
    f.write(content)

print("Created fixed YAML file: docker-compose-combined.fixed.yaml")
