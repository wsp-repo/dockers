#!/bin/bash

# скопировать оригинальные конфиги в слинкованные источники
# чтобы при подключении пустых волюмов, появились первичные конфиги
mkdir -p /opt/cron/conf && cp -r -n /opt/cron/orig/* /opt/cron/conf/
mkdir -p /opt/ssmtp/conf && cp -r -n /opt/ssmtp/orig/* /opt/ssmtp/conf/
mkdir -p /opt/php/conf && cp -r -n /opt/php/orig/* /opt/php/conf/

# запускаем супервизор (альтернатива докер директиве CMD)
/usr/bin/supervisord -n -c /etc/supervisor/supervisord.conf
