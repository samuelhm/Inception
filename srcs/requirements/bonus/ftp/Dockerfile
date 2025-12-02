FROM debian:bookworm

RUN apt-get update \
 && apt-get install -y vsftpd \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/*

RUN useradd -m -d /var/www/html -s /bin/bash ftpuser
RUN mkdir -p /var/run/vsftpd/empty && chmod 755 /var/run/vsftpd/empty
COPY conf/vsftpd.conf /etc/vsftpd.conf
COPY tools/entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/entrypoint.sh
CMD ["/usr/local/bin/entrypoint.sh"]

