# Running Keystone on OpenShift

## Creating resources

Run the `create-all.sh` script to create all the resources in this project.  This will by default attempt to register a route using the hostname `keystone-dev.k-apps.osh.massopen.cloud`.  If this is already in use, you can provide an alternative name by setting the `KEYSTONE_PUBLIC_HOSTNAME` environment variable.

## Testing it out

Get the generated `clouds.yaml` file from the keystone container:

```
oc cp keystone:/data/clouds.yaml clouds.yaml
```

Use the `openstack` client to interact with your new Keystone service:

```
openstack --os-cloud openstack-public catalog list
```
