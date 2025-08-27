#!/bin/bash

# Подключаем файл с цветами
source "$(dirname "$0")/colors.sh"

# Путь к конфигурационному файлу
CONFIG_FILE="$(dirname "$0")/config.conf"

# Функция чтения параметра из конфига
get_config_value() {
    local param=$1
    local default_value=$2
    local value
    
    if [ -f "$CONFIG_FILE" ]; then
        value=$(grep "^$param=" "$CONFIG_FILE" | cut -d'=' -f2)
    fi
    
    if [ -z "$value" ]; then
        echo "$default_value"
    else
        echo "$value"
    fi
}

# Получаем цвета из конфига или значения по умолчанию
COLUMN1_BG=$(get_config_value "column1_background" "$DEFAULT_COLUMN1_BG")
COLUMN1_FG=$(get_config_value "column1_font_color" "$DEFAULT_COLUMN1_FG")
COLUMN2_BG=$(get_config_value "column2_background" "$DEFAULT_COLUMN2_BG")
COLUMN2_FG=$(get_config_value "column2_font_color" "$DEFAULT_COLUMN2_FG")

# Проверка цветов
validate_colors "$COLUMN1_BG" "$COLUMN1_FG"
validate_colors "$COLUMN2_BG" "$COLUMN2_FG"

# Сбор системной информации
HOSTNAME=$(hostname)
TIMEZONE="$(timedatectl show --property=Timezone --value) $(date +'UTC %:::z')"
USER=$(whoami)
OS=$(grep -oP 'PRETTY_NAME="\K.+(?=")' /etc/os-release)
DATE=$(date +'%d %B %Y %H:%M:%S')
UPTIME=$(uptime -p | sed 's/up //')
UPTIME_SEC=$(awk '{print $1}' /proc/uptime)

# Получение информации о сети для интерфейса enp0s3
INTERFACE="enp0s3"
NET_INFO=$(ip -o -4 addr show dev "$INTERFACE" 2>/dev/null | awk '{print $2, $4}' | head -n1)

if [ -z "$NET_INFO" ]; then
    IP="N/A (interface $INTERFACE not found)"
    MASK="N/A"
else
    IP=$(echo "$NET_INFO" | awk '{print $2}' | cut -d'/' -f1)
    MASK_CIDR=$(echo "$NET_INFO" | awk '{print $2}' | cut -d'/' -f2)
    MASK=$(awk -v cidr="$MASK_CIDR" 'BEGIN {
        mask = ""
        for (i = 0; i < 4; i++) {
            if (cidr >= 8) {
                mask = mask "255"
                cidr -= 8
            } else {
                mask = mask (256 - 2^(8 - cidr))
                cidr = 0
            }
            if (i < 3) mask = mask "."
        }
        print mask
    }')
fi

GATEWAY=$(ip route | awk '/default/ {print $3}')
RAM_TOTAL=$(free -b | awk '/Mem:/ {printf "%.3f", $2/1024/1024/1024}')
RAM_USED=$(free -b | awk '/Mem:/ {printf "%.3f", $3/1024/1024/1024}')
RAM_FREE=$(free -b | awk '/Mem:/ {printf "%.3f", $4/1024/1024/1024}')
SPACE_ROOT=$(df -BM / | awk 'NR==2 {printf "%.2f", $2}')
SPACE_ROOT_USED=$(df -BM / | awk 'NR==2 {printf "%.2f", $3}')
SPACE_ROOT_FREE=$(df -BM / | awk 'NR==2 {printf "%.2f", $4}')

# Вывод системной информации
echo "System Information:"
print_colored "$COLUMN1_BG" "$COLUMN1_FG" "$COLUMN2_BG" "$COLUMN2_FG" "HOSTNAME" "$HOSTNAME"
print_colored "$COLUMN1_BG" "$COLUMN1_FG" "$COLUMN2_BG" "$COLUMN2_FG" "TIMEZONE" "$TIMEZONE"
print_colored "$COLUMN1_BG" "$COLUMN1_FG" "$COLUMN2_BG" "$COLUMN2_FG" "USER" "$USER"
print_colored "$COLUMN1_BG" "$COLUMN1_FG" "$COLUMN2_BG" "$COLUMN2_FG" "OS" "$OS"
print_colored "$COLUMN1_BG" "$COLUMN1_FG" "$COLUMN2_BG" "$COLUMN2_FG" "DATE" "$DATE"
print_colored "$COLUMN1_BG" "$COLUMN1_FG" "$COLUMN2_BG" "$COLUMN2_FG" "UPTIME" "$UPTIME"
print_colored "$COLUMN1_BG" "$COLUMN1_FG" "$COLUMN2_BG" "$COLUMN2_FG" "UPTIME_SEC" "$UPTIME_SEC"
print_colored "$COLUMN1_BG" "$COLUMN1_FG" "$COLUMN2_BG" "$COLUMN2_FG" "INTERFACE" "$INTERFACE"
print_colored "$COLUMN1_BG" "$COLUMN1_FG" "$COLUMN2_BG" "$COLUMN2_FG" "IP" "$IP"
print_colored "$COLUMN1_BG" "$COLUMN1_FG" "$COLUMN2_BG" "$COLUMN2_FG" "MASK" "$MASK"
print_colored "$COLUMN1_BG" "$COLUMN1_FG" "$COLUMN2_BG" "$COLUMN2_FG" "GATEWAY" "$GATEWAY"
print_colored "$COLUMN1_BG" "$COLUMN1_FG" "$COLUMN2_BG" "$COLUMN2_FG" "RAM_TOTAL" "$RAM_TOTAL GB"
print_colored "$COLUMN1_BG" "$COLUMN1_FG" "$COLUMN2_BG" "$COLUMN2_FG" "RAM_USED" "$RAM_USED GB"
print_colored "$COLUMN1_BG" "$COLUMN1_FG" "$COLUMN2_BG" "$COLUMN2_FG" "RAM_FREE" "$RAM_FREE GB"
print_colored "$COLUMN1_BG" "$COLUMN1_FG" "$COLUMN2_BG" "$COLUMN2_FG" "SPACE_ROOT" "$SPACE_ROOT MB"
print_colored "$COLUMN1_BG" "$COLUMN1_FG" "$COLUMN2_BG" "$COLUMN2_FG" "SPACE_ROOT_USED" "$SPACE_ROOT_USED MB"
print_colored "$COLUMN1_BG" "$COLUMN1_FG" "$COLUMN2_BG" "$COLUMN2_FG" "SPACE_ROOT_FREE" "$SPACE_ROOT_FREE MB"

# Вывод информации о цветовой схеме
echo
echo "Color scheme:"
print_color_info() {
    local param=$1
    local value=$2
    local default_value=$3
    
    if [ "$value" -eq "$default_value" ]; then
        echo "$param = default ($(get_color_name "$value"))"
    else
        echo "$param = $value ($(get_color_name "$value"))"
    fi
}

print_color_info "Column 1 background" "$COLUMN1_BG" "$DEFAULT_COLUMN1_BG"
print_color_info "Column 1 font color" "$COLUMN1_FG" "$DEFAULT_COLUMN1_FG"
print_color_info "Column 2 background" "$COLUMN2_BG" "$DEFAULT_COLUMN2_BG"
print_color_info "Column 2 font color" "$COLUMN2_FG" "$DEFAULT_COLUMN2_FG"