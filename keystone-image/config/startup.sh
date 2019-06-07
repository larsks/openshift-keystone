#!/bin/sh

DATADIR=/data

: ${KEYSTONE_DB_HOST:=${MARIADB_SERVICE_HOST:-localhost}}
: ${KEYSTONE_DB_PORT:=${MARIADB_SERVICE_PORT:-3306}}

export KEYSTONE_DB_HOST KEYSTONE_DB_PORT

mkdir -p $DATADIR/run/wsgi
mkdir -p $DATADIR/logs

rsync -a /config/httpd/ $DATADIR/httpd/
rsync -a /config/keystone/ $DATADIR/keystone/

# generate config from templates
dtu -o $DATADIR/keystone/keystone.conf /config/keystone.j2.conf
dtu -o $DATADIR/httpd/conf.d/10-keystone_wsgi_main.conf /config/keystone_wsgi_main.conf
dtu -o $DATADIR/clouds.yaml /config/clouds.j2.yaml

waitfordb --host ${KEYSTONE_DB_HOST} --user ${KEYSTONE_DB_USER} \
	--password ${KEYSTONE_DB_PASSWORD} ${KEYSTONE_DB_NAME}

keystone-manage fernet_setup
keystone-manage db_sync
keystone-manage bootstrap \
	--bootstrap-password ${KEYSTONE_ADMIN_PASSWORD} \
	--bootstrap-internal-url http://localhost:5000 \
	--bootstrap-public-url ${KEYSTONE_PUBLIC_URL:-http://localhost:5000} \
	--bootstrap-region-id ${KEYSTONE_REGION:-RegionOne}

# start apache
exec /usr/sbin/httpd -DFOREGROUND -d ${DATADIR}/httpd
