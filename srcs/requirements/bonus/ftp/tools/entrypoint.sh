#!/bin/sh
set -e

FTP_USER="${FTP_USER:-ftpuser}"
FTP_PASS="${FTP_PASS:-changeme}"

# Crear usuario si no existe
if ! id "$FTP_USER" >/dev/null 2>&1; then
    useradd -m -d /var/www/html -s /bin/bash "$FTP_USER"
fi

echo "${FTP_USER}:${FTP_PASS}" | chpasswd

# (Opcional) permisos
# chown -R "$FTP_USER:$FTP_USER" /var/www/html

mkdir -p /var/run/vsftpd/empty
chmod 755 /var/run/vsftpd/empty

exec /usr/sbin/vsftpd /etc/vsftpd.conf

