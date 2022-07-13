# sm0ke87_microservices
sm0ke87 microservices repository
## kubernetes-2
* Изучен миникуб, с версиями опять беда какая-то
* Установлен отдельно kubectl v.1.24
* Изучено создание кластера в YC
* Разворачивание сервисов и приложений из кастом манифестов

## kubernetes-1
* Прослушана лекция, но яснее не стало
* Созданы в YC три машины, kubectl = 1.16.11-00, в ДЗ версия не устанавливается
* Из кастом манифестов установлен CNI плагин
* Мастер нода и воркеры встали в статус Ready
* Написан сценарий Ansible для установки кластерной основы, манифесты добавлю позднее

## Logging-1
* Изучены возможности перенаправлять логи в стек ELK от приложения через Fluend
* Изучены возможности Kibana
* Изучены фильтры Fluend, но они работают паршиво 
```
При сборке контейнера последний лог будет говорить, о том, что проблема в fluent.cong,
обойти данную историю можно использовав директивы <parce>, но у меня не получилось, зато 
контенер собирался и я получал уже логи ошибки самого fluend о невозможности использовать парсер
```
* Изучен Zipkin

* Проблема багнутого приложения связанна с тем, что в коде захардкодены адреса с post:
```
POST_SERVICE_HOST ||= ENV['POST_SERVICE_HOST'] || '127.0.0.1'
POST_SERVICE_PORT ||= ENV['POST_SERVICE_PORT'] || '4567'
COMMENT_SERVICE_HOST ||= ENV['COMMENT_SERVICE_HOST'] || '127.0.0.1'
COMMENT_SERVICE_PORT ||= ENV['COMMENT_SERVICE_PORT'] || '4567'
```
При сборке докер контейнера приложение будет отправлять именно туда данные.

В тоже время в работающем приложении эти ENV переопределены:
```
ENV POST_SERVICE_HOST post
ENV POST_SERVICE_PORT 5000
ENV COMMENT_SERVICE_HOST comment
ENV COMMENT_SERVICE_PORT 9292
```

## Monitoring-1

* Изучены prometheus: запуск, конфигурация и веб-интерфейс 
* Мониторинг сервисов 
* Сбор метрик хоста с использованием экспортера

* Ссылки на DockerHub:
[ui](https://hub.docker.com/repository/docker/sm0ke87/ui)
[comment](https://hub.docker.com/repository/docker/sm0ke87/comment)
[post](https://hub.docker.com/repository/docker/sm0ke87/post)
[prometheus](https://hub.docker.com/repository/docker/sm0ke87/prometheus)


## Gitlab CI-1

* Написан terraform для разворачивания ВМ в YC
* Ansible роль для установки docker, docker-compose и запуска контейнеров
* Ansible запускается как провижинер к terraform
* Для получения рута в Gitlab-CI нужно сделать так:
```
docker exec -ti  gitlab_web_1 grep 'Password:' /etc/gitlab/initial_root_password
```

## Docker-4

* Познакомился с созданием сетей
* Разограничением контейнеров по сетям
* Освоены комманды docker-compose

#### Docker-compose
Добавлены переменные окружения:
* Логин пользователя в DockerHub
* Порт приложения
* Версия приложений
* COMPOSE_PROJECT_NAME

#### Задание со *
Файл docker-compose.override.yml добавлены:
* Внесена опция command добавляющая запуск puma с  дополнительными параметрами `--debug -w 2`

## Запуск
```
sudo docker-compose up -d
```
В момент запуска все контейнеры и сети стартуют с COMPOSE_PROJECT_NAME префиксом

## Docker-3

* Изучение сборки образов
* Решение текущих проблем со сборкой, таких как версия MarkDown
* Создание bridge для контейнеров
* Уменьшение занимаемой памяти образов

### Запуск контейнеров
```
docker run -d --network=reddit \
--network-alias=post_db --network-alias=comment_db -v reddit_db:/data/db mongo:latest mongo:latest
docker run -d --network=reddit \
--network-alias=post sm0ke87/post:1.0
docker run -d --network=reddit \
--network-alias=comment sm0ke87/comment:1.0
docker run -d --network=reddit \
-p 9292:9292 sm0ke87/ui:2.0
```
### Проверка работоспособности
```
http://localhost:9292
```

## Docker/Docker-2

* Изучение основных команд Docker
* Создание "слоеного" своего образа из Dockerfile
* Публикация своего образа на [DockerHub](https://hub.docker.com/repository/docker/sm0ke87/otus-reddit)
* Исправление ошибок, которые появились в момент сборки образа

### Запуск образа
#### Локально из имеющегося образа:
``sudo docker run -i -d -p 9292:9292 reddit ``
#### Из DockerHub
``docker run --name reddit -d -p 9292:9292 sm0ke87/otus-reddit:1.0``
