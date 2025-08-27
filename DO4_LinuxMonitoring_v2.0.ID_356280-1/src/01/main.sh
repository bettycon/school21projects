#!/bin/bash

source ./input_validation.sh
source ./file_operations.sh
source ./logging.sh
source ./utils.sh

main() {
    # Проверка количества параметров
    if [ "$#" -ne 6 ]; then
        echo "Ошибка: Требуется 6 параметров"
        echo "Пример: $0 /путь 4 az 5 az.az 3kb"
        exit 1
    fi

    validate_input "$@" || exit 1
    init_log "${1}/file_generator.log" || exit 1
    create_folders_and_files "$@"
    
    echo "Генерация завершена. Лог: ${1}/file_generator.log"
}

main "$@"
