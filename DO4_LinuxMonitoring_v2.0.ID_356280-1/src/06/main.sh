#!/bin/bash

# Проверка установки GoAccess
if ! command -v goaccess &> /dev/null; then
    echo "Ошибка: GoAccess не установлен. Установите командой: sudo apt install goaccess"
    exit 1
fi

# Проверка лог-файлов
LOG_DIR="../04/access_logs"
if [ ! -d "$LOG_DIR" ] || [ -z "$(ls -A $LOG_DIR/*.log 2>/dev/null)" ]; then
    echo "Ошибка: В директории $LOG_DIR нет лог-файлов."
    exit 1
fi

# Форматы даты/времени
DATE_FMT="%d/%b/%Y"  # Пример: 25/Dec/2023
TIME_FMT="%T"        # Пример: 15:30:45

# 1. Создаем временный файл только с ошибками 4xx и 5xxx
ERROR_LOG="errors.log"
echo "Фильтрация ошибочных запросов..."
grep -E ' (4[0-9]{2}|5[0-9]{3}) ' $LOG_DIR/*.log > "$ERROR_LOG"

# 2. Генерация HTML-отчёта
echo "Создание отчёта..."
goaccess $LOG_DIR/*.log \
  --log-format='%h - %^[%d:%t %^] "%r" %s "%u"' \
  --date-format="$DATE_FMT" \
  --time-format="$TIME_FMT" \
  --no-query \
  -o report.html

# 3. Консольный отчёт
echo -e "\n=== ОТЧЁТ ПО ЗАДАНИЮ ==="

# Все записи отсортированы по коду ответа
echo -e "\n1. Все коды ответа (отсортированы по частоте):"
awk '{print $NF}' $LOG_DIR/*.log | sort | uniq -c | sort -nr

# Все уникальные IP-адреса
echo -e "\n2. Все уникальные IP-адреса:"
awk '{print $1}' $LOG_DIR/*.log | sort -u

# Все запросы с ошибками (4xx или 5xxx)
echo -e "\n3. Количество ошибочных запросов (4xx или 5xxx):"
[ -s "$ERROR_LOG" ] && wc -l "$ERROR_LOG" || echo "0"

# Уникальные IP среди ошибочных запросов
echo -e "\n4. Уникальные IP среди ошибочных запросов:"
if [ -s "$ERROR_LOG" ]; then
    awk '{print $1}' "$ERROR_LOG" | sort -u
else
    echo "Нет ошибочных запросов"
fi

# Очистка
rm -f "$ERROR_LOG"

# Открытие отчёта
if [ -f "report.html" ]; then
    echo -e "\nОтчёт сформирован: report.html"
    xdg-open report.html 2>/dev/null || echo "Откройте файл вручную: firefox/chrome report.html"
else
    echo "Ошибка генерации отчёта"
    exit 1
fi
