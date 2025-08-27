#!/bin/bash

source "$(dirname "$0")/colors.sh"

if [ $# -ne 4 ]; then
    echo "Usage: $0 <name_bg> <name_fg> <value_bg> <value_fg>" >&2
    echo "Colors (1-6): 1-white, 2-red, 3-green, 4-blue, 5-purple, 6-black" >&2
    exit 1
fi

validate_colors $1 $2 $3 $4

# System information collection
HOSTNAME=$(hostname)
TIMEZONE="$(timedatectl show --property=Timezone --value) $(date +'UTC %:::z')"
USER=$(whoami)
OS=$(grep -oP 'PRETTY_NAME="\K.+(?=")' /etc/os-release)
DATE=$(date +'%d %B %Y %H:%M:%S')
UPTIME=$(uptime -p | sed 's/up //')
UPTIME_SEC=$(awk '{print $1}' /proc/uptime)

# Network information specifically for enp0s3 interface
INTERFACE="enp0s3"
IP=$(ip -o -4 addr show dev $INTERFACE 2>/dev/null | awk '{print $4}' | cut -d'/' -f1)
if [ -z "$IP" ]; then
    IP="No IPv4 address found for $INTERFACE"
fi

MASK=$(ip -o -4 addr show dev $INTERFACE 2>/dev/null | awk '{print $4}' | cut -d'/' -f2 | awk '{
    cidr = $1;
    mask = "";
    for (i = 0; i < 4; i++) {
        if (cidr >= 8) {
            mask = mask "255";
            cidr -= 8;
        } else {
            mask = mask (256 - 2^(8 - cidr));
            cidr = 0;
        }
        if (i < 3) mask = mask ".";
    }
    print mask
}')

if [ -z "$MASK" ]; then
    MASK="No subnet mask found for $INTERFACE"
fi

GATEWAY=$(ip route | awk '/default/ {print $3}')
RAM_TOTAL=$(free -b | awk '/Mem:/ {printf "%.3f", $2/1024/1024/1024}')
RAM_USED=$(free -b | awk '/Mem:/ {printf "%.3f", $3/1024/1024/1024}')
RAM_FREE=$(free -b | awk '/Mem:/ {printf "%.3f", $4/1024/1024/1024}')
SPACE_ROOT=$(df -BM / | awk 'NR==2 {printf "%.2f", $2}')
SPACE_ROOT_USED=$(df -BM / | awk 'NR==2 {printf "%.2f", $3}')
SPACE_ROOT_FREE=$(df -BM / | awk 'NR==2 {printf "%.2f", $4}')

# Colored output
echo "System Information:"
print_colored $1 $2 $3 $4 "HOSTNAME" "$HOSTNAME"
print_colored $1 $2 $3 $4 "TIMEZONE" "$TIMEZONE"
print_colored $1 $2 $3 $4 "USER" "$USER"
print_colored $1 $2 $3 $4 "OS" "$OS"
print_colored $1 $2 $3 $4 "DATE" "$DATE"
print_colored $1 $2 $3 $4 "UPTIME" "$UPTIME"
print_colored $1 $2 $3 $4 "UPTIME_SEC" "$UPTIME_SEC"
print_colored $1 $2 $3 $4 "INTERFACE" "$INTERFACE"
print_colored $1 $2 $3 $4 "IP" "$IP"
print_colored $1 $2 $3 $4 "MASK" "$MASK"
print_colored $1 $2 $3 $4 "GATEWAY" "$GATEWAY"
print_colored $1 $2 $3 $4 "RAM_TOTAL" "$RAM_TOTAL GB"
print_colored $1 $2 $3 $4 "RAM_USED" "$RAM_USED GB"
print_colored $1 $2 $3 $4 "RAM_FREE" "$RAM_FREE GB"
print_colored $1 $2 $3 $4 "SPACE_ROOT" "$SPACE_ROOT MB"
print_colored $1 $2 $3 $4 "SPACE_ROOT_USED" "$SPACE_ROOT_USED MB"
print_colored $1 $2 $3 $4 "SPACE_ROOT_FREE" "$SPACE_ROOT_FREE MB"