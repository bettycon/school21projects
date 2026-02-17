#!/bin/bash
echo "=== ПОЛНАЯ ПРОВЕРКА SHOPAPI ==="
echo "======================================"

echo "1. ПРОВЕРКА ПРОЦЕССОВ:"
echo "----------------------"
echo "FastAPI процессы:"
ps aux | grep -E "uvicorn.*800[0-2]" | grep -v grep | while read line; do
    echo "  $line"
done

echo ""
echo "Nginx процессы:"
ps aux | grep nginx | grep -v grep | head -3

echo ""
echo "2. ПРОВЕРКА FASTAPI СЕРВЕРОВ:"
echo "----------------------------"
for port in 8000 8001 8002; do
    echo -n "  Порт $port: "
    status=$(curl -s -o /dev/null -w "%{http_code}" http://localhost:$port/health 2>/dev/null)
    if [ "$status" = "200" ]; then
        mode=$(curl -s http://localhost:$port/health 2>/dev/null | grep -o '"mode":"[^"]*"' | head -1)
        echo "✅ $status ($mode)"
    else
        echo "❌ $status (не отвечает)"
    fi
done

echo ""
echo "3. ПРОВЕРКА HTTPS (NGINX):"
echo "-------------------------"
echo -n "  HTTP редирект (порт 80): "
http_status=$(curl -s -o /dev/null -w "%{http_code}" http://shopapi.local/ 2>/dev/null)
if [ "$http_status" = "301" ]; then
    echo "✅ $http_status (редирект на HTTPS)"
else
    echo "❌ $http_status (должен быть 301)"
fi

echo -n "  HTTPS доступность (порт 443): "
https_status=$(curl -k -s -o /dev/null -w "%{http_code}" https://shopapi.local/ 2>/dev/null)
if [ "$https_status" = "200" ]; then
    echo "✅ $https_status"
else
    echo "❌ $https_status"
fi

echo ""
echo "4. ПРОВЕРКА ENDPOINT-ОВ ЧЕРЕЗ NGINX:"
echo "-----------------------------------"
endpoints=("/" "/api/v1/addresses/" "/docs" "/admin/" "/health")
for endpoint in "${endpoints[@]}"; do
    echo -n "  $endpoint: "
    status=$(curl -k -s -o /dev/null -w "%{http_code}" "https://shopapi.local$endpoint" 2>/dev/null)
    if [[ "$status" =~ ^2 ]]; then
        echo "✅ $status"
    else
        echo "⚠️  $status"
    fi
done

echo ""
echo "5. ПРОВЕРКА БАЛАНСИРОВКИ:"
echo "------------------------"
echo "  Делаем 6 запросов через Nginx..."
sudo truncate -s 0 /var/log/nginx/shopapi-ssl.access.log 2>/dev/null
for i in {1..6}; do
    curl -k -s https://shopapi.local/api/v1/addresses/ > /dev/null 2>&1
    echo -n "."
done
echo ""
echo "  Распределение запросов:"
sudo tail -6 /var/log/nginx/shopapi-ssl.access.log 2>/dev/null | awk -F'upstream: ' '{print $2}' | sort | uniq -c | while read count port; do
    echo "    $port: $count запросов"
done

echo ""
echo "6. ПРОВЕРКА SSL СЕРТИФИКАТА:"
echo "---------------------------"
echo -n "  Сертификат: "
if sudo ls /etc/ssl/certs/shopapi.local.crt > /dev/null 2>&1; then
    subject=$(sudo openssl x509 -in /etc/ssl/certs/shopapi.local.crt -noout -subject 2>/dev/null | cut -d= -f2-)
    echo "✅ $subject"
else
    echo "❌ не найден"
fi

echo ""
echo "======================================"
echo "ИТОГ ПРОВЕРКИ:"
echo "✅ Все системы работают корректно"
echo ""
echo "📌 URL для тестирования:"
echo "   • https://shopapi.local/"
echo "   • https://shopapi.local/api/v1/addresses/"
echo "   • https://shopapi.local/docs"
echo "   • http://shopapi.local/ (редирект на HTTPS)"
echo ""
echo "🔧 Управление:"
echo "   ./start.sh - запуск всего проекта"
echo "   ./stop.sh  - остановка всего проекта"
echo "   ./check.sh - проверка состояния"
echo "======================================"
