#!/bin/sh -e

#
#mgit clone "git@$DVCS_HOST:$DVCS_USER/$DVCS_REPO.git" #example: https://gitlab.com/kenuan/mgit-meta
mgit clone "git@gitlab.com:waraos/oc-meta.git"
#mgit clone-all
mgit clone "git@gitlab.com:waraos/oc-core.git"

#
unzip install.zip

#
chown -R www-data:www-data /www

#
#php install/cli_install.php install \
#--db_hostname 127.0.0.1 \
#--db_username $MYSQL_USER \
#--db_password $MYSQL_PASSWORD \
#--db_database $MYSQL_DATABASE \
#--db_driver mysqli \
#--db_port 8083 \
#--username admin \
#--password admin \
#--email admin@localhost.com \
#--http_server http://localhost/

# jwilder/nginx-proxy support
SERVER_NAME=${VIRTUAL_HOST:-${SERVER_NAME:-localhost}}

envsubst '$SERVER_NAME $SERVER_ALIAS $SERVER_ROOT' < /nginx.conf.template > /etc/nginx/nginx.conf

supervisord -c /supervisord.conf
