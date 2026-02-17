#!/bin/bash

source ./input_validation.sh
source ./logging.sh
source ./cleanup_functions.sh

validate_input "$@"

init_cleanup_log

case $1 in
    1) clean_by_log ;;
    2) 
        if [ $# -ge 3 ]; then
            clean_by_date "$2" "$3"
        else
            clean_by_date
        fi
        ;;
    3) clean_by_mask ;;
esac

log_message "Очистка завершена"
echo "Лог сохранен в: $(pwd)/cleanup.log"
