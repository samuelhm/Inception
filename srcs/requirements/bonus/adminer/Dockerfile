FROM debian:bookworm

RUN apt-get update \
 && apt-get install -y php php-cli php-mysql wget ca-certificates \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/*

# 2) Directorio donde serviremos Adminer
RUN mkdir -p /var/www/html \
 && rm -f /var/www/html/index.html \
 && wget -q -O /var/www/html/index.php https://www.adminer.org/latest.php

# 4) Copiar entrypoint que arrancará el servidor PHP embebido
COPY tools/entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/entrypoint.sh

# 6) Arrancar Adminer
CMD ["/usr/local/bin/entrypoint.sh"]

