#!/bin/bash
echo "=== ЗАПУСК SHOPAPI ==="

pkill -f "uvicorn" 2>/dev/null
sudo systemctl stop nginx > /dev/null 2>&1
sleep 1


echo "Запускаем FastAPI серверы..."
cd ~/s21/Backend/BE3_Nginx_Pro.ID_1269323-2/src
source venv/bin/activate
python run.py &
sleep 3


echo "Запускаем Nginx..."
sudo systemctl start nginx
sleep 2

echo "✅ Все запущено!"
echo "Проверка: curl https://shopapi.local/"
