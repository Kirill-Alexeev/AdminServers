#!/bin/bash

if [ $# -ne 2 ]; then
    echo "Использование: $0 <директория_для_архивирования> <директория_для_бэкапов>"
    exit 1
fi

SRC_DIR="$1"
BACKUP_DIR="$2"

if [ ! -d "$SRC_DIR" ]; then
    echo "Ошибка: Исходная директория '$SRC_DIR' не существует или не является директорией"
    exit 1
fi

if [ ! -d "$BACKUP_DIR" ]; then
    echo "Директория для бэкапов '$BACKUP_DIR' не существует. Создаю..."
    mkdir -p "$BACKUP_DIR" || {
        echo "Ошибка: Не удалось создать директорию '$BACKUP_DIR'"
        exit 1
    }
fi

DATE=$(date +%Y-%m-%d_%H-%M-%S)
BACKUP_NAME="backup_$(basename "$SRC_DIR")_$DATE.tar.gz"
BACKUP_PATH="$BACKUP_DIR/$BACKUP_NAME"

tar -czf "$BACKUP_PATH" -C "$(dirname "$SRC_DIR")" "$(basename "$SRC_DIR")"
if [ $? -eq 0 ]; then
    echo "Резервная копия успешно создана: $BACKUP_PATH"
else
    echo "Ошибка: Не удалось создать резервную копию"
    exit 1
fi

OLD_BACKUPS=$(find "$BACKUP_DIR" -type f -name "*.tar.gz" -mtime +7)
if [ -n "$OLD_BACKUPS" ]; then
    find "$BACKUP_DIR" -type f -name "*.tar.gz" -mtime +7 -delete
    if [ $? -eq 0 ]; then
        echo "Архивы старше 7 дней успешно удалены"
    else
        echo "Предупреждение: Не удалось удалить старые архивы"
    fi
fi

exit 0
