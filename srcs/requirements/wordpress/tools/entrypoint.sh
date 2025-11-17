#!/bin/sh
set -e

# Crear directorio de runtime de PHP-FPM
mkdir -p /run/php
chown -R www-data:www-data /run/php

# Asegurar permisos en los ficheros de WordPress
chown -R www-data:www-data /var/www/html

echo "[INFO] Arrancando PHP-FPM..."
exec php-fpm7.4 -F

