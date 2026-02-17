#!/bin/bash

# Подключаем модули
source logging.sh
source folder_creation.sh
source file_creation.sh
source cleanup.sh

# Гарантируем очистку при завершении
trap cleanup EXIT

init_log "$@"

START_TIME=$(date +%s.%N)
log_message "НАЧАЛО РАБОТЫ СКРИПТА"
log_message "Параметры запуска: $1 $2 $3"

# Проверка параметров
if [[ $# -ne 3 ]]; then
    log_message "ОШИБКА: Требуется 3 параметра"
    exit 1
fi

# Извлекаем параметры
FOLDER_CHARS=$1
FILE_CHARS=$2
FILE_SIZE=${3%Mb}

# Генерируем имена папок
generate_folder_names "$FOLDER_CHARS" || {
    log_message "ОШИБКА: Не удалось сгенерировать имена папок"
    exit 1
}

# Создаем папки и файлы
while read -r folder_path; do
    if safe_mkdir "$folder_path"; then
        create_files_in_folder "$folder_path" "$FILE_CHARS" "$FILE_SIZE" || {
            log_message "ПРЕДУПРЕЖДЕНИЕ: Проблемы при создании файлов в $folder_path"
        }
    fi
    
    if ! check_free_space; then
        log_message "ПРЕДУПРЕЖДЕНИЕ: Остановка из-за нехватки места"
        break
    fi
done < folder_list.tmp

# Завершение
END_TIME=$(date +%s.%N)
DURATION=$(echo "$END_TIME - $START_TIME" | bc | awk '{printf "%.2f", $0}')
log_message "ВРЕМЯ ВЫПОЛНЕНИЯ: $DURATION сек."
log_message "ЗАВЕРШЕНИЕ РАБОТЫ СКРИПТА"

echo "Скрипт выполнен за $DURATION секунд"
echo "Лог сохранен в: $(pwd)/$LOG_FILE"
