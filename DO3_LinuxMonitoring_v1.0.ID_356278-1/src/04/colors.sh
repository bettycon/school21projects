#!/bin/bash

# Цвета по умолчанию
DEFAULT_COLUMN1_BG=6    # Чёрный фон для колонки 1
DEFAULT_COLUMN1_FG=1    # Белый текст для колонки 1
DEFAULT_COLUMN2_BG=2    # Красный фон для колонки 2
DEFAULT_COLUMN2_FG=4    # Синий текст для колонки 2

# Функция получения названия цвета
get_color_name() {
    case "$1" in
        1) echo "white";;
        2) echo "red";;
        3) echo "green";;
        4) echo "blue";;
        5) echo "purple";;
        6) echo "black";;
        *) echo "unknown";;
    esac
}

# Функция проверки цветов
validate_colors() {
    if [ "$1" -eq "$2" ]; then
        echo "Ошибка: Цвет фона и текста не должны совпадать в одной колонке" >&2
        exit 1
    fi
}

# Функция получения ANSI-кодов цвета
get_color_code() {
    case "$1" in
        1) echo "47;97" ;;  # white
        2) echo "41;31" ;;  # red
        3) echo "42;32" ;;  # green
        4) echo "44;34" ;;  # blue
        5) echo "45;35" ;;  # purple
        6) echo "40;30" ;;  # black
        *) echo "Неверный код цвета: $1" >&2; exit 1 ;;
    esac
}

# Функция цветного вывода
print_colored() {
    local name_bg=$1
    local name_fg=$2
    local value_bg=$3
    local value_fg=$4
    local text=$5
    local value=$6

    local name_bg_code=$(get_color_code "$name_bg" | cut -d';' -f1)
    local name_fg_code=$(get_color_code "$name_fg" | cut -d';' -f2)
    local value_bg_code=$(get_color_code "$value_bg" | cut -d';' -f1)
    local value_fg_code=$(get_color_code "$value_fg" | cut -d';' -f2)

    printf "\e[${name_bg_code};${name_fg_code}m%-20s\e[0m" "$text"
    printf "\e[${value_bg_code};${value_fg_code}m%s\e[0m\n" "$value"
}