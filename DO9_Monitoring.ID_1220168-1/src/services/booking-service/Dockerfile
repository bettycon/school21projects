# Stage 1 - Build with Maven and Java 17
FROM maven:3.8.5-eclipse-temurin-17 AS builder
WORKDIR /app
COPY .mvn .mvn
COPY mvnw pom.xml ./
RUN mvn -B dependency:go-offline

COPY src ./src

RUN mvn -B package -DskipTests

# Stage 2 - Runtime with Java 17
FROM eclipse-temurin:17-jre-alpine
COPY --from=builder /app/target/*.jar /app/app.jar
COPY wait-for-it.sh .

RUN apk add --no-cache bash
RUN chmod +x wait-for-it.sh

# Default command - can be overridden
CMD ["java", "-jar", "/app/app.jar"]
