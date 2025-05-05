# 🔋 Battery Guard for Redmi Book Pro 16 (2025)

This is a simple Bash script that helps protect your laptop battery by notifying you when it's time to disconnect or connect the charger.  
It’s designed for **Redmi Book Pro 16 (2025)** running **Linux** (e.g., Ubuntu), which does **not support hardware battery charge limit**.

---

## 🇷🇺 Описание на русском

Скрипт помогает продлить срок службы аккумулятора, уведомляя, когда:

- уровень заряда **достигает 80%** (предлагает **отключить зарядку**);
- уровень **падает ниже 40%** (предлагает **подключить зарядку**).

### 🔧 Возможности

- Уведомления через `notify-send`
- Звуковой сигнал (через `paplay`)
- Ведение логов
- Автоматический запуск при старте системы
- Защита от повторного запуска

---

## 🚀 Установка

1. Скопируйте файл `battery-guard.sh` в домашнюю директорию:

```bash
chmod +x ~/battery-guard.sh
```

2. Убедитесь, что установлен `paplay`:

```bash
sudo apt install pulseaudio-utils
```

3. Создайте файл автозапуска:

```bash
mkdir -p ~/.config/autostart
nano ~/.config/autostart/battery-guard.desktop
```

Вставьте:

```ini
[Desktop Entry]
Type=Application
Exec=/home/$USER/battery-guard.sh
Hidden=false
NoDisplay=false
X-GNOME-Autostart-enabled=true
Name=Battery Guard
Comment=Уведомление о заряде/разряде аккумулятора
```

4. Перезагрузите систему — скрипт запустится в фоне.

---

## 📋 Логи

События записываются в файл:
```bash
~/.battery-guard.log
```

---

## 🇬🇧 English Instructions

This script helps preserve battery health by notifying you when:

- charge level **reaches 80%** → suggests **disconnecting** the charger
- charge drops **below 40%** → suggests **connecting** the charger

### 🔧 Features

- Desktop notifications (`notify-send`)
- Sound alert (`paplay`)
- Log file with history
- Auto-start on system boot
- Prevents duplicate background runs

---

## 🚀 Installation

1. Copy `battery-guard.sh` to your home directory:

```bash
chmod +x ~/battery-guard.sh
```

2. Ensure `paplay` is installed:

```bash
sudo apt install pulseaudio-utils
```

3. Create autostart entry:

```bash
mkdir -p ~/.config/autostart
nano ~/.config/autostart/battery-guard.desktop
```

Paste:

```ini
[Desktop Entry]
Type=Application
Exec=/home/$USER/battery-guard.sh
Hidden=false
NoDisplay=false
X-GNOME-Autostart-enabled=true
Name=Battery Guard
Comment=Battery charge/discharge notifier
```

4. Reboot — the script will run in background.

---

## 📜 License

MIT — use freely, improve, and contribute 😊