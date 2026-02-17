#!/bin/bash
echo "=== ОСТАНОВКА SHOPAPI ==="


echo "Останавливаем FastAPI серверы..."
pkill -f "uvicorn" 2>/dev/null
pkill -f "python.*run.py" 2>/dev/null
sleep 1


pkill -9 -f "uvicorn" 2>/dev/null
pkill -9 -f "run.py" 2>/dev/null


echo "Останавливаем Nginx..."
sudo systemctl stop nginx > /dev/null 2>&1

echo "✅ Все остановлено"
