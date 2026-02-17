#!/bin/bash

# Обновление системы
echo "=== Updating system packages ==="
apt-get update
apt-get upgrade -y

# Установка зависимостей
echo "=== Installing dependencies ==="
apt-get install -y \
    apt-transport-https \
    ca-certificates \
    curl \
    gnupg \
    lsb-release \
    software-properties-common

# Добавление Docker репозитория
echo "=== Adding Docker repository ==="
mkdir -p /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | gpg --dearmor -o /etc/apt/keyrings/docker.gpg
echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu jammy stable" | tee /etc/apt/sources.list.d/docker.list > /dev/null

# Установка Docker
echo "=== Installing Docker ==="
apt-get update
apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

# Добавление пользователя vagrant в группу docker
echo "=== Adding vagrant user to docker group ==="
usermod -aG docker vagrant

# Настройка Docker демона
echo "=== Configuring Docker daemon ==="
systemctl enable docker
systemctl start docker

# Установка standalone Docker Compose для совместимости
echo "=== Installing Docker Compose ==="
curl -SL "https://github.com/docker/compose/releases/download/v2.23.0/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose
ln -sf /usr/local/bin/docker-compose /usr/bin/docker-compose

# Настройка прав на рабочую директорию
chown -R vagrant:vagrant /home/vagrant/app

echo "=== Docker installation completed ==="
echo "Docker version: $(docker --version)"
echo "Docker Compose version: $(docker-compose --version)"
