# Running Keystone on OpenShift

## Configuring passwords

You will need to provide the following passwords before you are able to start the mariadb and keystone pods:

- `MYSQL_ROOT_PASSWORD` -- this is the password for the mariadb root account.
- `KEYSTONE_DB_PASSWORD` -- this is the password for the `keystone` mariadb user.
- `KEYSTONE_ADMIN_PASSWORD` -- this is the password for the `admin` keystone user.

You provide these passwords by create a [secret][] named `keystone-secrets`. An example might look like:

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
