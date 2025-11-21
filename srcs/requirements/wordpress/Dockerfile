FROM debian:bullseye

# Instalar dependencias básicas
RUN apt-get update && \
	apt-get install -y php-fpm php-mysql php-cli curl tar mariadb-client && \
	apt-get clean && rm -rf /var/lib/apt/lists/*

# Directorio base donde guardaremos el WordPress "modelo"
RUN mkdir -p /usr/src/wordpress /var/www/html

# Descargar WordPress en /usr/src/wordpress
RUN curl -o /tmp/wordpress.tar.gz https://wordpress.org/latest.tar.gz && \
	tar -xzf /tmp/wordpress.tar.gz -C /usr/src && \
	rm -rf /tmp/wordpress.tar.gz

# Instalar WP-CLI
RUN curl -o /usr/local/bin/wp https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar && \
	chmod +x /usr/local/bin/wp


# Copiar configuraciones y scripts
COPY conf/www.conf /etc/php/7.4/fpm/pool.d/www.conf
COPY tools/entrypoint.sh /usr/local/bin/entrypoint.sh

RUN chmod +x /usr/local/bin/entrypoint.sh

EXPOSE 9000

ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]

