#!/bin/bash

# Подключаем файл с функциями
source "$(dirname "$0")/info.sh"

# Проверяем наличие параметров
if [ $# -ne 0 ]; then
    echo "Ошибка: Скрипт не принимает параметры командной строки." >&2
    exit 1
fi

# Выводим информацию
info

# Запрос на сохранение в файл
read -p "Хотите сохранить данные в файл? (Y/n): " answer

if [[ "$answer" =~ ^[Yy]$ ]] || [[ -z "$answer" ]]; then
    filename=$(date '+%d_%m_%y_%H_%M_%S').status
    info > "$filename"
    echo "Данные сохранены в файл: $filename"
fi