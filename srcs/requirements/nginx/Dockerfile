FROM debian:bookworm

RUN apt-get update && \
	apt-get install -y nginx openssl && \
	apt-get clean && rm -rf /var/lib/apt/lists/*

# Configuración de nginx
COPY conf/nginx.conf /etc/nginx/nginx.conf
COPY tools/entrypoint.sh /usr/local/bin/entrypoint.sh

RUN chmod +x /usr/local/bin/entrypoint.sh

ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]

