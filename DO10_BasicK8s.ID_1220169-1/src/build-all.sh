#!/bin/bash

echo "╔═══════════════════════════════════════════════╗"
echo "║      СБОРКА ВСЕХ 9 DOCKER ОБРАЗОВ 3.1         ║"
echo "╚═══════════════════════════════════════════════╝"
echo ""

cd ~/s21/DO/DO10_BasicK8s.ID_1220169-1/src

# Все 9 сервисов
SERVICES=(
    "session-service"
    "hotel-service"
    "booking-service"
    "payment-service"
    "loyalty-service"
    "report-service"
    "gateway-service"
    # Инфраструктура
    "database"
    "rabbitmq"
)

# Цвета для вывода
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

TOTAL_SUCCESS=0
TOTAL_FAILED=0
TOTAL_SKIPPED=0

echo "📋 Всего сервисов для сборки: ${#SERVICES[@]}"
echo ""

for service in "${SERVICES[@]}"; do
    echo ""
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    printf "${BLUE}🛠️  Сборка: %-20s ${NC}\n" "$service"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    
    # Определяем имя образа
    if [[ "$service" == *"-service" ]]; then
        image_name="bettycon/${service%%-service}"
        service_dir="services/$service"
    else
        image_name="bettycon/$service"
        service_dir="services/$service"
    fi
    
    echo "📁 Папка: $service_dir"
    echo "🐳 Образ: $image_name:3.1"
    
    # Проверяем существует ли папка
    if [ ! -d "$service_dir" ]; then
        printf "${YELLOW}⚠️  Пропускаем: папка не найдена${NC}\n"
        ((TOTAL_SKIPPED++))
        continue
    fi
    
    cd "$service_dir"
    
    # Для сервисов с кодом (не инфраструктура)
    if [[ "$service" == *"-service" ]]; then
        # 1. Maven сборка
        printf "📦 Этап 1: Maven сборка...\n"
        mvn clean package -DskipTests
        
        if [ $? -ne 0 ]; then
            printf "${RED}❌ ОШИБКА: Maven сборка $service${NC}\n"
            ((TOTAL_FAILED++))
            cd ../..
            continue
        fi
        printf "${GREEN}✅ Maven сборка успешна${NC}\n"
    fi
    
    # 2. Docker сборка
    printf "🐳 Этап 2: Docker сборка...\n"
    docker build -t $image_name:3.1 .
    
    if [ $? -ne 0 ]; then
        printf "${RED}❌ ОШИБКА: Docker сборка $service${NC}\n"
        ((TOTAL_FAILED++))
        cd ../..
        continue
    fi
    printf "${GREEN}✅ Docker образ создан${NC}\n"
    
    # 3. Загрузка в Docker Hub
    printf "☁️  Этап 3: Загрузка в Docker Hub...\n"
    docker push $image_name:3.1
    
    if [ $? -ne 0 ]; then
        printf "${RED}❌ ОШИБКА: Загрузка в Docker Hub $service${NC}\n"
        ((TOTAL_FAILED++))
    else
        printf "${GREEN}✅ Образ загружен в Docker Hub!${NC}\n"
        ((TOTAL_SUCCESS++))
    fi
    
    cd ../..
done

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "📊 ИТОГИ СБОРКИ:"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
printf "${GREEN}✅ Успешно: $TOTAL_SUCCESS${NC}\n"
printf "${RED}❌ Ошибки: $TOTAL_FAILED${NC}\n"
printf "${YELLOW}⚠️  Пропущено: $TOTAL_SKIPPED${NC}\n"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
