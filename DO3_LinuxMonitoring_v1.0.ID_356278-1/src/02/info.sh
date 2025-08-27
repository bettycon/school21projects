#!/bin/bash

info() {
    echo "HOSTNAME = $(hostname)"
    echo "TIMEZONE = $(timedatectl show --property=Timezone --value) $(date +'UTC %:::z')"
    echo "USER = $(whoami)"
    echo "OS = $(grep -oP 'PRETTY_NAME="\K.+(?=")' /etc/os-release)"
    echo "DATE = $(date +'%d %B %Y %H:%M:%S')"
    echo "UPTIME = $(uptime -p | sed 's/up //')"
    echo "UPTIME_SEC = $(awk '{print $1}' /proc/uptime)"
    
    # Получаем информацию для конкретного интерфейса enp0s3
    local interface="enp0s3"
    local net_info=$(ip -o -4 addr show dev "$interface" 2>/dev/null | awk '{print $2, $4}' | head -n1)
    
    if [ -z "$net_info" ]; then
        echo "INTERFACE = $interface (not found)"
        echo "IP = N/A"
        echo "MASK = N/A"
    else
        local ip=$(echo "$net_info" | awk '{print $2}' | cut -d'/' -f1)
        local mask_cidr=$(echo "$net_info" | awk '{print $2}' | cut -d'/' -f2)
        local mask=$(cidr_to_mask "$mask_cidr")
        
        echo "INTERFACE = $interface"
        echo "IP = $ip"
        echo "MASK = $mask"
    fi
    
    echo "GATEWAY = $(ip route | awk '/default/ {print $3}')"
    
    # Информация о памяти
    free -b | awk '
        /Mem:/ {
            printf "RAM_TOTAL = %.3f GB\n", $2/1024/1024/1024
            printf "RAM_USED = %.3f GB\n", $3/1024/1024/1024
            printf "RAM_FREE = %.3f GB\n", $4/1024/1024/1024
        }'
    
    # Информация о корневом разделе
    df -BM / | awk '
        NR==2 {
            printf "SPACE_ROOT = %.2f MB\n", $2
            printf "SPACE_ROOT_USED = %.2f MB\n", $3
            printf "SPACE_ROOT_FREE = %.2f MB\n", $4
        }'
}

# Функция для конвертации CIDR в маску (например, 24 -> 255.255.255.0)
cidr_to_mask() {
    local i mask=""
    local full_octets=$(($1/8))
    local partial_octet=$(($1%8))
    
    for ((i=0; i<4; i++)); do
        if [ $i -lt $full_octets ]; then
            mask+="255"
        elif [ $i -eq $full_octets ]; then
            mask+=$((256 - 2**(8-$partial_octet)))
        else
            mask+="0"
        fi
        
        [ $i -lt 3 ] && mask+="."
    done
    
    echo "$mask"
}