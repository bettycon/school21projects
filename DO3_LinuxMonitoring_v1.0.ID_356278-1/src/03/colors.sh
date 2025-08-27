#!/bin/bash

validate_colors() {
    if [ $1 -eq $2 ] || [ $3 -eq $4 ]; then
        echo "Error: Background and text colors cannot match in the same column" >&2
        echo "Usage: $0 <name_bg> <name_fg> <value_bg> <value_fg>" >&2
        echo "Colors: 1-white, 2-red, 3-green, 4-blue, 5-purple, 6-black" >&2
        exit 1
    fi
}

get_color_code() {
    case $1 in
        1) echo "107;97" ;;  # white background, white text
        2) echo "41;31"  ;;  # red background, red text
        3) echo "42;32"  ;;  # green background, green text
        4) echo "44;34"  ;;  # blue background, blue text
        5) echo "45;35"  ;;  # purple background, purple text
        6) echo "40;30"  ;;  # black background, black text
        *) echo "Invalid color code: $1" >&2; exit 1 ;;
    esac
}

print_colored() {
    local name_bg=$1
    local name_fg=$2
    local value_bg=$3
    local value_fg=$4
    local name=$5
    local value=$6

    local name_bg_code=$(get_color_code $name_bg | cut -d';' -f1)
    local name_fg_code=$(get_color_code $name_fg | cut -d';' -f2)
    local value_bg_code=$(get_color_code $value_bg | cut -d';' -f1)
    local value_fg_code=$(get_color_code $value_fg | cut -d';' -f2)

    printf "\e[${name_bg_code};${name_fg_code}m%-20s\e[0m" "$name"
    printf "\e[${value_bg_code};${value_fg_code}m%s\e[0m\n" "$value"
}