# Use the official Maven image as the base image
FROM maven:3.8.4-jdk-8-slim AS build

# Copy the project files into the container
WORKDIR /app
COPY . /app

# Build the project
RUN mvn clean package -DskipTests

# Use the official Tomcat image as the base image for the final image
FROM tomcat:9.0.55-jdk8-openjdk-slim-buster

# Copy the WAR file from the build stage into the Tomcat webapps directory
COPY --from=build /app/target/onlinebookstore.war /usr/local/tomcat/webapps/

# # Set environment variables for the database connection
# ENV DB_HOST=localhost \
#     DB_PORT=5432 \
#     DB_NAME=onlinebookstore \
#     DB_USER=username \
#     DB_PASSWORD=password

# # Copy the database driver into the container
# COPY --from=build /app/target/dependency/postgresql-42.3.7.jar /usr/local/tomcat/lib/

EXPOSE 8083 

# Start Tomcat
CMD ["catalina.sh", "run"]