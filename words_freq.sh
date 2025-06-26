#!/bin/bash

if [ $# -ne 3 ]; then
    echo "Использование: $0 <директория> <расширение> <число_слов>"
    exit 1
fi

DIR="$1"
EXT="$2"
TOP_N="$3"

if [ ! -d "$DIR" ]; then
    echo "Ошибка: '$DIR' не является директорией или не существует"
    exit 1
fi

if ! [[ "$TOP_N" =~ ^[0-9]+$ ]] || [ "$TOP_N" -le 0 ]; then
    echo "Ошибка: Топ-N должен быть положительным числом"
    exit 1
fi

FILES=$(find "$DIR" -type f -name "*.$EXT")
if [ -z "$FILES" ]; then
    echo "Ошибка: В директории '$DIR' нет файлов с расширением '$EXT'"
    exit 1
fi

STOPWORDS_FILE="stopwords.txt"
if [ ! -f "$STOPWORDS_FILE" ]; then
    echo "Предупреждение: Файл стоп-слов '$STOPWORDS_FILE' не найден, стоп-слова не будут исключены"
    STOPWORDS=""
else
    STOPWORDS=$(cat "$STOPWORDS_FILE" | tr '[:upper:]' '[:lower:]' | tr '\n' '|' | sed 's/|$//')
fi

declare -A WORD_COUNT

WORD_FOUND=0
while read -r file; do
    WORDS=$(cat "$file" | tr '[:upper:]' '[:lower:]' | tr -d '[:punct:]' | grep -ohE '\w+')
    if [ -n "$WORDS" ]; then
        WORD_FOUND=1
        while read -r word; do
            if [ -n "$STOPWORDS" ] && [[ "$word" =~ ^($STOPWORDS)$ ]]; then
                continue
            fi
            ((WORD_COUNT["$word"]++))
        done <<< "$WORDS"
    fi
done <<< "$FILES"

if [ $WORD_FOUND -eq 0 ]; then
    echo "Ошибка: В файлах с расширением '$EXT' не найдено слов"
    exit 1
fi

for word in "${!WORD_COUNT[@]}"; do
    echo "$word: ${WORD_COUNT[$word]}"
done | sort -t: -k2 -nr | head -n "$TOP_N"

exit 0
