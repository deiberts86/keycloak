# Grab DoD CA Certs and Create Truststore

Reference:
- [Repo1](https://repo1.dso.mil/big-bang/product/packages/keycloak/-/tree/main/scripts/certs?ref_type=heads)
- [Tools-Folder](/tools/)

Requirements:
- curl
- openssl
- python3
- perl
- keytool (with Java)
- Ensure your scripts are executable with a chmod +x and the folder has necessary permissions.

```bash
./tools/dod_cas_to_pem.sh dod_cas_including-expired_certs.pem
./tools/cert_check.pl DoD_AllCerts.pem
./tools/cert_tree.py DoD_AllCerts.pem
./tools/ca_bundle_to_truststore.sh
```

- Note: You should get a new file named `truststore.jks`
- Note*: If you're using your own CA Bundle, then you need to import that as well.  The Tools folder and scripts can be curtailed to your environment. For example, if you have your CA bundle, edit the `ca_bundle_to_truststore.sh` script to look for that CA bundle. There are variables that can be edited.

# Create Java TrustStore Secret for KeyCloak

```sh
kubectl -n keycloak create secret generic kc-truststore --from-file=/path/to/truststore.jks
```

- validate

```sh
# The truststore is using a password
keytool -v -list -keystore truststore.jks
kubectl -n keycloak describe secret kc-truststore
```