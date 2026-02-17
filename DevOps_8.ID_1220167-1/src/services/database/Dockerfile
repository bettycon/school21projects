FROM postgres:15.1-alpine

# Копируем скрипт инициализации
COPY init.sql /docker-entrypoint-initdb.d/

# Даем права на выполнение
RUN chmod +r /docker-entrypoint-initdb.d/init.sql
