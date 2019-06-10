# Running Keystone on OpenShift

## Creating resources

Run the `create-all.sh` script to create all the resources in this project.  This will by default attempt to register a route using the hostname `$USER-keystone-dev.k-apps.osh.massopen.cloud`, where `$USER` will be replaced by your local username.

## Testing it out

Get the generated `clouds.yaml` file from the keystone container:

```
oc cp keystone:/data/clouds.yaml clouds.yaml
```

Use the `openstack` client to interact with your new Keystone service:

```
$ export OS_CLOUD=openstack-public
$ openstack catalog list
+----------+----------+---------------------------------------------------------------+
| Name     | Type     | Endpoints                                                     |
+----------+----------+---------------------------------------------------------------+
| keystone | identity | RegionOne                                                     |
|          |          |   internal: http://localhost:5000                             |
|          |          | RegionOne                                                     |
|          |          |   public: https://lars-keystone-dev.k-apps.osh.massopen.cloud |
|          |          |                                                               |
+----------+----------+---------------------------------------------------------------+
```
