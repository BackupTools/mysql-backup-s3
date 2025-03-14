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
: ${MYSQL_MASTERDATA:='0'}
: ${GPG_KEYSERVER:='keyserver.ubuntu.com'}
: ${GPG_KEYID:=''}
: ${COMPRESS:='pigz'}
: ${COMPRESS_LEVEL:='9'}


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

case $COMPRESS in
  'pigz' )
      COMPRESS_CMD='pigz -'${COMPRESS_LEVEL}
      COMPRESS_POSTFIX='.gz'
    ;;
  'xz' )
      COMPRESS_CMD='xz -'${COMPRESS_LEVEL}
      COMPRESS_POSTFIX='.xz'
    ;;
  'bzip2' )
      COMPRESS_CMD='bzip2 -'${COMPRESS_LEVEL}
      COMPRESS_POSTFIX='.bz2'
    ;;
  'lrzip' )
      COMPRESS_CMD='lrzip -l -L5'
      COMPRESS_POSTFIX='.lrz'
    ;;
  'brotli' )
      COMPRESS_CMD='brotli -'${COMPRESS_LEVEL}
      COMPRESS_POSTFIX='.br'
    ;;
  'zstd' )
      COMPRESS_CMD='zstd -'${COMPRESS_LEVEL}
      COMPRESS_POSTFIX='.zst'
    ;;
  * )
      echo "$(get_date) Invalid compression method: $COMPRESS. The following are available: pigz, xz, bzip2, lrzip, brotli, zstd"
      exit 1
    ;;
esac

if [ -z "$GPG_KEYID" ]
then
        mysqldump -h ${MYSQL_HOST} -P ${MYSQL_PORT} -u ${MYSQL_USER} --password=${MYSQL_PASSWORD} --column-statistics=0 --single-transaction --allow-keywords --master-data=${MYSQL_MASTERDATA} -A | $COMPRESS_CMD \
         | mc pipe backup/${S3_BUCK}/${S3_NAME}-`date +%Y-%m-%d_%H-%M-%S`.mysql.sql${COMPRESS_POSTFIX} --insecure
else
        mysqldump -h ${MYSQL_HOST} -P ${MYSQL_PORT} -u ${MYSQL_USER} --password=${MYSQL_PASSWORD} --column-statistics=0 --single-transaction --allow-keywords --master-data=${MYSQL_MASTERDATA} -A | $COMPRESS_CMD \
         | gpg -z 0 --recipient ${GPG_KEYID} --trust-model always --encrypt | mc pipe backup/${S3_BUCK}/${S3_NAME}-`date +%Y-%m-%d_%H-%M-%S`.mysql.sql${COMPRESS_POSTFIX}.pgp --insecure
fi

echo "$(get_date) MySQL backup completed successfully"
