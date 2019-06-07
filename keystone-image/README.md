# Docker image for Keystone on OpenShift

## Scripts

- `dtu.py` -- this is a simple templating tool, used mostly to substitute environment variables into templates to generate configuration files.
- `waitfordb.py` -- this blocks until a database connection is successful. This allows the keystone startup script to ensure that a database is up and running before runnint `keystone-manage db_sync`.
