# MySQL/MariaDB S3 docker/kubernetes backup

[![Build status](https://github.com/BackupTools/postgres-backup-s3/workflows/Docker%20Image%20CI/badge.svg)]() [![Pulls](https://img.shields.io/docker/pulls/backuptools/postgres-backup-s3?style=flat&labelColor=1B3D4B&color=06A64F&logoColor=white&logo=docker&label=pulls)]()

Docker image to backup Postgres database to S3 using pg_dump and compress using pigz.

## Advantages/features
- [x] Supports custom S3 endpoints (e.g. minio)
- [x] Uses piping instead of tmp file
- [x] Compression is done with pigz (parallel gzip)
- [x] Creates bucket if it's not created
- [x] Can be run in Kubernetes or Docker
- [x] Possibility to detect and backup all databases [testing]
- [x] PGP encryption
- [ ] TODO: Add other compression methods
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
GPG_KEYSERVER=keyserver.ubuntu.com # your hpks keyserver
GPG_KEYID=<key_id> # recipient key, backup will be encrypted if added
```

Or see `docker-compose.yml` file to run this container with Docker.

## Cron backup with kubernetes

See `kubernetes-cronjob.yml` file.
