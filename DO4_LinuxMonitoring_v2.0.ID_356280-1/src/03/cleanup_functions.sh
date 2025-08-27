#!/bin/bash

clean_by_log() {
    # Правильный путь к лог-файлу из предыдущего проекта
    local log_file="../02/creation_$(date +%d%m%y).log"
    
    # Проверка существования лог-файла с подробным выводом
    log_message "Проверка лог-файла: $log_file"
    if [ ! -f "$log_file" ]; then
        log_message "Ошибка: Файл журнала $log_file не найден"
        log_message "Текущая директория: $(pwd)"
        log_message "Содержимое ../02/: $(ls -l ../02/ 2>&1)"
        return 1
    fi

    log_message "=== Анализ журнала ==="
    
    # Временный файл для проверки существующих путей
    local temp_file=$(mktemp)
    log_message "Создан временный файл: $temp_file"
    
    # Улучшенный парсинг лог-файла
    grep -E 'СОЗДАН[АA] ПАПКА: |СОЗДАН ФАЙЛ: ' "$log_file" | grep -oE '/[^ ]+' |
    while read -r path; do
        if [ -e "$path" ]; then
            echo "$path" >> "$temp_file"
            log_message "[Найден] Объект существует: $path"
        else
            log_message "[Пропущен] Объект отсутствует: $path"
        fi
    done

    log_message "=== Начинаем удаление ==="
    
    local deleted=0
    while read -r path; do
        if [ -f "$path" ]; then
            if rm -f "$path"; then
                log_message "Удален файл: $path"
                ((deleted++))
            else
                log_message "Ошибка удаления файла: $path"
            fi
        elif [ -d "$path" ]; then
            if rm -rf "$path"; then
                log_message "Удалена папка: $path"
                ((deleted++))
            else
                log_message "Ошибка удаления папки: $path"
            fi
        fi
    done < "$temp_file"

    rm -f "$temp_file"
    log_message "Итог: удалено $deleted объектов"
}

clean_by_date() {
    log_message "=== Удаление по дате создания ==="
    
    # Запрос временного интервала
    read -p "Введите начальную дату (формат: YYYY-MM-DD HH:MM): " start_date
    read -p "Введите конечную дату (формат: YYYY-MM-DD HH:MM): " end_date
    
    # Проверка формата дат
    if ! date -d "$start_date" &>/dev/null || ! date -d "$end_date" &>/dev/null; then
        log_message "Ошибка: Неверный формат даты"
        return 1
    fi
    
    local deleted=0
    local search_path="$HOME"
    local temp_file=$(mktemp)
    
    # Поиск и удаление файлов
    find "$search_path" -type f -newermt "$start_date" ! -newermt "$end_date" -name "*_$(date +%d%m%y)" 2>/dev/null > "$temp_file"
    
    while read -r file; do
        if rm -f "$file"; then
            log_message "Удален файл: $file"
            ((deleted++))
        else
            log_message "Ошибка удаления файла: $file"
        fi
    done < "$temp_file"
    
    # Поиск и удаление папок
    find "$search_path" -type d -newermt "$start_date" ! -newermt "$end_date" -name "*_$(date +%d%m%y)" 2>/dev/null > "$temp_file"
    
    while read -r dir; do
        if rm -rf "$dir"; then
            log_message "Удалена папка: $dir"
            ((deleted++))
        else
            log_message "Ошибка удаления папки: $dir"
        fi
    done < "$temp_file"
    
    rm -f "$temp_file"
    log_message "Итог: удалено $deleted объектов"
}

clean_by_mask() {
    log_message "=== Удаление по маске имени ==="
    
    read -p "Введите маску имени (например, 'abc' для файлов вида abc_140825): " mask
    
    if [[ -z "$mask" ]]; then
        log_message "Ошибка: Маска не может быть пустой"
        return 1
    fi
    
    read -p "Вы уверены, что хотите удалить объекты по маске '*${mask}*'? [y/N] " confirm
    if [[ "$confirm" != "y" && "$confirm" != "Y" ]]; then
        log_message "Отмена удаления по маске '$mask'"
        return 0
    fi
    
    local deleted=0
    local search_path="$HOME"
    
    # Создаем временный файл для результатов
    local temp_file=$(mktemp)
    
    # Ищем файлы и записываем во временный файл
    find "$search_path" -maxdepth 3 -type f -name "*${mask}*" 2>/dev/null > "$temp_file"
    
    # Обрабатываем файлы
    while read -r file; do
        if rm -f "$file"; then
            log_message "Удален файл: $file"
            ((deleted++))
        else
            log_message "Ошибка удаления файла: $file"
        fi
    done < "$temp_file"
    
    # Ищем папки и записываем во временный файл
    find "$search_path" -maxdepth 3 -type d -name "*${mask}*" 2>/dev/null > "$temp_file"
    
    # Обрабатываем папки
    while read -r dir; do
        if rm -rf "$dir"; then
            log_message "Удалена папка: $dir"
            ((deleted++))
        else
            log_message "Ошибка удаления папки: $dir"
        fi
    done < "$temp_file"
    
    rm -f "$temp_file"
    log_message "Итог: удалено $deleted объектов"
}
