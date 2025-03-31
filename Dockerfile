# Use the official Metabase image
FROM metabase/metabase:v0.45.0
 
# Reduce Java heap size to fit in 512MB memory
ENV JAVA_OPTS="-Xms256m -Xmx512m"
 
# Add RDS certificate for AWS database connectivity (if needed)
RUN mkdir -p /app/certs && \
    curl -s https://truststore.pki.rds.amazonaws.com/global/global-bundle.pem -o /app/certs/rds-combined-ca-bundle.pem && \
    /opt/java/openjdk/bin/keytool -noprompt -import -trustcacerts -alias aws-rds \
    -file /app/certs/rds-combined-ca-bundle.pem -keystore /etc/ssl/certs/java/cacerts \
    -keypass changeit -storepass changeit || true
 
# Create and set permissions for plugins directory
RUN mkdir -p /plugins && chmod a+rwx /plugins
 
# Expose port
EXPOSE 3000
 
