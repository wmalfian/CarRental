# Stage 1: Build WAR using Java + Ant
FROM openjdk:8-jdk AS builder

# Install Ant
RUN apt-get update && apt-get install -y ant

WORKDIR /app

# Copy your project files (build.xml, src, web, etc.)
COPY . .

# Run Ant build
RUN ant clean
RUN ant -f build.xml

# Stage 2: Run the app with Tomcat
FROM tomcat:9.0

# Remove default apps
RUN rm -rf /usr/local/tomcat/webapps/*

# Copy build output (adjust if necessary)
COPY --from=builder /app/build/web /usr/local/tomcat/webapps/ROOT
