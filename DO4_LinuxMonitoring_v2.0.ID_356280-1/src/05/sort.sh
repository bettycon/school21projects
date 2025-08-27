#!/bin/bash

function sort_by_code() {
    awk '$9 ~ /^[0-9]+$/ {print $0}' ../04/access_logs/*.log | sort -k 9 -n
}

function sort_by_ip() {
    awk '{print $1}' ../04/access_logs/*.log | sort -u
}

function sort_by_errors() {
    awk '$9 >= 400 && $9 < 600 {print $0}' ../04/access_logs/*.log
}

function sort_by_ip_error() {
    awk '$9 >= 400 && $9 < 600 {print $1}' ../04/access_logs/*.log | sort -u
}
