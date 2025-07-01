# 🔋 Xiaomi RedmiBook Pro 16 (2025) — лимит зарядки батареи в Ubuntu 25+

 **Цель** — ограничить заряд аккумулятора ноутбука до 40–80 % для продления его срока службы.

##  Состав репозитория

| Файл | Назначение |
|------|-----------|
| `set_charge_limit.sh` | Скрипт, который включает / отключает лимит зарядки. |
| `install.sh` | Автоматическая установка зависимостей, копирование скрипта, создание systemd‑сервиса. |

##  Быстрый старт

```bash
git clone https://github.com/Stacss/battery-guard-redmibook-16-pro-2025
cd battery-guard-redmibook-16-pro-2025
chmod +x install.sh
sudo ./install.sh 70   # замените 70 на нужный лимит (40 / 50 / 60 / 70 / 80)
```
Далее перезагрузите ноутбук.
После перезагрузки заряд будет автоматически останавливаться на заданном проценте.

##  Ручное использование

```bash
sudo set_charge_limit.sh 60    # установить лимит 60 %
sudo set_charge_limit.sh disable   # снять ограничение
```

Статус батареи:

```bash
cat /sys/class/power_supply/BAT0/capacity
cat /sys/class/power_supply/BAT0/status
```

##  Благодарности

- [ArchWiki — Xiaomi RedmiBook Pro 16 (2025)](https://wiki.archlinux.org/title/Xiaomi_RedmiBook_Pro_16_2025)
- [nix‑community/acpi_call](https://github.com/nix-community/acpi_call)