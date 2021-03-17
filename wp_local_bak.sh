#!/bin/bash

# Author: Roberto Acuña

HOY=$(date '+%Y-%m-%d')

# Assuming the params.conf file is in the same folder than this script
cd "$(dirname "$0")"

echo $HOY

# Wordpress parameters from params.conf
WP_PATH_ROOT=`grep WP_PATH_ROOT params.conf |awk -F'=' '{print $2}'`
WP_FOLDER=`grep WP_FOLDER params.conf |awk -F'=' '{print $2}'`
WP_PATH_DESTINO=`grep WP_PATH_DESTINO params.conf |awk -F'=' '{print $2}'`

# DB parameters from params.conf
DB_USER=`grep DB_USER params.conf |awk -F'=' '{print $2}'`
DB_PASS=`grep DB_PASS params.conf |awk -F'=' '{print $2}'`
DB_HOST=`grep DB_HOST params.conf |awk -F'=' '{print $2}'`
DB_NAME=`grep DB_NAME params.conf |awk -F'=' '{print $2}'`
DB_PATH_DESTINO=`grep DB_PATH_DESTINO params.conf |awk -F'=' '{print $2}'`

# Remote host backup parameters
NEW_HOST_USER=`grep NEW_HOST_USER params.conf |awk -F'=' '{print $2}'`
NEW_HOST=`grep NEW_HOST params.conf |awk -F'=' '{print $2}'`
NEW_PATH_WP=`grep NEW_PATH_WP params.conf |awk -F'=' '{print $2}'`
NEW_PATH_DB=`grep NEW_PATH_DB params.conf |awk -F'=' '{print $2}'`

# Starting the backup

echo "Compressing Wordpress files"

cd $WP_PATH_ROOT
tar czvf $WP_PATH_DESTINO/$WP_FOLDER-${HOY}.tar.gz $WP_FOLDER/

echo "Files ready"

# To easy access, we can also backup som configuration files

echo "Copying config files"

cp $WP_FOLDER/wp-config.php $WP_PATH_DESTINO/wp-config-${HOY}.php
cp $WP_FOLDER/.htaccess $WP_PATH_DESTINO/dot-htaccess-${HOY}

# DB Backup

echo "Exporting the Database"

mysqldump --opt --protocol=TCP --user={$DB_USER} --password={$DB_PASS} --host=$DB_HOST $DB_NAME > $DB_PATH_DESTINO/backup-{$DB_NAME}-${HOY}.sql

echo "Compressing the database export"
cd $DB_PATH_DESTINO
tar czvf backup-{$DB_NAME}-${HOY}.sql.tar.gz backup-{$DB_NAME}-${HOY}.sql
rm backup-{$DB_NAME}-${HOY}.sql

## Send files to remote server
## NOTE: This is untested. You have to share your keys first (read SCP_keys.md) before uncomment.
## IF you don't want to delete local files after send them to the remote server, then delete "&& rm...." at the end of the lines below:

# echo "Sendind files to remote server"
# scp $WP_PATH_DESTINO/$WP_FOLDER-${HOY}.tar.gz {$NEW_HOST_USER}@{$NEW_HOST}:{$NEW_PATH_WP} && echo "WP files sent" && rm $WP_PATH_DESTINO/$WP_FOLDER-${HOY}.tar.gz
# scp $DB_PATH_DESTINO/backup-{$DB_NAME}-${HOY}.sql.tar.gz {$NEW_HOST_USER}@{$NEW_HOST}:{$NEW_PATH_DB} && echo "DB files sent" && $DB_PATH_DESTINO/backup-{$DB_NAME}-${HOY}.sql.tar.gz

echo "Backup script finished"
