FROM ubuntu:18.04

RUN apt update && apt install -y wget gnupg pigz pbzip2 xz-utils lrzip brotli zstd lsb-release \
        && wget https://dev.mysql.com/get/mysql-apt-config_0.8.12-1_all.deb \
        && DEBIAN_FRONTEND=noninteractive dpkg -i mysql-apt-config_0.8.12-1_all.deb \
        && apt-key adv --keyserver pgp.mit.edu --recv-keys 467B942D3A79BD29 \
        && apt update && apt install -y mysql-client \
        && apt remove -y wget && apt autoremove -y && apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

COPY --from=minio/mc /usr/bin/mc /usr/local/bin/mc

COPY entrypoint.sh .
ENTRYPOINT ["/entrypoint.sh"]
