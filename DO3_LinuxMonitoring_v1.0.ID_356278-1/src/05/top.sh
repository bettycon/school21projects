#!/bin/bash

# Функция для форматирования размера
format_size() {
    local size=$1
    if (( size >= 1024 )); then
        echo "$(echo "scale=1; $size/1024" | bc) GB"
    else
        echo "$size MB"
    fi
}

# Топ папок по размеру (с полными путями)
get_top_folders() {
    local path="$1"
    local limit="$2"
    
    # Получаем размеры папок в MB, сортируем, берем топ-N
    du -m --max-depth=1 "$path" 2>/dev/null | sort -nr | head -n $((limit+1)) | tail -n +2 | \
    while read -r size folder; do
        echo "$size $folder"
    done | awk '{
        print NR " - " $2 ", " $1 " MB"
    }'
}

# Топ файлов по размеру с типами
get_top_files() {
    local path="$1"
    local limit="$2"
    
    find "$path" -type f -exec du -m {} + 2>/dev/null | sort -nr | head -n "$limit" | \
    while read -r size file; do
        type=$(file -b "$file" | cut -d, -f1 | head -c 20)
        echo "${size} MB ${file} ${type}"
    done | awk '{
        print NR " - " $3 ", " $1 " " $2 ", " substr($0, index($0,$4))
    }'
}

# Топ исполняемых файлов с хешами
get_top_executables() {
    local path="$1"
    local limit="$2"
    
    count=0
    find "$path" -type f -executable -exec du -m {} + 2>/dev/null | sort -nr | head -n "$limit" | \
    while read -r size file; do
        ((count++))
        hash=$(md5sum "$file" | awk '{print $1}')
        echo "${count} - ${file}, $(format_size $size), ${hash}"
    done
    
    if [ "$count" -eq 0 ]; then
        echo "No executable files found"
    fi
}