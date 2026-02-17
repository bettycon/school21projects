#!/bin/bash

LOG_PATTERN="creation_*.log"
CLEANUP_LOG="cleanup_$(date +%d%m%y).log"

# Функция для безопасного удаления
safe_remove() {
    local path=$1
    if [[ -e "$path" ]]; then
        if [[ -d "$path" ]]; then
            rm -rf "$path" && echo "[$(date '+%d.%m.%Y %H:%M:%S')] УДАЛЕНО: $path" >> "$CLEANUP_LOG"
        else
            rm -f "$path" && echo "[$(date '+%d.%m.%Y %H:%M:%S')] УДАЛЕНО: $path" >> "$CLEANUP_LOG"
        fi
    fi
}

# Очистка по лог-файлам
cleanup_by_logs() {
    echo "=== Очистка по лог-файлам ===" >> "$CLEANUP_LOG"
    for log_file in $LOG_PATTERN; do
        [ -f "$log_file" ] || continue
        echo "Обработка лога: $log_file" >> "$CLEANUP_LOG"
        
        grep -oP '(?<=СОЗДАН[АA] ПАПКА: |СОЗДАН ФАЙЛ: )\/[^ ]+' "$log_file" | while read -r path; do
            safe_remove "$path"
        done
    done
}

# Основной процесс
main() {
    echo "Начало очистки в $(date '+%d.%m.%Y %H:%M:%S')" > "$CLEANUP_LOG"
    cleanup_by_logs
    echo "Очистка завершена в $(date '+%d.%m.%Y %H:%M:%S')" >> "$CLEANUP_LOG"
    echo "Лог очистки: $(pwd)/$CLEANUP_LOG"
}

main
