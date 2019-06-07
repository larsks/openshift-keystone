# Running Keystone on OpenShift

## Prerequisites

You must have a project named `flocx-keystone` in OpenShift (and it must be your current project).

## Configuring passwords

You will need to provide the following passwords before you are able to start the mariadb and keystone pods:

- `MYSQL_ROOT_PASSWORD` -- this is the password for the mariadb root account.
- `KEYSTONE_DB_PASSWORD` -- this is the password for the `keystone` mariadb user.
- `KEYSTONE_ADMIN_PASSWORD` -- this is the password for the `admin` keystone user.

You provide these passwords by create a [secret][] named `keystone-secrets`. An example might look like:

[secret]: https://docs.openshift.com/container-platform/3.4/dev_guide/secrets.html

```
apiVersion: v1
kind: Secret
metadata:
  name: keystone-secrets
type: Opaque 
stringData:
  KEYSTONE_DB_PASSWORD: a.secret.password
  KEYSTONE_ADMIN_PASSWORD: look.im.an.admin
  MYSQL_ROOT_PASSWORD: i.am.groot
```

Place the above content in a file named `keystone-secrets.yaml`.

## Creating resources

Run the `create-all.sh` script to create all the resources in this project.

