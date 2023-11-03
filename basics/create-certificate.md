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
  privateKey:
    rotationPolicy: Always
  commonName: "$DOMAIN_NAME"
  issuerRef:
    name: domain-ca-issuer
    kind: ClusterIssuer
  dnsNames:
    - "$DOMAIN_NAME"
    - "*.$DOMAIN_NAME"
...
EOF
```