#!/bin/bash

if [ -d /data/redis ] && [ -d /data/redis/s3backup ]; then
  # find all backups older than 7 days and delete
  /usr/bin/find /data/redis/s3backup -type f -mtime +7 -exec rm -f {} \;

  # copy current redis files to backup directory
  /bin/cp /data/redis/dump.rdb /data/redis/s3backup/dump.rdb.`date +%Y%m%d%H%M`
  /bin/cp /data/redis/redis.log /data/redis/s3backup/redis.log.`date +%Y%m%d%H%M`

  if [ -e /usr/local/bin/s3cmd ]; then
    /usr/local/bin/s3cmd sync --skip-existing /data/redis/s3backup/ s3://Redis-backups/$RAILS_ENV/$HOSTNAME/
    export ret=$?
    if [ "$ret" -ne "0" ]; then
      echo "ERROR: Failed to sync with s3"
      exit $ret
    fi
  else
    echo "ERROR: Could not find s3cmd"
    exit 200 
  fi
else
  echo "ERROR: Expected directories not found"
  exit 100
fi
