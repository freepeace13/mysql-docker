#!/bin/bash
# stop on errors
set -e

dir=/backups
prefix=backup

filename=${dir}/${prefix}_$(date +'%Y_%m_%dT%H_%M_%S').sql

echo "creating backup"
echo "---------------"

echo "Full backup filename ${filename}"

/usr/bin/mysqldump -u $MYSQL_USER --password=$MYSQL_PASSWORD $MYSQL_DATABASE > $filename

echo "successfully created backup $filename"
echo $filename
