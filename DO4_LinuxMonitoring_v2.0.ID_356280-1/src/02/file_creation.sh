#!/bin/bash

check_free_space() {
    local free_gb=$(df -BG / | awk 'NR==2 {print $4}' | tr -d 'G')
    if [[ "$free_gb" -lt 1 ]]; then
        log_message "ПРЕДУПРЕЖДЕНИЕ: Осталось только ${free_gb}GB свободного места"
        return 1
    fi
    return 0
}

create_files_in_folder() {
    local folder_path=$1
    local file_chars=$2
    local file_size=$3
    
    if [[ ! -d "$folder_path" ]]; then
        log_message "ОШИБКА: Папка $folder_path не существует"
        return 1
    fi

    if [[ ! -w "$folder_path" ]]; then
        log_message "ОШИБКА: Нет прав на запись в $folder_path"
        return 1
    fi

    if [[ "$file_size" -le 0 ]]; then  # Новая проверка
        log_message "ОШИБКА: Размер файла должен быть положительным"
        return 1
    fi

    local file_count=$((RANDOM % 5 + 1))
    log_message "СОЗДАНИЕ $file_count ФАЙЛОВ В: $folder_path"
    
    for ((i=1; i<=file_count; i++)); do
        if ! check_free_space; then
            log_message "ПРЕДУПРЕЖДЕНИЕ: Прерывание из-за нехватки места"
            break
        fi
        
        local name_length=$((RANDOM % 3 + 5))
        local file_name=$(generate_sequence "${file_chars%.*}" "$name_length")
        local file_ext="${file_chars#*.}"
        
        local full_path="${folder_path}/${file_name}_$(date +%d%m%y).${file_ext}"
        
        if dd if=/dev/zero of="$full_path" bs=1M count="$file_size" 2>/dev/null; then
            log_message "СОЗДАН ФАЙЛ: $full_path (${file_size}Mb)"
        else
            log_message "ОШИБКА: Не удалось создать файл $full_path"
            check_free_space || break
        fi
    done
}
