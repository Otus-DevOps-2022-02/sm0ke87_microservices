# sm0ke87_microservices
sm0ke87 microservices repository
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
