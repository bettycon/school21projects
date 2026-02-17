FROM maven:3.8.5-openjdk-8 AS builder
WORKDIR /app
COPY .mvn .mvn
COPY mvnw pom.xml ./
RUN mvn -B dependency:go-offline

COPY src ./src

RUN mvn -B package -DskipTests

FROM eclipse-temurin:8-jre-alpine
COPY --from=builder /app/target/*.jar /app/app.jar
COPY wait-for-it.sh .

RUN apk add --no-cache bash
RUN chmod +x wait-for-it.sh

CMD ["./wait-for-it.sh", "postgres:5432", "--", \
     "./wait-for-it.sh", "rabbitmq:5672", "--", \
    "java", "-jar", "/app/app.jar"]
    

