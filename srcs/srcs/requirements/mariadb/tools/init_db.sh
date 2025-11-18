#!/bin/sh
set -e

MARKER_FILE="/var/lib/mysql/.initialized"
SOCKET="/var/run/mysqld/mysqld.sock"
DATADIR="/var/lib/mysql"

if [ ! -f "$MARKER_FILE" ]; then
	echo "[INFO] Ejecutando script de inicialización de MariaDB..."

	# Directorios y permisos
	mkdir -p /var/run/mysqld "$DATADIR"
	chown -R mysql:mysql /var/run/mysqld "$DATADIR"

	# 1) Crear tablas del sistema si no existen
	if [ ! -d "$DATADIR/mysql" ]; then
		echo "[INFO] Datadir sin tablas de sistema, ejecutando mariadb-install-db..."
		mariadb-install-db --user=mysql --datadir="$DATADIR" --skip-test-db >/dev/null
		echo "[INFO] mariadb-install-db completado."
	fi

	# 2) Lanzar mysqld temporal sin red, solo socket
	echo "[INFO] Arrancando servidor temporal de MariaDB..."
	su mysql -s /bin/sh -c "mysqld --skip-networking --socket=${SOCKET} &"

	# 3) Esperar a que responda
	echo "[INFO] Esperando a que MariaDB arranque..."
	until mysqladmin ping -u root --socket="${SOCKET}" --silent 2>/dev/null; do
		sleep 1
	done

	echo "[INFO] Servidor MariaDB listo, ejecutando SQL de inicialización..."

	# 4) SQL de inicialización
	mysql --socket="${SOCKET}" -u root <<EOF
CREATE DATABASE IF NOT EXISTS ${MYSQL_DATABASE};
CREATE USER IF NOT EXISTS '${MYSQL_USER}'@'%' IDENTIFIED BY '${MYSQL_PASSWORD}';
CREATE USER IF NOT EXISTS '${MYSQL_SUPERVISOR}'@'%' IDENTIFIED BY '${MYSQL_SUPERVISOR_PASSWORD}';
ALTER USER 'root'@'localhost' IDENTIFIED BY '${MYSQL_ROOT_PASSWORD}';
GRANT ALL PRIVILEGES ON ${MYSQL_DATABASE}.* TO '${MYSQL_USER}'@'%';
GRANT ALL PRIVILEGES ON *.* TO '${MYSQL_SUPERVISOR}'@'%';
FLUSH PRIVILEGES;
EOF

	echo "[INFO] SQL de inicialización ejecutado. Apagando servidor temporal..."
	mysqladmin --socket="${SOCKET}" -u root -p"${MYSQL_ROOT_PASSWORD}" shutdown

	touch "$MARKER_FILE"
	echo "[INFO] Inicialización de MariaDB completada."
else
	echo "[INFO] Base de datos ya inicializada previamente. Saltando script."
fi
