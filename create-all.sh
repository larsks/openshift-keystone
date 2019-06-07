#!/bin/sh

set -e

: ${KEYSTONE_PUBLIC_HOSTNAME:="${USER}-keystone-dev.k-apps.osh.massopen.cloud"}
CONFIGMAPS="httpd-config keystone-config keystone-templates keystone-vars"

echo "creating configmaps"
for x in $CONFIGMAPS; do
	echo "creating configmap $x"

	oc delete configmap $x > /dev/null 2>&1 || :

	if [ -d $x ]; then
		oc create configmap $x --from-file $x
	elif [ -f $x.yaml ]; then
		oc create -f $x.yaml
	fi
done

echo "creating resources from template"
oc delete all --all
oc process -f flocx-keystone-dev.yaml -p KEYSTONE_PUBLIC_HOSTNAME=$KEYSTONE_PUBLIC_HOSTNAME | oc create -f-

echo "waiting for keystone pod to become ready"
while ! oc get -o json pod keystone | jq '.status.containerStatuses|.[].ready' | head -1 | grep -q true; do
       sleep 1
done

echo "getting clouds.yaml"
oc exec keystone cat /data/clouds.yaml > clouds.yaml

echo "waiting for keystone api"
while ! curl -sfk --connect-timeout 10 https://$KEYSTONE_PUBLIC_HOSTNAME -o /dev/null; do
	sleep 1
done

