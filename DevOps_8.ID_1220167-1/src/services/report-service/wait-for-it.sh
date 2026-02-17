#!/bin/sh

# Wait for a service to become available
# Usage: wait-for-it.sh host:port [-t timeout] [-- command args]
#   -t TIMEOUT, --timeout=TIMEOUT  Timeout in seconds, zero for no timeout
#   -- COMMAND ARGS             Execute command with args after the test finishes

timeout=120
while [ $# -gt 0 ]; do
    case "$1" in
        *:* )
        host=$(echo "$1" | cut -d: -f1)
        port=$(echo "$1" | cut -d: -f2)
        shift 1
        ;;
        -t)
        timeout="$2"
        if [ "$timeout" = "" ]; then break; fi
        shift 2
        ;;
        --timeout=*)
        timeout="${1#*=}"
        shift 1
        ;;
        --)
        shift
        break
        ;;
        *)
        echo "Unknown argument: $1"
        exit 1
        ;;
    esac
done

if [ -z "$host" ] || [ -z "$port" ]; then
    echo "Error: you need to provide a host and port to test." >&2
    exit 1
fi

echo "Waiting for $host:$port to be available..."

for i in $(seq 1 $timeout); do
    if nc -z "$host" "$port" >/dev/null 2>&1; then
        echo "$host:$port is available!"
        if [ $# -gt 0 ]; then
            exec "$@"
        fi
        exit 0
    fi
    sleep 1
done

echo "Timeout: $host:$port is not available after $timeout seconds" >&2
exit 1
