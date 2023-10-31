# keycloak
Keycloak for Kubernetes

## Steps to install KeyCloak for Kubernetes

### Prerequisites
- helm
- kubectl
- 1.25.x or higher kubernetes cluster
- [create your namespace with PSA](/basics/create-namespace.md)
- Optional: Create a secret towards the repository you want to pull from
  - Instructions found here: [create secret](/basics/create-secret.md)

## Install PostgreSQL or Connect to Existing Database (DBA Controlled)
[Install PostgreSQL with Helm](/Helm-Install/postgresql-install.md)

## Install KeyCloak and Point to PostgreSQL Database
[Install Keycloak with Helm](/Helm-Install/keycloak-install.md)