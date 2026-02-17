#!/bin/bash

. ./check.sh
chmod +x ./sort.sh 2>/dev/null
. ./sort.sh

case $1 in
    1) sort_by_code ;;
    2) sort_by_ip ;;
    3) sort_by_errors ;;
    4) sort_by_ip_error ;;
    *) echo "Неизвестный параметр"; exit 1 ;;
esac
