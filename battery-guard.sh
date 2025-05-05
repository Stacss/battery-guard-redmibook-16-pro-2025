#!/bin/bash

# Пороговые значения
LOW_LIMIT=40
HIGH_LIMIT=80

# Файл лога
LOGFILE="$HOME/.battery-guard.log"

# Путь к звуковому уведомлению (можно заменить)
ALERT_SOUND="/usr/share/sounds/freedesktop/stereo/complete.oga"

# Последнее состояние (для антиспама)
LAST_STATE="none"

# Лог-функция
log() {
  echo "[$(date +'%Y-%m-%d %H:%M:%S')] $1" >> "$LOGFILE"
}

# Проверка, не запущен ли уже другой экземпляр
PIDFILE="/tmp/battery-guard.pid"
if [[ -e "$PIDFILE" ]]; then
  if kill -0 $(cat "$PIDFILE") 2>/dev/null; then
    echo "Скрипт уже запущен с PID $(cat "$PIDFILE")"
    exit 1
  fi
fi
echo $$ > "$PIDFILE"

# Основной цикл
while true; do
  CHARGE=$(cat /sys/class/power_supply/BAT0/capacity)
  STATUS=$(cat /sys/class/power_supply/BAT0/status)

  if [[ "$STATUS" == "Charging" && "$CHARGE" -ge "$HIGH_LIMIT" && "$LAST_STATE" != "full" ]]; then
    notify-send "🔋 Батарея $CHARGE%" "Отключи зарядку — во избежание износа" -i battery
    paplay "$ALERT_SOUND" &
    log "Предупреждение: уровень $CHARGE%, отключи зарядку"
    LAST_STATE="full"
  elif [[ "$STATUS" == "Discharging" && "$CHARGE" -le "$LOW_LIMIT" && "$LAST_STATE" != "low" ]]; then
    notify-send "🔋 Батарея $CHARGE%" "Пора подключить зарядку" -i battery-caution
    paplay "$ALERT_SOUND" &
    log "Предупреждение: уровень $CHARGE%, подключи зарядку"
    LAST_STATE="low"
  elif [[ "$CHARGE" -gt "$LOW_LIMIT" && "$CHARGE" -lt "$HIGH_LIMIT" ]]; then
    LAST_STATE="normal"
  fi

  sleep 60
done
