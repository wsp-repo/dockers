FROM debian:bookworm-slim

RUN apt update && apt install -y \
    lsb-release ca-certificates curl ssmtp cron supervisor \
    php8.2-fpm php8.2-curl php8.2-gd php8.2-http php8.2-imagick \
    php8.2-imap php8.2-intl php8.2-mailparse php8.2-mbstring php8.2-mcrypt \
    php8.2-memcache php8.2-memcached php8.2-mysql php8.2-pgsql php8.2-raphf \
    php8.2-redis php8.2-uuid php8.2-xml php8.2-xmlrpc php8.2-xsl php8.2-zip \
    mc

RUN apt clean && rm -rf /var/lib/apt/lists/*

# подготовка системы в целом
RUN echo 'Europe/Moscow' > /etc/timezone && \
    ln -sf /usr/share/zoneinfo/Europe/Moscow /etc/localtime

# подготовка SSMTP
RUN mkdir -p /opt/ssmtp/conf && \
    cp -r -n /etc/ssmtp/* /opt/ssmtp/conf/ && \
    rm -f -r -d /etc/ssmtp && ln -s /opt/ssmtp/conf /etc/ssmtp
RUN mkdir -p /opt/ssmtp/orig && cp -r -n /opt/ssmtp/conf/* /opt/ssmtp/orig/
RUN mkdir -p /var/log/ssmtp

# подготовка PHP-FPM
RUN mkdir -p /opt/php/conf/cli && \
    mv /etc/php/8.2/cli/php.ini /opt/php/conf/cli/ && \
    ln -s /opt/php/conf/cli/php.ini /etc/php/8.2/cli/php.ini
RUN mkdir -p /opt/php/conf/fpm && \
    mv /etc/php/8.2/fpm/php.ini /etc/php/8.2/fpm/php-fpm.conf /etc/php/8.2/fpm/pool.d /opt/php/conf/fpm/ && \
    ln -s /opt/php/conf/fpm/php-fpm.conf /etc/php/8.2/fpm/php-fpm.conf && \
    ln -s /opt/php/conf/fpm/php.ini /etc/php/8.2/fpm/php.ini && \
    ln -s /opt/php/conf/fpm/pool.d /etc/php/8.2/fpm/pool.d
# тут делаем некоторые перенастройки значений конфигов в более точные
RUN sed -i -e "s|;*short_open_tag\s*=.*|short_open_tag = On|g" /opt/php/conf/fpm/php.ini && \
    sed -i -e "s|;*allow_url_fopen\s*=.*|allow_url_fopen = Off|g" /opt/php/conf/fpm/php.ini && \
    sed -i -e "s|;*date\.timezone\s*=.*|date\.timezone = Europe/Moscow|g" /opt/php/conf/fpm/php.ini && \
    sed -i -e "s|;*SMTP\s*=.*|;SMTP = localhost|g" /opt/php/conf/fpm/php.ini && \
    sed -i -e "s|;*smtp_port\s*=.*|;smtp_port = 25|g" /opt/php/conf/fpm/php.ini && \
    sed -i -e "s|;*sendmail_path\s*=.*|sendmail_path = /usr/sbin/sendmail -t|g" /opt/php/conf/fpm/php.ini && \
    sed -i -e "s|;*daemonize\s*=.*|daemonize = no|g" /opt/php/conf/fpm/php-fpm.conf && \
    sed -i -e "s|listen\s*=.*|listen = 9000|g" /opt/php/conf/fpm/pool.d/www.conf && \
    sed -i -e "s|;*chdir\s*=.*|chdir = /www|g" /opt/php/conf/fpm/pool.d/www.conf && \
    sed -i -e "s|;*clear_env\s*=.*|clear_env = no|g" /opt/php/conf/fpm/pool.d/www.conf && \
    sed -i -e "s|;*catch_workers_output\s*=.*|catch_workers_output = yes|g" /opt/php/conf/fpm/pool.d/www.conf;
RUN mkdir -p /opt/php/orig && cp -r -n /opt/php/conf/* /opt/php/orig/
RUN ln -s /usr/sbin/php-fpm8.2 /usr/bin/php-fpm
RUN mkdir -p /var/log/php

# подготовка CRON
COPY ./crontabs/cron /etc/cron.d/cron
RUN mkdir -p /opt/cron/conf/crontabs && \
    rm -f -r -d /var/spool/cron/crontabs && \
    ln -s /opt/cron/conf/crontabs /var/spool/cron/crontabs
RUN chmod 0644 /etc/cron.d/cron && crontab -u www-data /etc/cron.d/cron
RUN mkdir -p /opt/cron/orig && cp -r -n /opt/cron/conf/* /opt/cron/orig/
RUN mkdir -p /var/log/cron

# подготовка супервизора процессов
COPY ./supervisor/supervisord.conf /etc/supervisor/conf.d/supervisord.conf

# подготовка скрипта запуска контейнера
COPY ./entrypoint/entrypoint.sh /opt/
RUN chmod +x /opt/entrypoint.sh

# запуск супервизора в entrypoint.sh
ENTRYPOINT ["/opt/entrypoint.sh"]

# CMD ["/usr/bin/supervisord", "-n", "-c", "/etc/supervisor/supervisord.conf"]
# CMD ["sleep", "10000000"]
