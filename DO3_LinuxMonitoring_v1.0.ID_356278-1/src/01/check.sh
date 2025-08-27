#!/bin/bash

check_arguments() {
    if [ "$#" -ne 1 ]; then
        echo "Ошибка: Требуется ровно один параметр."
        return 1
    fi
    return 0
}

check_not_number() {
    if [[ $1 =~ ^-?[0-9]+([.][0-9]+)?$ ]]; then
        echo "Ошибка: Недопустимый ввод. Числовые значения не разрешены."
        return 1
    fi
    return 0
}