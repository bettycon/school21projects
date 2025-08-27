#!/bin/bash

cleanup() {
    if [[ -f "folder_list.tmp" ]]; then
        rm -f folder_list.tmp
        log_message "Временный файл folder_list.tmp удален"
    fi
}
