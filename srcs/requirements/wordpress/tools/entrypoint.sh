#!/bin/sh
set -e

WP_PATH="/var/www/html"
WP_ADMIN_PASSWORD=$(cat /run/secrets/wp_admin_password)
export WORDPRESS_DB_PASSWORD=$(cat /run/secrets/db_password)
SECOND_PASS=$(cat /run/secrets/wp_second_password)

# 1) Si el volumen está vacío, copiar WordPress inicial
if [ -z "$(ls -A "$WP_PATH" 2>/dev/null)" ]; then
	echo "[INFO] $WP_PATH está vacío, copiando WordPress inicial..."
	cp -R /usr/src/wordpress/* "$WP_PATH"/
fi

# 2) Esperar a que MariaDB esté lista
echo "[INFO] Esperando a que MariaDB esté lista..."
until mysqladmin ping -h"${WORDPRESS_DB_HOST}" -u"${WORDPRESS_DB_USER}" -p"${WORDPRESS_DB_PASSWORD}" --silent 2>/dev/null; do
	sleep 1
done
echo "[INFO] MariaDB responde, continuando..."

cd "$WP_PATH"

# 3) Crear wp-config.php si no existe
if [ ! -f "wp-config.php" ]; then
	echo "[INFO] wp-config.php no existe, creándolo con WP-CLI..."
	wp config create \
		--allow-root \
		--dbname="${WORDPRESS_DB_NAME}" \
		--dbuser="${WORDPRESS_DB_USER}" \
		--dbpass="${WORDPRESS_DB_PASSWORD}" \
		--dbhost="${WORDPRESS_DB_HOST}" \
		--path="$WP_PATH"
fi

# 4) Instalar WordPress si aún no está instalado
if ! wp core is-installed --allow-root --path="$WP_PATH" >/dev/null 2>&1; then
	echo "[INFO] WordPress no está instalado, ejecutando wp core install..."
	wp core install \
		--allow-root \
		--url="${WP_URL}" \
		--title="${WP_TITLE}" \
		--admin_user="${WP_ADMIN_USER}" \
		--admin_password="${WP_ADMIN_PASSWORD}" \
		--admin_email="${WP_ADMIN_EMAIL}" \
		--path="$WP_PATH"

	echo "[INFO] Creando segundo usuario de WordPress..."
	wp user create "${WP_SECOND_USER}" "${WP_SECOND_EMAIL}" \
		--user_pass="${SECOND_PASS}" \
		--role=editor \
		--allow-root \
		--path="$WP_PATH"
else
	echo "[INFO] WordPress ya está instalado, saltando instalación."
fi

# 5) Preparar PHP-FPM
mkdir -p /run/php
chown -R www-data:www-data /run/php
chown -R www-data:www-data "$WP_PATH"

echo "[INFO] Arrancando PHP-FPM..."
exec php-fpm8.2 -F

