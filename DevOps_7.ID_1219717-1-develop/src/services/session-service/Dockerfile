# Build stage
FROM maven:3.8.5-openjdk-8 AS builder
WORKDIR /app
COPY .mvn .mvn
COPY mvnw pom.xml ./
RUN mvn -B dependency:go-offline
COPY src ./src
RUN mvn -B package -DskipTests

# Runtime stage
FROM openjdk:8-jre-alpine
RUN apk add --no-cache bash
RUN apk add --no-cache netcat-openbsd
WORKDIR /app

RUN addgroup -S spring && adduser -S spring -G spring
COPY --from=builder /app/target/*.jar app.jar
COPY wait-for-it.sh .
RUN chmod +x wait-for-it.sh && chown spring:spring wait-for-it.sh
USER spring

EXPOSE 8081

CMD ["./wait-for-it.sh", "postgres:5432", "--", "java", "-jar", "app.jar"]
