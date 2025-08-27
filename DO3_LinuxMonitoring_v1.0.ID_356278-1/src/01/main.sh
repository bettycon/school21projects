#!/bin/bash

source "$(dirname "$0")/check.sh"

if ! check_arguments "$@"; then
    exit 1
fi

if ! check_not_number "$1"; then
    exit 1
fi

echo "Введенный параметр: $1"
exit 0