FROM ubuntu:20.04

RUN apt update && apt install -y wget gnupg pigz pbzip2 xz-utils lrzip brotli zstd lsb-release \
        && wget https://dev.mysql.com/get/mysql-apt-config_0.8.33-1_all.deb \
        && DEBIAN_FRONTEND=noninteractive dpkg -i mysql-apt-config_0.8.33-1_all.deb \
        && apt-key adv --keyserver keyserver.ubuntu.com --recv-keys B7B3B788A8D3785C \
        && apt update && apt install -y mysql-client \
        && apt remove -y wget && apt autoremove -y && apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* mysql*

COPY --from=minio/mc /usr/bin/mc /usr/local/bin/mc

COPY entrypoint.sh .
ENTRYPOINT ["/entrypoint.sh"]
