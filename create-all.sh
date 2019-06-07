#!/bin/sh

set -e

SERVICES="keystone-service.yaml mariadb-service.yaml"
ROUTES="keystone-route.yaml"
CONFIGMAPS="httpd-config keystone-config keystone-templates keystone-vars"
PODS="mariadb-pod.yaml keystone-pod.yaml"

for x in $SERVICES; do
	echo "creating service $x"
	oc delete -f $x > /dev/null 2>&1 || :
	oc create -f $x
done

for x in $ROUTES; do
	echo "creating route $x"
	oc delete -f $x > /dev/null 2>&1 || :
	oc create -f $x
done

for x in $CONFIGMAPS; do
	echo "creating configmap $x"

	oc delete configmap $x > /dev/null 2>&1 || :

	if [ -d $x ]; then
		oc create configmap $x --from-file $x
	elif [ -f $x.yaml ]; then
		oc create -f $x.yaml
	fi
done

if [ -f keystone-secrets.yaml ]; then
	echo "creating keystone-secrets"
	oc delete secret keystone-secrets > /dev/null 2>&1 || :
	oc create -f keystone-secrets.yaml
fi

for x in $PODS; do
	echo "creating $x pod"
	oc delete -f $x > /dev/null 2>&1 || :
	oc create -f $x
done
