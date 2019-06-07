#!/bin/sh

set -e

: ${KEYSTONE_PUBLIC_HOSTNAME:="flocx-keystone-dev.k-apps.osh.massopen.cloud"}
CONFIGMAPS="httpd-config keystone-config keystone-templates keystone-vars"

for x in $CONFIGMAPS; do
	echo "creating configmap $x"

	oc delete configmap $x > /dev/null 2>&1 || :

	if [ -d $x ]; then
		oc create configmap $x --from-file $x
	elif [ -f $x.yaml ]; then
		oc create -f $x.yaml
	fi
done

oc delete all --all
oc process -f flocx-keystone-dev.yaml -p KEYSTONE_PUBLIC_HOSTNAME=$KEYSTONE_PUBLIC_HOSTNAME | oc create -f-

while ! oc get -o json pod keystone | jq '.status.containerStatuses|.[].ready' | head -1 | grep -q true; do
	echo "waiting for keystone pod"
	sleep 1
done

oc exec keystone cat /data/clouds.yaml > clouds.yaml
