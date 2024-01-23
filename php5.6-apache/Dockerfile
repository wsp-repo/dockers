FROM debian:bookworm-slim

RUN apt update && apt install -y \
    lsb-release ca-certificates curl \
    ssmtp cron supervisor mc

RUN curl -sSLo /usr/share/keyrings/deb.sury.org-php.gpg https://packages.sury.org/php/apt.gpg
RUN echo "deb [signed-by=/usr/share/keyrings/deb.sury.org-php.gpg] https://packages.sury.org/php/ $(lsb_release -sc) main" > /etc/apt/sources.list.d/php.list

RUN apt update && apt install -y \
    libapache2-mod-php5.6 php5.6 php5.6-curl php5.6-gd php5.6-gmp php5.6-imagick \
    php5.6-imap php5.6-intl php5.6-json php5.6-mbstring php5.6-mcrypt php5.6-memcache php5.6-memcached \
    php5.6-mysql php5.6-redis php5.6-xcache php5.6-xml php5.6-xsl php5.6-yaml php5.6-zip

RUN apt clean && rm -rf /var/lib/apt/lists/*

COPY ./cron/cron /etc/cron.d/cron
COPY ./supervisor/supervisord.conf /etc/supervisor/conf.d/supervisord.conf
COPY ./apache2/apache2.conf /etc/apache2/apache2.conf
COPY ./apache2/sites /etc/apache2/sites
COPY ./php5.6/apache-php.ini /etc/php/5.6/apache2/php.ini
COPY ./php5.6/cli-php.ini /etc/php/5.6/cli/php.ini

RUN chmod 0644 /etc/cron.d/cron && \
    crontab -u www-data /etc/cron.d/cron && \
    mkdir -p /var/log/cron && \
    mkdir -p /www/html

ENV APACHE_RUN_USER www-data
ENV APACHE_RUN_GROUP www-data
ENV APACHE_RUN_DIR /var/run/apache2
ENV APACHE_PID_FILE /var/run/apache2/apache2.pid
ENV APACHE_LOCK_DIR /var/lock/apache2
ENV APACHE_LOG_DIR /var/log/apache2

CMD ["/usr/bin/supervisord", "-n", "-c", "/etc/supervisor/supervisord.conf"]
# CMD ["sleep", "10000000"]
