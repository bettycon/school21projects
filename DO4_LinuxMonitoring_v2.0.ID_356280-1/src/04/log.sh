#!/bin/bash

function ips() {
    local ip_part
    ip_part="$((RANDOM % 256)).$((RANDOM % 256)).$((RANDOM % 256)).$((RANDOM % 256))"
    echo "$ip_part"
}

codes=("200" "201" "400" "401" "403" "404" "500" "501" "502" "503")
# Коды ответов (описания остаются теми же)

methods=("GET" "POST" "PUT" "PATCH" "DELETE")
agents=("Mozilla" "Google Chrome" "Opera" "Safari" "Internet Explorer" "Microsoft Edge" "Crawler and bot" "Library and net tool")
urls=("/" "/about" "/contact" "/products" "/images" "/api" "/docs" "/admin")

month=$((RANDOM % 12 + 1))  # Исправлено: теперь все 12 месяцев

for i in {1..5}; do
    log_file="./access_logs/access_$(date -d "2023-$month-$i" +"%Y-%m-%d").log"
    touch "$log_file" || { echo "Не удалось создать файл $log_file"; continue; }
    records=$((RANDOM % 901 + 100))

    for (( j = 0; j < records; j++ )); do
        ip=$(ips)
        code=${codes[$((RANDOM % ${#codes[@]}))]}
        method=${methods[$((RANDOM % ${#methods[@]}))]}
        agent=${agents[$((RANDOM % ${#agents[@]}))]}
        url=${urls[$((RANDOM % ${#urls[@]}))]}
        date_and_time=$(LC_TIME=en_US.UTF-8 date -u -d "2023-$month-$i $((RANDOM % 24)):$((RANDOM % 60)):$((RANDOM % 60))" +"%d/%b/%Y:%H:%M:%S")
        size=$((RANDOM % 9000 + 100))
        
        # 50% chance for referer
        if (( RANDOM % 2 )); then
            referer="https://example.com${urls[$((RANDOM % ${#urls[@]}))]}"
        else
            referer="-"
        fi

        echo "$ip - - [$date_and_time +0000] \"$method $url HTTP/1.1\" $code $size \"$referer\" \"$agent\"" >> "$log_file"
    done
    
    # Сортировка по дате и времени
    sort -t '[' -k 2,2 -o "$log_file" "$log_file"
done
