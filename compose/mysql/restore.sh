#!/bin/bash

# stop on errors
set -e

# set the backupfile variable
# Calculate a default filename
BACKUPFILE=$1
if [[ $(dirname ${BACKUPFILE}) == '.' ]];then
    BACKUPFILE=/backups/$(basename ${BACKUPFILE})
fi

# check that the file exists
if [[ ! -f "${BACKUPFILE}" ]]
then
    echo "backup file not found"
    echo 'to get a list of available backups, run:'
    echo '    docker-compose run postgres list-backups'
    exit 1
fi

echo "beginning restore from $1"
echo "-------------------------"

# delete the db
# deleting the db can fail. Spit out a comment if this happens but continue since the db
# is created in the next step
echo "deleting old database $MYSQL_DATABASE"
if /usr/bin/mysql -u $MYSQL_USER --password=$MYSQL_PASSWORD -e "DROP DATABASE $MYSQL_DATABASE"
then echo "deleted $MYSQL_DATABASE database"
else echo "database $MYSQL_DATABASE does not exist, continue"
fi

# create a new database
echo "creating new database $MYSQL_DATABASE"
/usr/bin/mysql -u $MYSQL_USER --password=$MYSQL_PASSWORD -e "CREATE DATABASE $MYSQL_DATABASE"

# restore the database
echo "restoring database $MYSQL_DATABASE"
/usr/bin/mysqldump -u $MYSQL_USER --password=$MYSQL_PASSWORD $MYSQL_DATABASE < ${BACKUPFILE}
