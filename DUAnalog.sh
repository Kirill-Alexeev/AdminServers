#!/bin/bash

if [ $# -ne 1 ]; then
    echo "Использование: $0 <directory>"
    exit 1
fi

if [ ! -d "$1" ]; then
    echo "Ошибка: '$1' не является директорией или не существует"
    exit 1
fi

human_readable() {
    local bytes=$1
    local units=('B' 'K' 'M' 'G' 'T' 'P')
    local unit=0
    local value=$bytes

    while [ $(echo "$value >= 1024" | bc) -eq 1 ] && [ $unit -lt ${#units[@]} ]; do
        value=$(echo "scale=1; $value / 1024" | bc)
        unit=$((unit + 1))
    done

    if [[ $value == *.0 ]]; then
        value=${value%.0}
    fi

    echo "${value}${units[$unit]}"
}

calculate_dir_size() {
    local dir="$1"
    local size=0

    while read -r filesize; do
        size=$((size + filesize))
    done < <(find "$dir" -type f -printf "%s\n")

    echo "$dir: $(human_readable $size)"
}

find "$1" -type d | while IFS= read -r dir; do
    calculate_dir_size "$dir"
done

exit 0
