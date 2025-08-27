#!/bin/bash

generate_sequence() {
    local chars=$1
    local length=$2
    local first_char=${chars:0:1}
    local last_char=${chars:1:1}
    local result=""
    
    local first_count=$((RANDOM % (length - 1) + 1))
    
    for ((i=0; i<first_count; i++)); do
        result+="$first_char"
    done
    for ((i=first_count; i<length; i++)); do
        result+="$last_char"
    done
    
    echo "$result"
}
