# Use an official OpenJDK 17 image as the base image
#FROM openjdk:17-jdk-slim

# Set the working directory inside the container
#WORKDIR /app

# Copy the Maven/Gradle build file and source code
#COPY pom.xml ./
#COPY src ./src

# If using Maven, install dependencies and build the application
#RUN apt-get update && apt-get install -y maven
#RUN mvn clean package -DskipTests

# Copy the built JAR file to the container
#COPY --from=build /app/target/*.jar app.jar

# Expose the port the application runs on
#EXPOSE 8089

# Command to run the application
#ENTRYPOINT ["java", "-jar", "app.jar"]

FROM maven:3.9-eclipse-temurin-17 AS build
WORKDIR /app
COPY pom.xml ./
RUN mvn dependency:go-offline
COPY src ./src
RUN mvn clean package -DskipTests
FROM eclipse-temurin:17-jdk-alpine
WORKDIR /app
COPY --from=build /app/target/*.jar app.jar
EXPOSE 8089
CMD ["java", "-jar", "app.jar"]
