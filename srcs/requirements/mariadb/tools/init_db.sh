#!/bin/sh
set -e

MARKER_FILE="/var/lib/mysql/.initialized"
SOCKET="/var/run/mysqld/mysqld.sock"

if [ ! -f "$MARKER_FILE" ]; then
	echo "[INFO] Ejecutando script de inicialización de MariaDB..."

	# Asegurarnos de que el socket dir existe y tiene permisos
	mkdir -p /var/run/mysqld
	chown -R mysql:mysql /var/run/mysqld

	# Lanzar mysqld en segundo plano sin red, solo por socket
	su mysql -s /bin/sh -c "mysqld --skip-networking --socket=${SOCKET} &"

	# Esperar a que el servidor responda
	echo "[INFO] Esperando a que MariaDB arranque..."
	while ! mysqladmin ping -u root --socket="${SOCKET}" --silent 2>/dev/null; do
		sleep 1
	done

	echo "[INFO] Servidor MariaDB listo, ejecutando SQL de inicialización..."

	# Ejecutar SQL de inicialización
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

	# Apagar el servidor temporal
	mysqladmin --socket="${SOCKET}" -u root -p"${MYSQL_ROOT_PASSWORD}" shutdown

	# Marcar que ya se ha inicializado
	touch "$MARKER_FILE"
	echo "[INFO] Inicialización de MariaDB completada."
else
	echo "[INFO] Base de datos ya inicializada previamente. Saltando script."
fi

