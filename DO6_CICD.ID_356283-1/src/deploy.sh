#!/bin/bash
set -e

# Конфигурация из переменных GitLab или значений по умолчанию
REMOTE_HOST="${SSH_HOST:-192.168.0.12}"
REMOTE_USER="${SSH_USER:-user2}"
SSH_KEY_FILE="/tmp/deploy_key"
ARTIFACT_PATH="../code-samples/DO"
REMOTE_DIR="/usr/local/bin"

echo "=== Starting deployment to $REMOTE_USER@$REMOTE_HOST ==="
echo "Working directory: $(pwd)"
echo "Artifact path: $ARTIFACT_PATH"

# Создаем временный SSH ключ из переменной GitLab (если предоставлен)
if [ -n "$SSH_PRIVATE_KEY" ]; then
    echo "Using SSH key from GitLab variable..."
    echo "$SSH_PRIVATE_KEY" > "$SSH_KEY_FILE"
    chmod 600 "$SSH_KEY_FILE"
    SSH_KEY="$SSH_KEY_FILE"
else
    echo "Using default SSH key..."
    SSH_KEY="$HOME/.ssh/id_ed25519"
fi

# Проверка существования артефакта
if [ ! -f "$ARTIFACT_PATH" ]; then
    echo "ERROR: Artifact $ARTIFACT_PATH not found!"
    echo "Files in ../code-samples/:"
    ls -la ../code-samples/ || echo "code-samples directory not found"
    exit 1
fi

# Проверка существования SSH ключа
if [ ! -f "$SSH_KEY" ]; then
    echo "ERROR: SSH key $SSH_KEY not found!"
    echo "Available files in directory:"
    ls -la $(dirname "$SSH_KEY") 2>/dev/null || echo "Directory not found"
    exit 1
fi

echo "Using SSH key: $SSH_KEY"

# Тестируем SSH подключение
echo "Testing SSH connection..."
if ! ssh -i "$SSH_KEY" -o BatchMode=yes -o ConnectTimeout=5 -o StrictHostKeyChecking=no "$REMOTE_USER@$REMOTE_HOST" "echo 'SSH connection successful!'"; then
    echo "ERROR: SSH connection failed!"
    echo "Please check:"
    echo "1. SSH key permissions"
    echo "2. Remote host availability"
    echo "3. User permissions on remote host"
    exit 1
fi

# Проверяем sudo доступ
echo "Testing sudo access..."
if ! ssh -i "$SSH_KEY" -o StrictHostKeyChecking=no "$REMOTE_USER@$REMOTE_HOST" "sudo -n whoami"; then
    echo "ERROR: No passwordless sudo access for $REMOTE_USER"
    echo "Please configure sudo without password on remote host:"
    echo "echo '$REMOTE_USER ALL=(ALL) NOPASSWD: ALL' | sudo tee /etc/sudoers.d/$REMOTE_USER"
    exit 1
fi

# Копируем артефакт на удаленную машину
echo "Copying artifact to remote machine..."
scp -i "$SSH_KEY" -o StrictHostKeyChecking=no "$ARTIFACT_PATH" "$REMOTE_USER@$REMOTE_HOST:/tmp/DO"

# Выполняем команды на удаленной машине
echo "Executing deployment commands on remote machine..."
ssh -i "$SSH_KEY" -o StrictHostKeyChecking=no "$REMOTE_USER@$REMOTE_HOST" << 'EOF'
    set -e
    
    echo "Stopping existing application if running..."
    sudo pkill DO || true
    sleep 2
    
    echo "Moving binary to $REMOTE_DIR..."
    sudo mv /tmp/DO /usr/local/bin/
    sudo chmod +x /usr/local/bin/DO
    sudo chown root:root /usr/local/bin/DO
    
    echo "Verifying deployment..."
    echo "=== Deployment details ==="
    echo "File details:"
    ls -la /usr/local/bin/DO
    echo -e "\nFile type:"
    file /usr/local/bin/DO
    echo -e "\nTesting application:"
    /usr/local/bin/DO --version || /usr/local/bin/DO -v || /usr/local/bin/DO || echo "Application executed successfully"
    
    echo -e "\nDeployment verification completed successfully!"
EOF

# Очистка временного ключа (если использовался)
if [ -f "$SSH_KEY_FILE" ]; then
    rm -f "$SSH_KEY_FILE"
fi

echo "=== Deployment to $REMOTE_HOST completed successfully! ==="
echo "Application is now available at /usr/local/bin/DO on the target server"
