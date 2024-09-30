FROM debian:bookworm-slim

RUN apt update && apt install -y \
    lsb-release ca-certificates curl ssmtp cron supervisor mc \
    php8.4-fpm php8.4-curl php8.4-gd php8.4-imagick \
    php8.4-imap php8.4-intl php8.4-mailparse php8.4-mbstring php8.4-mcrypt \
    php8.4-memcache php8.4-memcached php8.4-mysql php8.4-pgsql php8.4-raphf \
    php8.4-redis php8.4-uuid php8.4-xml php8.4-xmlrpc php8.4-xsl php8.4-zip

RUN apt clean && rm -rf /var/lib/apt/lists/*

# подготовка системы в целом
RUN echo 'Europe/Moscow' > /etc/timezone && \
    ln -sf /usr/share/zoneinfo/Europe/Moscow /etc/localtime

# подготовка SSMTP
RUN mkdir -p /opt/ssmtp/conf && \
    cp -r -n /etc/ssmtp/* /opt/ssmtp/conf/ && \
    rm -f -r -d /etc/ssmtp && ln -sf /opt/ssmtp/conf /etc/ssmtp
RUN mkdir -p /opt/ssmtp/orig && cp -r -n /opt/ssmtp/conf/* /opt/ssmtp/orig/
RUN mkdir -p /var/log/ssmtp && chmod 0777 /var/log/ssmtp

# подготовка PHP-FPM
RUN mkdir -p /opt/php/conf/cli && \
    mv /etc/php/8.4/cli/php.ini /opt/php/conf/cli/ && \
    ln -sf /opt/php/conf/cli/php.ini /etc/php/8.4/cli/php.ini
RUN mkdir -p /opt/php/conf/fpm && \
    mv /etc/php/8.4/fpm/php.ini /etc/php/8.4/fpm/php-fpm.conf /etc/php/8.4/fpm/pool.d /opt/php/conf/fpm/ && \
    ln -sf /opt/php/conf/fpm/php-fpm.conf /etc/php/8.4/fpm/php-fpm.conf && \
    ln -sf /opt/php/conf/fpm/php.ini /etc/php/8.4/fpm/php.ini && \
    ln -sf /opt/php/conf/fpm/pool.d /etc/php/8.4/fpm/pool.d
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
RUN mkdir -p /var/log/php && chmod 0777 /var/log/php
RUN ln -sf /usr/sbin/php-fpm8.4 /usr/bin/php-fpm

# подготовка CRON
COPY ./crontabs/cron /etc/cron.d/cron
RUN mkdir -p /opt/cron/conf/crontabs && \
    rm -f -r -d /var/spool/cron/crontabs && \
    ln -sf /opt/cron/conf/crontabs /var/spool/cron/crontabs
RUN chmod 0644 /etc/cron.d/cron && crontab -u www-data /etc/cron.d/cron
RUN mkdir -p /opt/cron/orig && cp -r -n /opt/cron/conf/* /opt/cron/orig/
RUN mkdir -p /var/log/cron && chmod 0777 /var/log/cron

# подготовка супервизора процессов
COPY ./supervisor/supervisord.conf /etc/supervisor/conf.d/supervisord.conf

# подготовка скрипта запуска контейнера
COPY ./entrypoint/entrypoint.sh /opt/
RUN chmod +x /opt/entrypoint.sh

# запуск супервизора в entrypoint.sh
ENTRYPOINT ["/opt/entrypoint.sh"]

# CMD ["/usr/bin/supervisord", "-n", "-c", "/etc/supervisor/supervisord.conf"]
# CMD ["sleep", "10000000"]
