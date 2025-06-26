#!/bin/bash

RED_BG="\e[41m"
BLUE_BG="\e[46m"
RESET="\e[0m"

print_row() {
    local row=$1
    local size=$2
    local col
    
    for ((col=0; col<size; col++)); do
        if [ $(( (row + col) % 2 )) -eq 0 ]; then
            echo -ne "${RED_BG}  ${RESET}"
        else
            echo -ne "${BLUE_BG}  ${RESET}"
        fi
    done
    echo ""
}

read -p "Введите размер шахматной доски: " size

if ! [[ "$size" =~ ^[0-9]+$ ]] || [ "$size" -le 0 ]; then
    echo -e "Ошибка: введите положительное число"
    exit 1
fi

for ((row=0; row<size; row++)); do
    print_row $row $size
done

exit 0
