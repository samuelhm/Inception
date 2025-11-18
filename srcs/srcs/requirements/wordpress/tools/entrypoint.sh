#!/bin/sh
set -e

# Si el volumen está vacío, copiar WordPress desde la plantilla
if [ -z "$(ls -A /var/www/html 2>/dev/null)" ]; then
	echo "[INFO] /var/www/html está vacío, copiando WordPress inicial..."
	cp -R /usr/src/wordpress/* /var/www/html/
fi

# Crear directorio de runtime de PHP-FPM
mkdir -p /run/php
chown -R www-data:www-data /run/php

# Asegurar permisos en los ficheros de WordPress
chown -R www-data:www-data /var/www/html

echo "[INFO] Arrancando PHP-FPM..."
exec php-fpm7.4 -F

