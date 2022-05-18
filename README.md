# sm0ke87_microservices
sm0ke87 microservices repository

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
