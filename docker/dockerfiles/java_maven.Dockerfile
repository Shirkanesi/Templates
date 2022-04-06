##############################################
#                Build-stage                 #
##############################################
FROM maven:3.8-openjdk-17-slim AS build-env
COPY src /usr/app/src
COPY pom.xml /usr/app/pom.xml
WORKDIR /usr/app

# Maven-build
RUN mvn -f /usr/app/pom.xml clean package
# If you need to disable tests (e.g. they need a specific environment)
# RUN mvn -f /usr/app/pom.xml clean package -DskipTests=true

# Copy the jar-file without "original"-prefix
RUN cp /usr/app/target/`ls /usr/app/target/ | grep .jar | grep -v original` /usr/app/target/app.jar
# Create the lib-folder because it might not be created by maven
RUN mkdir -p /usr/app/target/lib

##############################################
#                 Run-stage                  #
##############################################
# Newest openjdk 17. You might want to force specific versions
# like openjdk:17-alpine3.14
FROM openjdk:17-alpine AS run-stage
COPY --from=build-env /usr/app/target/app.jar /usr/app/
# Copy librarys (necessarry iff not shaded)
COPY --from=build-env /usr/app/target/lib/* /usr/app/lib/
WORKDIR /usr/app
# Optional healthcheck. Start-period is a grace-period. Iff healtcheck will succeed more early, container is healthy!
# HEALTHCHECK --intervall=60s --timeout=10s --retries=4 --start-period=120s CMD curl -f http://localhost/ || exit 1
ENTRYPOINT ["java", "-jar", "app.jar"]
