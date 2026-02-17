#!/bin/bash

generate_sequence() {
    local chars=$1
    local length=$2
    local first_char=${chars:0:1}
    local last_char=${chars:1:1}
    local result=""
    
    local first_count=$((RANDOM % (length - 1) + 1))
    
    for ((i=0; i<first_count; i++)); do
        result+="$first_char"
    done
    for ((i=first_count; i<length; i++)); do
        result+="$last_char"
    done
    
    echo "$result"
}

generate_folder_names() {
    local chars=$1
    local date_suffix=$(date +%d%m%y)
    rm -f folder_list.tmp
    
    for ((i=1; i<=100; i++)); do
        local length=$((RANDOM % 3 + 5))
        local folder_name=$(generate_sequence "$chars" "$length")
        folder_name="${folder_name}_${date_suffix}"
        
        echo "/tmp/${folder_name}" >> folder_list.tmp
        echo "/var/tmp/${folder_name}" >> folder_list.tmp
        echo "$HOME/${folder_name}" >> folder_list.tmp  # Исправлено с /home/$USER на $HOME
    done
}

safe_mkdir() {
    local path=$1
    if [[ "$path" =~ /bin/ || "$path" =~ /sbin/ ]]; then
        log_message "ОШИБКА: Недопустимый путь $path"
        return 1
    fi
    
    if mkdir -p "$path" 2>/dev/null; then
        log_message "СОЗДАНА ПАПКА: $path"
        return 0
    else
        log_message "ОШИБКА: Не удалось создать папку $path"
        return 1
    fi
}
