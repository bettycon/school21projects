# Stage 1 - Build with Maven and Java 17
FROM maven:3.8.5-eclipse-temurin-17 AS builder
WORKDIR /app
COPY .mvn .mvn
COPY mvnw pom.xml ./
RUN mvn -B dependency:go-offline

COPY src ./src

RUN mvn -B package -DskipTests

# Stage 2 - Runtime with Java 17 + добавление драйверов
FROM eclipse-temurin:17-jre-alpine

# Устанавливаем необходимые инструменты
RUN apk add --no-cache bash curl

# Копируем приложение
COPY --from=builder /app/target/*.jar /app/app.jar
COPY wait-for-it.sh .
RUN chmod +x wait-for-it.sh

# СКАЧИВАЕМ И ДОБАВЛЯЕМ ДРАЙВЕРЫ БАЗ ДАННЫХ
# Драйвер H2 (для in-memory тестов)
RUN curl -L -o /app/h2.jar https://repo1.maven.org/maven2/com/h2database/h2/2.1.214/h2-2.1.214.jar

# Драйвер PostgreSQL (для продакшена)
RUN curl -L -o /app/postgresql.jar https://jdbc.postgresql.org/download/postgresql-42.7.3.jar

# Создаем директорию для драйверов
RUN mkdir -p /app/libs && \
    mv /app/h2.jar /app/postgresql.jar /app/libs/

# Изменяем CMD для включения драйверов в classpath
CMD ["java", "-cp", "/app/app.jar:/app/libs/*", "org.springframework.boot.loader.JarLauncher"]
