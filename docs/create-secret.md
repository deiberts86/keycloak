# Create Registry Secret

- Replace capital values to your own.  Remove the `-n NAMESPACE` if you want to use the default namespace (not recommended but OK for development)

```sh
kubectl -n NAMESPACE create secret docker-registry MY-SECRET-NAME --docker-server=DOCKER_REGISTRY_SERVER --docker-username=DOCKER_USER --docker-password=DOCKER_PASSWORD --docker-email=DOCKER_EMAIL
```

# Create TLS Secret
```sh
kubectl create secret tls my-tls-secret \
  --cert=path/to/cert/file \
  --key=path/to/key/file
```

# Create Opaque Secret

```sh
kubectl create secret generic my-credentials \
  --from-file=path/to/cert/file \
  --from-file=path/to/key/file
```

# Create a test certificate or Production Certificate with Cert-Manager

## `Requirements`
   * Helm Binary
   * Have a Kubernetes cluster
   * Helm Install [Cert-Manager](https://cert-manager.io/docs/installation/helm/)

### `Create Initial Cluster Issuer`

```sh
kubectl apply -f -<<EOF
---
apiVersion: cert-manager.io/v1
kind: ClusterIssuer
metadata:
  name: selfsigned-cluster-issuer
spec:
  selfSigned: {}
...
EOF
```

### `Create CA Certificate`

```sh
kubectl apply -f -<<EOF
---
apiVersion: cert-manager.io/v1
kind: Certificate
metadata:
  name: domain-ca-certificate
  namespace: cert-manager
spec:
  isCA: true
  commonName: domain-ca
  secretName: ca-secret
  privateKey:
    algorithm: ECDSA
    size: 256
  issuerRef:
    name: selfsigned-cluster-issuer
    kind: ClusterIssuer
    group: cert-manager.io
...
EOF
```

### `Create CA ClusterIssuer`

```sh
kubectl apply -f -<<EOF
---
apiVersion: cert-manager.io/v1
kind: ClusterIssuer
metadata:
  name: domain-ca-issuer
spec:
  ca:
    secretName: ca-secret
...
EOF
```

### `Create wildcard certificate`

```sh
DOMAIN_NAME=domain.name
CERT_NAME=$DOMAIN_NAME-cert
kubectl apply -f -<<EOF
---
apiVersion: cert-manager.io/v1
kind: Certificate
metadata:
  name: $CERT_NAME
  namespace: keycloak
spec:
  secretName: "$DOMAIN_NAME-cert"
  usages:
    - server auth
    - client auth
  privateKey:
    rotationPolicy: Always
  commonName: "*.$DOMAIN_NAME"
  issuerRef:
    name: domain-ca-issuer
    kind: ClusterIssuer
  dnsNames:
    - "$DOMAIN_NAME"
    - "*.$DOMAIN_NAME"
...
EOF
```