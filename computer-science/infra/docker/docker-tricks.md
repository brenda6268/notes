# docker 小技巧


wp_id: 517
Status: publish
Date: 2017-07-14 21:04:00
Modified: 2020-05-16 11:45:46


# 删除所有停止的容器

    docker rm `docker ps -aq`

# 删除所有没有 tag 的镜像

    docker rmi `docker images | grep "^<none>" | awk '{print $3}'`

# 进入运行中的镜像

    docker exec -it CONTAINER_NAME bash


# 杀死所有运行中的镜像

    docker kill $(docker ps -q)

# 删除所有镜像

    docker rmi $(docker images -q)
