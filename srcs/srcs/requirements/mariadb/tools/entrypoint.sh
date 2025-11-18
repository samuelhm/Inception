#!/bin/sh
set -e

DATADIR="/var/lib/mysql"

# Asegurar directorios y permisos
mkdir -p /var/run/mysqld "$DATADIR"
chown -R mysql:mysql /var/run/mysqld "$DATADIR"

# Ejecutar script de inicialización (idempotente)
sh /usr/local/bin/init_db.sh

# Arrancar MariaDB como usuario mysql
exec su mysql -s /bin/sh -c "mysqld --datadir=${DATADIR}"

