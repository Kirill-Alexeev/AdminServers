#!/bin/bash

if [ $# -ne 1 ]; then
    echo "Использование: $0 <путь_к_директории>"
    exit 1
fi

dir="$1"

if [ ! -d "$dir" ]; then
    echo "Ошибка: '$dir' не является директорией или не существует"
    exit 1
fi

dir=$(realpath "$dir")

cd "$dir" || exit 1

find . -maxdepth 1 -type f | while IFS= read -r file; do
    file="${file#./}"

    if [[ "$file" =~ \.([^./]+)$ ]]; then
        ext="${BASH_REMATCH[1]}"
        ext=$(echo "$ext" | tr '[:upper:]' '[:lower:]')
    else
        ext="no_extension"
    fi

    if [ ! -d "$ext" ]; then
        mkdir "$ext"
        if [ $? -ne 0 ]; then
            echo "Ошибка: не удалось создать папку '$ext'"
            continue
        fi
    fi

    mv "$file" "$ext/"
    if [ $? -eq 0 ]; then
        echo "Перемещён: $file -> $ext/"
    else
        echo "Ошибка: не удалось переместить $file в $ext/"
    fi
done

echo "Сортировка завершена!"

exit 0
