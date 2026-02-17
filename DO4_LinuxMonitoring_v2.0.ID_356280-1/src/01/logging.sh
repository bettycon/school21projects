#!/bin/bash

LOG_FILE=""

init_log() {
    LOG_FILE="$1"
    echo "Лог генерации файлов" > "$LOG_FILE"
    echo "Дата начала: $(date)" >> "$LOG_FILE"
    echo "---------------------------------" >> "$LOG_FILE"
}

log_creation() {
    local path="$1" type="$2" size="${3:-}"
    echo "[$(date)] Создан $type: $path${size:+, размер: $size}" >> "$LOG_FILE"
}
