#!/bin/sh
set -e

# Replace environment variables in the Squid configuration template
envsubst < /etc/squid/squid.conf.template > /etc/squid/squid.conf

# Create cache directories if they don't exist
if [ ! -d /var/spool/squid/cache ]; then
    squid -z
fi

# Start Squid in the foreground
exec squid -N -d 1
