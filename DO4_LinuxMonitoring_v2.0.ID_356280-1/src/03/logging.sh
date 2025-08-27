#!/bin/bash

LOG_FILE="cleanup.log"  # Теперь используем относительный путь

init_cleanup_log() {
    > "$LOG_FILE"  # Очищаем или создаем файл
    echo "=== Лог очистки от $(date '+%d.%m.%Y %H:%M:%S') ===" >> "$LOG_FILE"
}

log_message() {
    local timestamp=$(date '+%d.%m.%Y %H:%M:%S')
    local msg="[$timestamp] $1"
    echo "$msg" >> "$LOG_FILE"
    echo "$msg"  # Дублируем в консоль
}
