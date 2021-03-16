#!/bin/bash

HOY=$(date '+%Y-%m-%d')

echo $HOY

# Parámetros WP desde archivo de configuración
WP_PATH_ROOT=`grep WP_PATH_ROOT params.conf |awk -F'=' '{print $2}'`
WP_FOLDER=`grep WP_FOLDER params.conf |awk -F'=' '{print $2}'`
WP_PATH_DESTINO=`grep WP_PATH_DESTINO params.conf |awk -F'=' '{print $2}'`

# Parámetros DB desde el archivo de configuración
DB_USER=`grep DB_USER params.conf |awk -F'=' '{print $2}'`
DB_PASS=`grep DB_PASS params.conf |awk -F'=' '{print $2}'`
DB_HOST=`grep DB_HOST params.conf |awk -F'=' '{print $2}'`
DB_NAME=`grep DB_NAME params.conf |awk -F'=' '{print $2}'`
DB_PATH_DESTINO=`grep DB_PATH_DESTINO params.conf |awk -F'=' '{print $2}'`

# Respaldar el sitio completo

echo "Respaldando sitio wordpress"

cd $WP_PATH_ROOT
tar czvf $WP_PATH_DESTINO/$WP_FOLDER-${HOY}.tar.gz $WP_FOLDER/

echo "Archivos de Wordpress respaldados"

# Respaldar como archivos aparte los de configuración, por comodidad

echo "Copiando archivos de configuración"

cp $WP_FOLDER/wp-config.php $WP_PATH_DESTINO/wp-config-${HOY}.php
cp $WP_FOLDER/.htaccess $WP_PATH_DESTINO/dot-htaccess-${HOY}

# Respaldo de la db

echo "Creando un dump de la DB"

mysqldump --opt --protocol=TCP --user={$DB_USER} --password={$DB_PASS} --host=$DB_HOST $DB_NAME > $DB_PATH_DESTINO/backup-{$DB_NAME}-${HOY}.sql

echo "Comprimiendo el dump de la DB"
cd $DB_PATH_DESTINO
tar czvf backup-{$DB_NAME}-${HOY}.sql.tar.gz backup-{$DB_NAME}-${HOY}.sql
rm backup-{$DB_NAME}-${HOY}.sql

echo "Fin del script de respaldo"
