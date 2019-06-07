#!/bin/sh

: ${KEYSTONE_DB_HOST:=${MARIADB_SERVICE_HOST:-localhost}}
: ${KEYSTONE_DB_PORT:=${MARIADB_SERVICE_PORT:-3306}}

DTU='python /etc/keystone-templates/dtu.py'
WAITFORDB='python /etc/keystone-templates/waitfordb.py'

export KEYSTONE_DB_HOST KEYSTONE_DB_PORT

mkdir -p /data/run /data/logs
rsync -a /etc/keystone-ro/ /etc/keystone/
rsync -a /etc/httpd-ro/ /etc/httpd/

# generate config from templates
$DTU -o /etc/keystone/keystone.conf \
	/etc/keystone-templates/keystone.j2.conf
$DTU -o /etc/httpd/10-keystone_wsgi_main.part \
	/etc/keystone-templates/keystone_wsgi_main.conf
$DTU -o /data/clouds.yaml \
	/etc/keystone-templates/clouds.j2.yaml

$WAITFORDB --host ${KEYSTONE_DB_HOST} --user ${KEYSTONE_DB_USER} \
	--password ${KEYSTONE_DB_PASSWORD} ${KEYSTONE_DB_NAME}

keystone-manage fernet_setup
keystone-manage db_sync
keystone-manage bootstrap \
	--bootstrap-password ${KEYSTONE_ADMIN_PASSWORD} \
	--bootstrap-internal-url http://localhost:5000 \
	--bootstrap-public-url ${KEYSTONE_PUBLIC_URL:-http://localhost:5000} \
	--bootstrap-region-id ${KEYSTONE_REGION:-RegionOne}

# start apache
exec /usr/sbin/httpd -DFOREGROUND -f /etc/httpd/httpd.conf
