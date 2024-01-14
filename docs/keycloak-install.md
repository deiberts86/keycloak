# Install Keycloak with Codecentric KeycloakX Chart
- Requirements:
  - Your [Namespace](/docs/create-namespace.md) should be pre-seeded to setup Kubernetes PSA.
  - Your [JAVA Truststore](/docs/get-dod-trust.md) or Keystore needs to be built and added to Kubernetes namespaace you plan to use for Keycloak.
  - Your [TLS certificate](/docs/create-secret.md) also needs to be created and added to the Kubernetes namespace you plan to use for Keycloak.

- Once the above steps are in place, then continue...
- Login to bastion host, use KUBECONFIG context for the cluster of choice.
- Example Keycloak-values.yaml files are located in the "Helm-Install" folder.

```sh
export KUBECONFIG=your/KubeConfig/FULLPATH
export KCVALUES=your/keycloak-values/FULLPATH
helm repo add codecentric https://codecentric.github.io/helm-charts
helm upgrade -i keycloak codecentric/keycloakx --namespace keycloak --values $KCVALUES
```

- If your Keycloak is configured properly, it should be in a running state after about 1.5 minutes (this takes a bit of time)
- Next, build your ingress. An example is provided in the repo but change to your needs. The annotations are the most important as this will use SSL-PASSTHROUGH through the ingress to the pod directly. 
- You can technically skip this step if you configured your values file to have this in place from the start.
```sh
kubectl apply -f -<<EOF
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  annotations:
    nginx.ingress.kubernetes.io/backend-protocol: HTTPS
    nginx.ingress.kubernetes.io/proxy-buffer-size: 128k 
    nginx.ingress.kubernetes.io/ssl-passthrough: 'true'
    nginx.ingress.kubernetes.io/ssl-redirect: 'true'
  name: keycloak-keycloakx
  namespace: keycloak
spec:
  ingressClassName: nginx
  rules:
    - host: site.domain.com # THIS SHOULD MATCH YOUR MOUNTED KEYCLOAK TLS CERT
      http:
        paths:
          - backend:
              service:
                name: keycloak-keycloakx-http
                port:
                  number: 8443
            path: /
            pathType: Prefix
EOF
```

- If successful, you should get to your keycloak master realm to login. Setting up Keycloak can be tricky but it's HIGHLY recommended to create another realm for user auth. The master realm should be reserved for management / administrators.

# Install Keycloak while using ISTIO

- More to come...