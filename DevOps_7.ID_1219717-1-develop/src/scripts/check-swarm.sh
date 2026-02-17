#!/bin/bash

echo "=== Docker Swarm Cluster Status ==="
echo ""

# Проверка на менеджере
if docker node ls &>/dev/null; then
    echo "🐳 Swarm Nodes:"
    docker node ls
    
    echo ""
    echo "🔧 Swarm Services:"
    docker service ls
    
    echo ""
    echo "🐋 Running Containers:"
    docker ps --format "table {{.Names}}\t{{.Image}}\t{{.Status}}\t{{.Ports}}"
else
    echo "This node is not a swarm manager or not in swarm mode"
    echo "Current node: $(hostname)"
fi
