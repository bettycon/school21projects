#!/bin/bash

validate_input() {
    local path=$1 num_folders=$2 folder_chars=$3 
    local num_files=$4 file_chars=$5 file_size=$6

    # Проверка абсолютного пути
    [[ "$path" =~ ^/ ]] || {
        echo "Ошибка: Путь должен быть абсолютным"
        return 1
    }

    # Проверка параметров
    [[ "$num_folders" =~ ^[1-9][0-9]*$ ]] || {
        echo "Ошибка: Некорректное количество папок"
        return 1
    }

    [[ "$folder_chars" =~ ^[a-zA-Z]{1,7}$ ]] || {
        echo "Ошибка: Символы папок (1-7 английских букв)"
        return 1
    }

    [[ "$num_files" =~ ^[1-9][0-9]*$ ]] || {
        echo "Ошибка: Некорректное количество файлов"
        return 1
    }

    [[ "$file_chars" =~ ^[a-zA-Z]{1,7}\.[a-zA-Z]{1,3}$ ]] || {
        echo "Ошибка: Формат файлов 'name.ext' (name 1-7 букв, ext 1-3 буквы)"
        return 1
    }

    [[ "$file_size" =~ ^([1-9][0-9]?|100)kb$ ]] || {
        echo "Ошибка: Размер файла (1-100kb)"
        return 1
    }

    return 0
}
