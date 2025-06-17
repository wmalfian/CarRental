# Stage 1: Build using Ant
FROM openjdk:8-jdk AS builder

RUN apt-get update && apt-get install -y ant

WORKDIR /app

COPY . .

# Build using default target (no clean)
RUN ant -verbose

# Stage 2: Run using Tomcat
FROM tomcat:9.0

RUN rm -rf /usr/local/tomcat/webapps/*

# OPTION A: Use exploded web app folder (NetBeans style)
COPY --from=builder /app/build/web /usr/local/tomcat/webapps/ROOT

# OPTION B: Use WAR file (if exists)
# COPY --from=builder /app/dist/CarRental.war /usr/local/tomcat/webapps/ROOT.war
