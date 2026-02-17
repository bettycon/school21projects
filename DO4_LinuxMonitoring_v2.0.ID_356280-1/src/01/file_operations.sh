#!/bin/bash

source ./utils.sh

create_folders_and_files() {
    local path="$1" num_folders="$2" folder_chars="$3"
    local num_files="$4" file_chars="$5" file_size="$6"
    local date_suffix=$(date +"%d%m%y")
    local name_part=${file_chars%.*} ext_part=${file_chars#*.}
    local size=${file_size%kb}

    # Очистка и создание основной директории
    rm -rf "${path}" 2>/dev/null
    mkdir -p "${path}" || return 1

    # Создание папок
    for ((i=1; i<=num_folders; i++)); do
        check_free_space || return 1
        
        local folder_name
        local attempts=0
        while true; do
            folder_name="$(generate_ordered_name "$folder_chars")_${date_suffix}"
            
            if validate_order "$folder_name" "$folder_chars" && \
               [ ! -d "${path}/${folder_name}" ]; then
                break
            fi
            
            ((attempts++))
            [ $attempts -gt 100 ] && {
                echo "------------------------------"
                return 1
            }
        done

        mkdir -p "${path}/${folder_name}" || continue
        log_creation "${path}/${folder_name}" "folder"

        # Создание файлов
        for ((j=1; j<=num_files; j++)); do
            check_free_space || break
            
            local file_name
            local file_attempts=0
            while true; do
                file_name="$(generate_ordered_name "$name_part")_${date_suffix}.${ext_part}"
                
                if validate_order "$file_name" "$name_part" && \
                   [ ! -f "${path}/${folder_name}/${file_name}" ]; then
                    break
                fi
                
                ((file_attempts++))
                [ $file_attempts -gt 100 ] && break
            done

            [ $file_attempts -le 100 ] && {
                truncate -s "${size}K" "${path}/${folder_name}/${file_name}" && \
                log_creation "${path}/${folder_name}/${file_name}" "file" "${size}K"
            }
        done
    done
}

check_free_space() {
    [ $(df -k / | awk 'NR==2{print $4}') -gt 1048576 ] || {
        echo "Осталось менее 1GB свободного места. Остановка."
        return 1
    }
    return 0
}
