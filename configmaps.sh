#!/bin/sh

for x in httpd-config keystone-config keystone-templates; do
	oc delete configmap $x

	if [ -d $x ]; then
		oc create configmap $x --from-file $x
	elif [ -f $x.yaml ]; then
		oc create configmap $x --from-file $x.yaml
	fi
done
