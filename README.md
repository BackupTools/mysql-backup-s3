# MySQL/MariaDB S3 docker/kubernetes backup

[![Build status](https://github.com/BackupTools/mysql-backup-s3/workflows/Docker%20Image%20CI/badge.svg)]() [![Pulls](https://img.shields.io/docker/pulls/backuptools/mysql-backup-s3?style=flat&labelColor=1B3D4B&color=06A64F&logoColor=white&logo=docker&label=pulls)]()

Docker image to backup MySQL or MariaDB (or PerconaDB) database to S3 using mysqldump and compress using pigz.

## Advantages/features
- [x] Supports custom S3 endpoints (e.g. minio)
- [x] Uses piping instead of tmp file
- [x] Compression is done with pigz (parallel gzip)
- [x] Creates bucket if it's not created
- [x] Can be run in Kubernetes or Docker
- [x] Possibility to detect and backup all databases [testing]
- [x] PGP encryption
- [x] Available `COMPRESS=` methods: pigz, xz, bzip2, lrzip, brotli, zstd
- [ ] TODO: Add other dbs (e.g. postgres, mysql)

## Configuration
```bash
S3_BUCK=mysql1-backups
S3_NAME=folder-name/backup-name-prefix
S3_URI=https://s3-key:s3-secret@s3.host.tld
MYSQL_USER=user
MYSQL_PASSWORD=password
MYSQL_HOST=host-or-service-name
MYSQL_PORT=3307 # (optional) defaults to 3306
MYSQL_MASTERDATA=2 # (optional) defaults to 0
GPG_KEYSERVER=keyserver.ubuntu.com # your hpks keyserver
GPG_KEYID=<key_id> # recipient key, backup will be encrypted if added
COMPRESS=pigz # Available: pigz, xz, bzip2, lrzip, brotli, zstd
COMPRESS_LEVEL=7 # (optional) Compression level of desired compression program defaults to 0
```

Or see `docker-compose.yml` file to run this container with Docker.

## Cron backup with kubernetes

See `kubernetes-cronjob.yml` file.

## Changelog

[2025-03-14] Updated base docker image. Made dump compatible with mariadb (disable column stats).
[2023-09-24] Switched to mysql-8 client due to compatibility issues with mariadb client.
