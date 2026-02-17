#!/bin/bash

source "$(dirname "$0")/top.sh"

# Проверка параметров
if [ $# -ne 1 ] || [[ "$1" != */ ]]; then
    echo "Usage: $0 <directory_path/>" >&2
    exit 1
fi

dir_path="$1"
start_time=$(date +%s.%N)

# Проверка директории
if [ ! -d "$dir_path" ]; then
    echo "Error: Directory $dir_path does not exist" >&2
    exit 1
fi

echo "Analyzing directory: $dir_path"

# 1. Количество папок
total_folders=$(find "$dir_path" -type d 2>/dev/null | wc -l)
echo "Total number of folders (including all nested ones) = $total_folders"

# 2. Топ 5 папок (теперь с полными путями)
echo "TOP 5 folders of maximum size arranged in descending order (path and size):"
get_top_folders "$dir_path" 5

# 3. Общее количество файлов
total_files=$(find "$dir_path" -type f 2>/dev/null | wc -l)
echo "Total number of files = $total_files"

# 4. Количество файлов по типам
echo "Number of:"
conf_files=$(find "$dir_path" -type f -name "*.conf" 2>/dev/null | wc -l)
echo "Configuration files (with the .conf extension) = $conf_files"

text_files=$(find "$dir_path" -type f -exec file {} + 2>/dev/null | grep -c "text")
echo "Text files = $text_files"

exec_files=$(find "$dir_path" -type f -executable 2>/dev/null | wc -l)
echo "Executable files = $exec_files"

log_files=$(find "$dir_path" -type f -name "*.log" 2>/dev/null | wc -l)
echo "Log files (with the extension .log) = $log_files"

archive_files=$(find "$dir_path" -type f \( -name "*.zip" -o -name "*.tar*" -o -name "*.gz" \) 2>/dev/null | wc -l)
echo "Archive files = $archive_files"

symlinks=$(find "$dir_path" -type l 2>/dev/null | wc -l)
echo "Symbolic links = $symlinks"

# 5. Топ 10 файлов
echo "TOP 10 files of maximum size arranged in descending order (path, size and type):"
get_top_files "$dir_path" 10

# 6. Топ 10 исполняемых файлов
echo "TOP 10 executable files of the maximum size arranged in descending order (path, size and MD5 hash of file):"
get_top_executables "$dir_path" 10

# 7. Время выполнения
end_time=$(date +%s.%N)
execution_time=$(echo "$end_time - $start_time" | bc | awk '{printf "%.1f", $0}')
echo "Script execution time (in seconds) = $execution_time"