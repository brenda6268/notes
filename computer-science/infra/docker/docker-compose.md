# Docker Compose 教程

<!--
ID: a7a27846-0e5b-4ee0-9b89-dddaac17d71b
Status: publish
Date: 2018-06-17T14:38:17
Modified: 2020-05-16T11:40:55
wp_id: 232
-->

使用 docker run 运行容器的时候经常需要加很多的参数，每次都输入这么多参数很容易出错。另外我们经常需要同时运行若干个容器来构成一个服务，此时还是涉及到网络的联通等操作。docker compose 可以把 docker 执行时的参数写成 yaml 文件，运行的时候只需要 `docker-compose up -d` 一下就可以了。

话不多说，下面通过一个例子来学习一下 docker-compose.yml 文件的语法。

```yaml
version: "3"  # 版本号，目前最新版是 3，不同版本的语法是不太兼容的
services:  # 定义的服务，注意是一个字典
  web:
    build: .
    environment:  # 定义环境变量
      - ENV=prod
    depends_on:  # 该服务依赖下面的两个服务，也就是指定了
      - db
      - redis
  redis:
    image: redis  # 使用 dockerhub 上的 redis 镜像，这里也可以填自己的私有地址
    ports:
     - "3000"
     - "3000-3005"
     - "8000:8000"
     - "9090-9091:8080-8081"
     - "49100:22"
     - "127.0.0.1:8001:8001"
     - "127.0.0.1:5000-5010:5000-5010"
     - "6060:6060/udp"
  db:
    image: postgres
    volumes:
      - "/var/run/postgres/postgres.sock:/var/run/postgres/postgres.sock"
      - "dbdata:/var/lib/postgresql/data"  # 挂载的库，为了和 yaml 语法兼容，必须用引号

volumes:  # 定义的卷
  - dbdata
```

1. version 指定了当前 docker-compose 文件的版本
2. services 服务列表，是一个 "服务名：配置" 的字典。这里定义了三个服务：
   web/redis/db
3. build，docker build 命令的参数，用来指定需要构建的 dockerfile
4. image，如果镜像不需要自己构建，而是使用dockerhub上的基础镜像，可以直接使用
   image 指令
5. depends_on 指定当前的服务依赖的服务，从而确定启动顺序
6. ports 开放的端口的数组，有三种形式：
    1. "3000" 容器中开放的端口
    2. "3000:3000" 开放容器中的端口到宿主机
    3. "127.0.0.1:3000:3000" 开放容器中的端口到宿主机并绑定IP
7. environment 环境变量
8. volumes 挂载的卷，可以使用named volume或者是挂载目录，建议不要使用匿名卷。如
   果使用 named volume，必须在volumes下声明

## 运行服务
docker-compose 有以下3个常用命令：

1. `docker-compose up [-d] [SERVICE]` 启动服务，-d 表示以 daemon 形式后台运行，并且会在重启后自动启动。
2. `docker-compose run`
3. `docker-compose stop`