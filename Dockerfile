# Use an official OpenJDK 17 image as the base image
FROM openjdk:17-jdk-slim

# Set the working directory inside the container
WORKDIR /app

# Copy the Maven/Gradle build file and source code
COPY pom.xml ./
COPY src ./src

# If using Maven, install dependencies and build the application
RUN apt-get update && apt-get install -y maven
RUN mvn clean package -DskipTests

# Copy the built JAR file to the container
COPY target/*.jar app.jar

# Expose the port the application runs on
EXPOSE 8089

# Command to run the application
ENTRYPOINT ["java", "-jar", "app.jar"]