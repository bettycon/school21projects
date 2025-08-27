#!/bin/bash

generate_ordered_name() {
    local chars="$1"
    local min_length=4
    local name=""
    local length=${#chars}
    
    # 1. Обязательно добавляем все символы по порядку
    for ((i=0; i<length; i++)); do
        name="${name}${chars:i:1}"
    done
    
    # 2. Дополняем до минимальной длины, используя только разрешенные символы
    while [ ${#name} -lt $min_length ]; do
        # Добавляем только последний символ из параметра для сохранения порядка
        name="${name}${chars: -1}"
    done
    
    # 3. Добавляем вариативность, сохраняя порядок
    local extra_chars=$(( RANDOM % 3 )) # 0-2 дополнительных символов
    for ((i=0; i<extra_chars; i++)); do
        # Можно добавлять только символы, которые не нарушат порядок
        name="${name}${chars: -1}"
    done
    
    echo "$name"
}

validate_order() {
    local name="$1"
    local chars="$2"
    
    # Удаляем дату и расширение для проверки
    local base_name="${name%%_*}"
    base_name="${base_name%.*}"
    
    # Создаем регулярное выражение для проверки порядка
    local regex="^"
    for ((i=0; i<${#chars}; i++)); do
        regex+="[${chars:i:1}]*"
    done
    regex+="$"
    
    # Проверяем соответствие шаблону
    [[ "$base_name" =~ $regex ]] && return 0 || return 1
}
