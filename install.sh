#!/usr/bin/env bash
#
# install.sh — автоматическая установка лимита зарядки для Xiaomi RedmiBook Pro 16 (2025) на Ubuntu 25+.
#
# Запуск:
#   sudo ./install.sh [LIMIT]
# где LIMIT — 40,50,60,70,80 (по умолчанию 70).
#

set -e

LIMIT="${1:-70}"

if ! [[ "$LIMIT" =~ ^(40|50|60|70|80)$ ]]; then
  echo "❌ Неверный лимит: $LIMIT. Допустимые значения: 40 50 60 70 80"
  exit 1
fi

echo "🔧 Устанавливаем зависимости…"
apt update -y
apt install -y dkms build-essential linux-headers-$(uname -r) git

echo "📥 Скачиваем и устанавливаем acpi_call через DKMS…"
if [[ ! -d /usr/src/acpi-call-1.2.2 ]]; then
  git clone https://github.com/nix-community/acpi_call.git /tmp/acpi_call
  cd /tmp/acpi_call
  make dkms.conf
  cp -R . /usr/src/acpi-call-1.2.2
  dkms add -m acpi-call -v 1.2.2
  dkms build -m acpi-call -v 1.2.2
  dkms install -m acpi-call -v 1.2.2
fi

echo "📂 Копируем set_charge_limit.sh в /usr/local/bin…"
install -Dm755 set_charge_limit.sh /usr/local/bin/set_charge_limit.sh

echo "📄 Создаём systemd‑сервис…"
cat >/etc/systemd/system/charge-limit.service <<EOF
[Unit]
Description=Set battery charge limit on boot

[Service]
Type=simple
ExecStart=/usr/local/bin/set_charge_limit.sh $LIMIT
User=root
Group=root

[Install]
WantedBy=multi-user.target
EOF

echo "⚙️ Включаем загрузку модуля acpi_call…"
echo "acpi_call" >/etc/modules-load.d/acpi_call.conf
modprobe acpi_call || true

echo "🚀 Активируем сервис…"
systemctl daemon-reload
systemctl enable --now charge-limit.service

echo "✅ Готово! Лимит зарядки установлен на $LIMIT %."