#!/bin/bash

if [[ $# -ne 0 ]]; then
    echo "Скрипт не принимает параметры."
    exit 1
fi

if [[ ! -d "access_logs" ]]; then
    mkdir access_logs || { echo "Не удалось создать директорию access_logs"; exit 1; }
fi

. ./log.sh || { echo "Не удалось загрузить log.sh"; exit 1; }
