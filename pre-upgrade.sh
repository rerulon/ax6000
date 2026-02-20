#!/bin/sh
# pre-upgrade.sh: Подготовка OpenWrt к обновлению прошивки (apk)

echo "=== Начало подготовки к обновлению ==="

# 1. Остановка сервиса
echo "[1/2] Остановка сервиса podkop..."
if /etc/init.d/podkop stop; then
    echo "Сервис podkop успешно остановлен."
else
    echo "Внимание: не удалось остановить podkop (возможно, он уже остановлен)."
fi

# 2. Удаление пакетов через apk
echo "[2/2] Удаление пакетов podkop и luci-theme-argon..."
# Используем apk del вместо opkg remove
apk del luci-i18n-podkop-ru luci-app-podkop podkop luci-theme-argon

echo "=== Подготовка завершена. Можно накатывать прошивку! ==="
