#!/bin/sh
set -e
mkdir -p /var/run/mysqld
mkdir -p /var/lib/mysql
chown -R mysql:mysql var/run/mysqld /var/lib/mysql

sh /usr/local/bin/init_db.sh

exec su mysql -s /bin/sh -c 'mysqld'
