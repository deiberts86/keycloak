# Keycloak for Kubernetes

- Description:
Keycloak is not the easiest thing to setup and it can be quite cumbersome for someone to learn not only this software but also the deployment onto a Kubernetes cluster. There are a lot of moving parts to this software to deploy it properly and you should have an understanding what Keycloak requires and does under the hood.

## Steps to install KeyCloak for Kubernetes

### Prerequisites
- helm
- kubectl
- openssl
- keytool (comes from java install)
- Podman or Docker (optional: required if keytool isn't used)
- 1.25.x or higher kubernetes cluster with valid CSI
- [create your namespace with PSA](/docs/create-namespace.md)
- Optional: Create a secret towards the repository you want to pull from
  - Instructions found here: [create secret](/docs/create-secret.md)
- Build a JAVA truststore secret with your CA certificates for users to be trusted within your environment
- Create a secondary IngressClass dedicated for SSL-PASSTHROUGH and Accept Headers OR Leverage ISTIO Service Mesh
- Declare your values.yaml file (VERY IMPORTANT). Choose KeycloakX (uses Quarkus instead of FireFly) or BigBang Helm Charts

## Install PostgreSQL on Kubernetes (Optional)
- [Install PostgreSQL with Helm](/docs/postgresql-install.md)

## Install KeyCloak and Point to PostgreSQL Database
- [Create your Java Truststore](/docs/get-dod-trust.md)
- [Install Keycloak with Helm](/docs/keycloak-install.md)

## Install KeyCloak with ISTIO integration and Point to PostgreSQL Database
*UNDER CONSTRUCTION*

![Keycloak with ISTIO](/images/Kiali-Keycloakx.png)
