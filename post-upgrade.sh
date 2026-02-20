#!/bin/sh
echo "Обновляем список пакетов"
apk update
echo "Апгрейдим все пакеты"
apk upgrade
echo "[0/8] Устанавливаем нужные для работы пакеты"
apk add --no-cache jq openssh-sftp-server coreutils-timeout curl
echo "[1/8] Скачивание и распаковка архива payload.tar"
mkdir -p /tmp/rool
wget -qO /tmp/rool/payload.tar https://github.com/rerulon/ax6000/raw/refs/heads/main/payload.tar
echo "[2/8] Распаковка архива payload.tar"
tar -xf /tmp/rool/payload.tar -C /tmp/rool/
echo "[3/8] Копирование profile и banner в /etc"
cp -f /tmp/rool/profile /etc/profile
cp -f /tmp/rool/banner /etc/banner
echo "[4/8] Копирование скриптов в /etc/rool и выдача прав"
mkdir -p /etc/rool
cp -f /tmp/rool/*.sh /etc/rool/
chmod +x /etc/rool/*.sh
echo "[5/8] Настройка задач cron"
CRON_FILE="/etc/crontabs/root"
touch "$CRON_FILE"
if ! grep -q "/etc/rool/pog.sh" "$CRON_FILE"; then
    echo "Добавляем новые задачи в cron..."
    {
        echo "16,35 * * * * /etc/rool/pog.sh >> /tmp/shm/pogoda.log 2>&1"
        echo "17,36 * * * * /etc/rool/esp13.sh >> /tmp/shm/pogoda13.log 2>&1"
        echo "18,37 * * * * /etc/rool/esp14.sh >> /tmp/shm/pogoda14.log 2>&1"
        echo "19,38 * * * * /etc/rool/esp15.sh >> /tmp/shm/pogoda15.log 2>&1"
        cat "$CRON_FILE"
    } > /tmp/cron_temp
    mv /tmp/cron_temp "$CRON_FILE"
    /etc/init.d/cron restart
else
    echo "Задачи cron уже существуют, пропускаем"
fi
echo "[6/8] Установка темы Argon через apk"
apk add --no-cache --allow-untrusted /tmp/rool/argon.apk
echo "[7/8] Очистка временной папки"
rm -rf /tmp/rool
echo "[8/8] Установка podkop"
sh <(wget -O - https://raw.githubusercontent.com/itdoginfo/podkop/refs/heads/main/install.sh)
echo "Восстановление успешно завершено!"
