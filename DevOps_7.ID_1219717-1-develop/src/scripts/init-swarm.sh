#!/bin/bash

echo "=== Initializing Docker Swarm on manager01 ==="

# Инициализация Swarm
docker swarm init --advertise-addr 192.168.56.10

# Создание токена для присоединения воркеров
JOIN_TOKEN_WORKER=$(docker swarm join-token -q worker)
JOIN_TOKEN_MANAGER=$(docker swarm join-token -q manager)

# Сохранение токенов в файлы для использования воркерами
mkdir -p /home/vagrant/app/swarm-tokens
echo $JOIN_TOKEN_WORKER > /home/vagrant/app/swarm-tokens/worker-token
echo $JOIN_TOKEN_MANAGER > /home/vagrant/app/swarm-tokens/manager-token
echo "192.168.56.10:2377" > /home/vagrant/app/swarm-tokens/manager-addr

# Настройка прав
chown -R vagrant:vagrant /home/vagrant/app/swarm-tokens

echo "=== Docker Swarm initialized successfully ==="
echo "Manager node: manager01 (192.168.56.10)"
echo "Worker token saved to: /home/vagrant/app/swarm-tokens/worker-token"
echo "Manager token saved to: /home/vagrant/app/swarm-tokens/manager-token"

# Проверка состояния Swarm
echo "=== Swarm status ==="
docker node ls
