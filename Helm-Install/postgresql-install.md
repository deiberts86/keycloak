# Install PostgreSQL 12.x

#### Create your secret to be used in values' files for Keycloak and PostgreSQL

- From a jumpbox, ensure that you have the helm repo added regarding postgresql and keycloak.

* add helm repos:
```sh
helm repo add bitnami https://charts.bitnami.com/bitnami
```


- Create secret to be used in both Postgres and Keycloak helm values' files. 

```sh
POSTGRES_PASSWORD=$(openssl rand -hex 16 | base64 | tr -d '\n')
REPMGR_PASSWORD=$(openssl rand -hex 16 | base64 | tr -d '\n')
PGPOOL_ADMIN_PASSWORD=$(openssl rand -hex 16 | base64 | tr -d '\n')

kubectl -n keycloak create secret generic postgresql-secret --from-literal=password=$POSTGRES_PASSWORD --from-literal=repmgr-password=$REPMGR_PASSWORD --from-literal=admin-password=$PGPOOL_ADMIN_PASSWORD
```
MORE TO COME
