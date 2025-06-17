# Stage 1: Build the WAR using Apache Ant
FROM ant AS builder

WORKDIR /app

# Copy all project files (including build.xml and src folders)
COPY . .

# Build the WAR using Ant
RUN ant clean
RUN ant -f build.xml

# Stage 2: Use Tomcat to run the WAR
FROM tomcat:9.0

# Remove default apps
RUN rm -rf /usr/local/tomcat/webapps/*

# Copy the built WAR (assumes it's generated in /app/dist/*.war or build/web/)
COPY --from=builder /app/build/web /usr/local/tomcat/webapps/ROOT
