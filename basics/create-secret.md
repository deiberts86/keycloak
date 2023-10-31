# Create your secret

- Replace capital values to your own.  Remove the `-n NAMESPACE` if you want to use the default namespace (not recommended but OK for development)

```sh
kubectl -n NAMESPACE create secret docker-registry MY-SECRET-NAME --docker-server=DOCKER_REGISTRY_SERVER --docker-username=DOCKER_USER --docker-password=DOCKER_PASSWORD --docker-email=DOCKER_EMAIL
```
