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
