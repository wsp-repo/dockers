FROM debian:bookworm-slim

RUN apt update && apt install -y \
    lsb-release ca-certificates curl wget gnupg mc

# установка консольного клиента Yadex-Disk
RUN echo "deb http://repo.yandex.ru/yandex-disk/deb/ stable main" | tee -a /etc/apt/sources.list.d/yandex-disk.list > /dev/null && \
    wget http://repo.yandex.ru/yandex-disk/YANDEX-DISK-KEY.GPG -O- | apt-key add - && \
    apt update && apt install -y yandex-disk

RUN apt clean && rm -rf /var/lib/apt/lists/*

# подготовка системы в целом
RUN echo 'Europe/Moscow' > /etc/timezone && \
    ln -sf /usr/share/zoneinfo/Europe/Moscow /etc/localtime

CMD ["yandex-disk", "sync", "-c", "/root/.config/yandex-disk/config.cfg"]
