# Docker 小技巧

<!--
ID: c9c5dd07-cc2c-4356-90ba-e03a75a8d442
Status: publish
Date: 2017-07-14T21:04:00
Modified: 2020-05-16T11:45:46
wp_id: 517
-->

## 删除所有停止的容器

    docker rm `docker ps -aq`

## 删除所有没有 tag 的镜像

    docker rmi `docker images | grep "^<none>" | awk '{print $3}'`

## 进入运行中的镜像

    docker exec -it CONTAINER_NAME bash

## 杀死所有运行中的镜像

    docker kill $(docker ps -q)

## 删除所有镜像

    docker rmi $(docker images -q)

## 查看日志的时候只显示最近的

    docker logs --tail 10 container

## 参考

1. https://stackoverflow.com/questions/52119832/how-to-tail-a-docker-log-from-the-current-position-in-the-log-without-seeing-the
