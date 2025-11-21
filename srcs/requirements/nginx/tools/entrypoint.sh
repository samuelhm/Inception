#!/bin/sh
set -e

SSL_DIR="/etc/nginx/ssl"
mkdir -p "$SSL_DIR"

if [ ! -f "$SSL_DIR/nginx.crt" ] || [ ! -f "$SSL_DIR/nginx.key" ]; then
	echo "[INFO] Generando certificado autofirmado para ${DOMAIN}..."
	openssl req -x509 -nodes -days 365 \
		-newkey rsa:2048 \
		-keyout "$SSL_DIR/nginx.key" \
		-out "$SSL_DIR/nginx.crt" \
		-subj "/CN=${DOMAIN}"
fi

echo "[INFO] Arrancando nginx en foreground..."
exec nginx -g "daemon off;"

