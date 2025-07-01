#!/bin/bash

# Установка лимита зарядки для Xiaomi RedmiBook Pro 16 (2025) под Ubuntu 25+
# Работает через ACPI-вызов \_SB.PC00.WMID.WMAA
# Требует установленного и загруженного модуля acpi_call

ACPI_NODE="\\_SB.PC00.WMID.WMAA"

acpi_call() {
    local command="$1"
    local hex_value="$2"

    local acpi_string="$ACPI_NODE 0x0 0x1 { \
0x00 $command 0x00 0x10 0x02 0x00 $hex_value 0x00 \
0x00 0x00 0x00 0x00 0x00 0x00 0x00 0x00 \
0x00 0x00 0x00 0x00 0x00 0x00 0x00 0x00 \
0x00 0x00 0x00 0x00 0x00 0x00 0x00 0x00 }"

    echo "$acpi_string" | sudo tee /proc/acpi/call > /dev/null
}

set_charge_limit() {
    local limit="$1"
    local hex

    case "$limit" in
        40) hex="0x08" ;;
        50) hex="0x07" ;;
        60) hex="0x06" ;;
        70) hex="0x05" ;;
        80) hex="0x01" ;;
        *) echo "❌ Ошибка: допустимые лимиты — 40, 50, 60, 70, 80"; exit 1 ;;
    esac

    echo "⚙️ Установка лимита зарядки на $limit%"
    acpi_call "0xfb" "$hex"
    sleep 1
    acpi_call "0xfa" "0x00"
    sleep 1
    acpi_call "0xfa" "0x00"
}

disable_charge_limit() {
    echo "🧯 Отключение лимита зарядки"
    acpi_call "0xfb" "0x00"
    sleep 1
    acpi_call "0xfb" "0x00"
}

# Точка входа
if [[ "$1" == "disable" ]]; then
    disable_charge_limit
elif [[ "$1" =~ ^(40|50|60|70|80)$ ]]; then
    set_charge_limit "$1"
else
    echo "Использование: $0 <40|50|60|70|80|disable>"
    exit 1
fi
