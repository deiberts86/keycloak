FROM quay.io/keycloak/keycloak:26.0.7 AS build

USER root

# Add Keycloak user
RUN echo "keycloak:x:2000:root" >> /etc/group && \
    echo "keycloak:x:2000:2000:keycloak user:/opt/keycloak:/sbin/nologin" >> /etc/passwd

# Add local files from bouncy folder
ADD bouncy /tmp/files

# Add Jar files, keystore, java security
WORKDIR /opt/keycloak
RUN cp /tmp/files/*.jar /opt/keycloak/providers && chmod 644 /opt/keycloak/providers/*.jar
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
ENV JAVA_OPTS="-Dorg.bouncycastle.fips.approved_only=true"

USER keycloak

# Build Keycloak with FIPS Enabled by default  
RUN /opt/keycloak/bin/kc.sh build --features=fips

EXPOSE 8080 8443

ENTRYPOINT [ "/opt/keycloak/bin/kc.sh" ]