# Install Keycloak with Codecentric KeycloakX Chart

```sh
helm repo add codecentric https://codecentric.github.io/helm-charts
helm upgrade -i keycloak codecentric/keycloakx --namespace keycloak --values $name.yaml
```

MORE TO COME