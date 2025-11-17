FROM debian:bullseye

# Instalar dependencias básicas
RUN apt-get update && \
	apt-get install -y php-fpm php-mysql curl tar && \
	apt-get clean && rm -rf /var/lib/apt/lists/*

# Crear directorio de WordPress
RUN mkdir -p /var/www/html

# Descargar WordPress
RUN curl -o /tmp/wordpress.tar.gz https://wordpress.org/latest.tar.gz && \
	tar -xzf /tmp/wordpress.tar.gz -C /var/www && \
	mv /var/www/wordpress/* /var/www/html && \
	rm -rf /tmp/wordpress.tar.gz /var/www/wordpress

# Copiar configuraciones y scripts
COPY conf/www.conf /etc/php/7.4/fpm/pool.d/www.conf
COPY tools/entrypoint.sh /usr/local/bin/entrypoint.sh

RUN chmod +x /usr/local/bin/entrypoint.sh

EXPOSE 9000

ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]

