#!/bin/bash
set -e

# Date function
get_date () {
    date +[%Y-%m-%d\ %H:%M:%S]
}

# Variables
: ${MYSQL_HOST:='localhost'}
: ${MYSQL_PORT:='3306'}
: ${MYSQL_USER:?'Specify a MYSQL_USER variable'}
: ${MYSQL_PASSWORD:?'You must specify the MYSQL_PASSWORD variable'}
: ${GPG_KEYSERVER:='keyserver.ubuntu.com'}
: ${GPG_KEYID:=''}


# Script
if [ -z "$GPG_KEYID" ]
then
    echo "$(get_date) !WARNING! It's strongly recommended to encrypt your backups."
else
    echo "$(get_date) Preparing keys: importing from keyserver"
    gpg --keyserver ${GPG_KEYSERVER} --recv-keys ${GPG_KEYID}
fi

echo "$(get_date) MySQL backup started"

export MC_HOST_backup=$S3_URI

mc mb backup/${S3_BUCK} --insecure


if [ -z "$GPG_KEYID" ]
then
        mysqldump -h ${MYSQL_HOST} -P ${MYSQL_PORT} -u ${MYSQL_USER} --password=${MYSQL_PASSWORD} --skip-add-locks --allow-keywords --master-data=2 -A | pigz -9 \
         | mc pipe backup/${S3_BUCK}/${S3_NAME}-`date +%Y-%m-%d_%H-%M-%S`.mysql.sql.gz --insecure
else
        mysqldump -h ${MYSQL_HOST} -P ${MYSQL_PORT} -u ${MYSQL_USER} --password=${MYSQL_PASSWORD} --skip-add-locks --allow-keywords --master-data=2 -A | pigz -9 \
         | gpg -z 0 --recipient ${GPG_KEYID} --trust-model always --encrypt | mc pipe backup/${S3_BUCK}/${S3_NAME}-`date +%Y-%m-%d_%H-%M-%S`.mysql.sql.gz.pgp --insecure
fi

echo "$(get_date) MySQL backup completed successfully"
