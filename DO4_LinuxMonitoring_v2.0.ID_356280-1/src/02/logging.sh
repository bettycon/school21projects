#!/bin/bash

LOG_FILE="creation_$(date +%d%m%y).log"

init_log() {
    > "$LOG_FILE"
    log_message "========================================"
    log_message "ЛОГ СОЗДАНИЯ ФАЙЛОВ И ПАПОК"
    log_message "Дата: $(date '+%d.%m.%Y %H:%M:%S')"
    log_message "========================================"
}

log_message() {
    local timestamp=$(date '+%d.%m.%Y %H:%M:%S')
    echo "[$timestamp] $1" >> "$LOG_FILE"
    if [[ $1 == "ОШИБКА:"* ]] || [[ $1 == "ПРЕДУПРЕЖДЕНИЕ:"* ]]; then
        echo "[$timestamp] $1"
    fi
}
