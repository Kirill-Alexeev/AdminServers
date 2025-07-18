#!/bin/bash

get_system_info() {
    echo "========================================"
    echo "Текущий рабочий каталог:"
    pwd
    echo "========================================"
    echo "Текущий запущенный процесс:"
    ps -p $$ -o pid,comm
    echo "========================================"
    echo "Домашний каталог:"
    echo $HOME
    echo "========================================"
    echo "Название и версия ОС:"
    . /etc/os-release
    echo $PRETTY_NAME
    echo "========================================"
    echo "Все доступные оболочки:"
    cat /etc/shells
    echo "========================================"
    echo "Текущие пользователи:"
    who
    echo "========================================"
    echo "Количество пользователей:"
    who | wc -l
    echo "========================================"
    echo "Информация о жестких дисках:"
    lsblk
    echo "========================================"
    echo "Информация о процессоре:"
    lscpu
    echo "========================================"
    echo "Информация о памяти:"
    free -h
    echo "========================================"
    echo "Информация о файловой системе:"
    df -h
    echo "========================================"
    echo "Информация об установленных пакетах ПО:"
    dpkg -l
    echo "========================================"
}

if [[ "$1" == "--tofile" && -n "$2" ]]; then
    get_system_info > "$2"
    echo "Информация сохранена в файл: $2"
    exit 0
fi

while true; do
    clear
    echo "Выберите действие:"
    echo "1. Текущий рабочий каталог"
    echo "2. Текущий запущенный процесс"
    echo "3. Домашний каталог"
    echo "4. Название и версия ОС"
    echo "5. Показать все доступные оболочки"
    echo "6. Текущие пользователи"
    echo "7. Количество пользователей"
    echo "8. Информация о жестких дисках"
    echo "9. Информация о процессоре"
    echo "10. Информация о памяти"
    echo "11. Информация о файловой системе"
    echo "12. Информация об установленных пакетах"
    echo "13. Вывести всю информацию"
    echo "14. Выйти"

    read -p "Введите номер пункта: " choice

    case $choice in
	1) echo "Текущий рабочий каталог:"; pwd ;;
        2) echo "Текущий запущенный процесс:"; ps -p $$ -o pid,comm ;;
        3) echo "Домашний каталог:"; echo $HOME ;;
	4) echo "Название и версия ОС:"
	   . /etc/os-release
           echo $PRETTY_NAME
        ;;
	5) echo "Все доступные оболочки:"; cat /etc/shells ;;
        6) echo "Текущие пользователи:"; who ;;
        7) echo "Количество пользователей:"; who | wc -l ;;
        8) echo "Информация о жестких дисках:"; lsblk ;;
        9) echo "Информация о процессоре:"; lscpu ;;
        10) echo "Информация о памяти:"; free -h ;;
        11) echo "Информация о файловой системе:"; df -h ;;
        12) echo "Информация об установленных пакетах ПО:"; dpkg -l ;;
        13) get_system_info ;;
        14) echo "Выход..."; exit 0 ;;
        *) echo "Неверный ввод!" ;;
    esac

    echo -e "\nДля продолжения нажмите Enter..."
    read
done

