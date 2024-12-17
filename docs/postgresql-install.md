# Install PostgreSQL 13.x on Kubernetes

## Create secret to be used in both Postgres and Keycloak helm values' files. 

- From a jumpbox or workstation, connect to the cluster you want to use to deploy this application and create this secret in your desired namespace. For example, I choose `keycloak` as the namespace for simplicity.

```sh
POSTGRES_PASSWORD=$(openssl rand -hex 16 | base64 | tr -d '\n')
REPMGR_PASSWORD=$(openssl rand -hex 16 | base64 | tr -d '\n')
PGPOOL_ADMIN_PASSWORD=$(openssl rand -hex 16 | base64 | tr -d '\n')

kubectl -n keycloak create secret generic postgresql-secret --from-literal=password=$POSTGRES_PASSWORD --from-literal=repmgr-password=$REPMGR_PASSWORD --from-literal=admin-password=$PGPOOL_ADMIN_PASSWORD
```

- Create PostgreSQL instanace and leverage your new secret that you just created
- NOTE: Edit your values.yaml file by pulling the PostgreSQL chart

## Helm Installation of PostgreSQL

- From a jumpbox or workstation, ensure that you have the helm repo added regarding postgresql and keycloak.

* add helm repos:
```sh
helm repo add bitnami https://charts.bitnami.com/bitnami
```

* To grab the values.yaml for PostgreSQL version 14.0.4 and edit it

```sh
cd /home/username
helm pull bitnami/postgresql --version 14.0.4
tar -zxvf postgresql-14.0.4
cd postgresql
ls -lah
```

* Edit the values.yaml file to your own environment and save it. Ensure you store a copy of it elsewhere if needed.
  - Here is a sample values file that uses the secret you created earlier.

```sh
cat > postgresql-values.yaml <<EOF
global:
  storageClass: ""

image:
  registry: docker.io
  repository: bitnami/postgresql
  tag: 16.2.0-debian-11-r1
#  pullSecrets:
#  - ironbank-secret
  pullPolicy: Always
  debug: false

containerPorts:
  postgresql: 5432

auth:
  enablePostgresUser: true
  postgresPassword: null
  username: postgres
  password: null
  database: keycloak
  replicationUsername: repl_user
  replicationPassword: null
  existingSecret: "postgresql-secret"
  secretKeys:
    adminPasswordKey: "admin-password"
    userPasswordKey: "password"
    replicationPasswordKey: "repmgr-password"

primary:
  podSecurityContext:
    enabled: true
    fsGroup: 1001
  containerSecurityContext:
    enabled: true
    runAsUser: 1001
    runAsGroup: 0
    runAsNonRoot: true
    allowPrivilegeEscalation: false
    seccompProfile:
      type: RuntimeDefault
    capabilities:
      drop:
        - ALL
EOF
```

* Install PostgreSQL with your new values. I used postgresql-values.yaml as my filename but you can use whatever you want.


```sh
helm upgrade -i postgresql bitnami/postgresql --namespace keycloak --version 13.2.24 --values postgresql-values.yaml
```

If everything is configured correctly, you should see a postgresql statefulset pod deploy and validate the logs to ensure that it's operational. If you run into issues, check you secret and ensure it's being called on properly and your pod has enough permissions to deploy into the cluster within your new namespace.
