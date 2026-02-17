## Part 1. Удаленное конфигурирование узла через Ansible

  ### 1. Создать с помощью Vagrant три машины: manager, node01, node02. Не устанавливать с помощью shell-скриптов docker при создании машин на Vagrant! Прокинуть порты node01 на локальную машину для доступа к пока еще не развернутому микросервисному приложению.

![](./images/1.png) </br>

![](./images/1_2.png) </br>

  ### 2. Подготовить manager как рабочую станцию для удаленного конфигурирования.

  Зайти на manager.

![](./images/2.png) </br>

  На manager проверить подключение к node01 через ssh по приватной сети.

![](./images/3.png) </br>

  Сгенерировать ssh-ключ для подключения к node01 из manager (без passphrase). 

![](./images/4.png) </br>

![](./images/5.png) </br>

![](./images/6.png) </br>

  Скопировать на manager docker-compose файл и исходный код микросервисов.

![](./images/7.png) </br>

![](./images/8.png) </br>

  Установить Ansible на менеджер и создать папку ansible, в которой создать inventory-файл.

![](./images/9.png) </br>

![](./images/10.png) </br>

  Использовать модуль ping для проверки подключения через Ansible.

![](./images/11.png) </br>

  ### 3. Написать первый плейбук для Ansible, который выполняет apt update, устанавливает docker, docker-compose, копирует compose-файл из manager'а и разворачивает микросервисное приложение.

![](./images/12.png) </br>

![](./images/13.png) </br>

![](./images/13_1.png) </br>

  ### 4. Прогнать заготовленные тесты через postman и удостовериться, что все они проходят успешно. В отчете отобразить результаты тестирования.

![](./images/14.png) </br>

  ### 5. Сформировать три роли:

  Роль application выполняет развертывание микросервисного приложения при помощи docker-compose.

![](./images/15.png)

  Роль postgres устанавливает и запускает postgres, создает базу данных с произвольной таблицей и добавляет в нее три произвольные записи.

![](./images/16.png)

  Роль apache устанавливает и запускает стандартный apache сервер.

![](./images/17.png)

  Назначить первую роль node01 и вторые две роли node02.

![](./images/18.png)

![](./images/18_1.png)

  Проверить postman-тестами работоспособность микросервисного приложения.

![](./images/19.png)


  Удостовериться в доступности apache-сервера.

![](./images/20.png)

  Для Apache веб-страница должна открыться в браузере.

![](./images/21.png)

![](./images/22.png)

  Удостовериться в доступности postgres.

![](./images/23.png)

  Необходимо подключиться с локальной машины и отобразить содержимое ранее созданной таблицы с данными.

![](./images/24.png)


## Part 2. Service Discovery

### 1. Написать два конфигурационных файла для consul.

consul_server.hcl, настроить агент как сервер, указать в advertise_addr интерфейс, направленный во внутреннюю сеть Vagrant.

![](./images/200.png)

consul_client.hcl, настроить агент как клиент, указать в advertise_addr интерфейс, направленный во внутреннюю сеть Vagrant.

![](./images/201.png)

### 2. Создать с помощью Vagrant четыре машины: consul_server, api, manager и db.

![](./images/202.png)

![](./images/203.png)

### 3. Написать плейбук для ansible и четыре роли:

плейбук для ansible

![](./images/204.png)

роль install_consul_server, которая:
работает с consul_server,
копирует consul_server.hcl,
устанавливает consul и необходимые для consul зависимости,
запускает сервис consul;

![](./images/205.png)

роль install_consul_client, которая:
работает с api и db,
копирует consul_client.hcl,
устанавливает consul, envoy и необходимые для consul зависимости,
запускает сервис consul и consul-envoy;

![](./images/206.png)

роль install_db, которая:
работает с db,
устанавливает postgres и запускает его,
создает базу данных hotels_db;

![](./images/207.png)

роль nstall_hotels_service, которая:
работает с api,
копирует исходный код сервиса,
устанавливает openjdk-8-jdk,
создает глобальные переменные окружения:
POSTGRES_HOST="127.0.0.1",
POSTGRES_PORT="5432",
POSTGRES_DB="hotels_db",
POSTGRES_USER="<имя пользователя>",
POSTGRES_PASSWORD="<пароль пользователя>",
запускает собранный jar-файл командой java -jar <путь до hotel-service>/hotel-service/target/<имя jar-файла>.jar.

![](./images/208.png)

![](./images/208_1.png)

![](./images/208_2.png)

Зпуск плейбука командой ansible-playbook -i inventory.ini deploy-consul.yml

![](./images/209.png)

![](./images/210.png)

![](./images/211.png)

![](./images/212.png)

### 4. Проверить работоспособность CRUD-операций над сервисом отелей. В отчете отобразить результаты тестирования.

![](./images/213.png)

![](./images/214.png)

![](./images/215.png)

![](./images/216.png)




