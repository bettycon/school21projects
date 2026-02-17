#!/bin/bash

echo "=== Joining Docker Swarm as worker ==="

# Ожидание создания токенов менеджером
while [ ! -f /home/vagrant/app/swarm-tokens/worker-token ]; do
    echo "Waiting for swarm tokens from manager..."
    sleep 10
done

# Чтение токена и адреса менеджера
JOIN_TOKEN=$(cat /home/vagrant/app/swarm-tokens/worker-token)
MANAGER_ADDR=$(cat /home/vagrant/app/swarm-tokens/manager-addr)

echo "Joining swarm with manager: $MANAGER_ADDR"

# Присоединение к Swarm с использованием sudo
sudo docker swarm join --token $JOIN_TOKEN $MANAGER_ADDR

if [ $? -eq 0 ]; then
    echo "=== Successfully joined Docker Swarm ==="
    echo "Node: $(hostname)"
    echo "Role: Worker"
else
    echo "=== Failed to join Docker Swarm ==="
    exit 1
fi
