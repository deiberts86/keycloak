# Create Namespace with PSA Enabled

References:
- [(PSA) Pod Security Admission](https://kubernetes.io/docs/tutorials/security/ns-level-pss/)
- [(PSS) Pod Security Standards](https://kubernetes.io/docs/concepts/security/pod-security-standards/)

* Example:

```sh
kubectl apply -f -<<EOF
---
apiVersion: v1
kind: Namespace
metadata:
  name: keycloak
  labels:
    kubernetes.io/metadata.name: keycloak
    name: keycloak
    pod-security.kubernetes.io/audit: restricted
    pod-security.kubernetes.io/audit-version: latest
    pod-security.kubernetes.io/enforce: baseline
    pod-security.kubernetes.io/enforce-version: latest
    pod-security.kubernetes.io/warn: restricted
    pod-security.kubernetes.io/warn-version: latest
...
EOF
```
