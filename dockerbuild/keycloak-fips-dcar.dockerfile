ARG BASE_REGISTRY=registry1.dso.mil
ARG BASE_IMAGE=ironbank/redhat/openjdk/openjdk21-devel
ARG BASE_TAG=1.21

FROM quay.io/keycloak/keycloak:26.0.7 AS upstream

USER root

# Add local files from bouncy folder
ADD bouncy /tmp/files

# Add Jar files, keystore, java security
WORKDIR /opt/keycloak
RUN cp /tmp/files/*.jar /opt/keycloak/providers && \
    chmod 644 /opt/keycloak/providers/*.jar

#RUN cp /tmp/files/keycloak-fips.keystore.* /opt/keycloak/conf/server.keystore

# Create helper file for keystore generation
RUN echo "securerandom.strongAlgorithms=PKCS11:SunPKCS11-NSS-FIPS" > /tmp/kc.keystore-create.java.security

# Rebuild Default Keystore with BCFKS FIPS Libraries
RUN keytool -genkeypair -sigalg SHA512withRSA -keyalg RSA \
    -storetype BCFKS \
    -providername BCFIPS \
    -providerclass org.bouncycastle.jcajce.provider.BouncyCastleFipsProvider \
    -provider org.bouncycastle.jcajce.provider.BouncyCastleFipsProvider \
    -providerpath /opt/keycloak/providers/bc-fips-*.jar \
    -storepass passwordpassword \
    -keystore /opt/keycloak/conf/server.keystore \
    -alias localhost \
    -dname "CN=localhost" \
    -keypass passwordpassword \
    -J-Djava.security.properties=/tmp/kc.keystore-create.java.security

# Enable JAVA FIPS Mode
ENV JAVA_OPTS_APPEND="-Dorg.bouncycastle.fips.approved_only=true"

# Prevent CCE-84038-9 and CCE-85888-6
RUN chmod -R 0750 /opt/keycloak

FROM ${BASE_REGISTRY}/${BASE_IMAGE}:${BASE_TAG}

USER root

# Add Keycloak user
RUN echo "keycloak:x:2000:root" >> /etc/group && \
    echo "keycloak:x:2000:2000:keycloak user:/opt/keycloak:/sbin/nologin" >> /etc/passwd

# Copy from upstream stage
COPY --from=upstream --chown=2000:2000 /opt/keycloak /opt/keycloak

USER keycloak

EXPOSE 8080 8443

ENTRYPOINT [ "/opt/keycloak/bin/kc.sh" ]