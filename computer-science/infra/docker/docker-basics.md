# docker 基础概念

<!--
ID: c8268e11-d22f-4e76-8b16-ab604d5d137f
Status: publish
Date: 2017-06-30T13:59:00
Modified: 2020-05-16T11:44:40
wp_id: 515
-->

Docker 是一个进程的容器，**不是虚拟机**。他为一个进程隔离了文件系统、网络和环境变量。最好在其中运行一个且仅运行一个线程，而不是运行多个任务。

Docker 中最好运行的是无状态的服务，这样方便于横向扩展，对于有状态的服务，建议把状态 mount 出来。

## 使用场景

1. 为有不同需求的应用创建不同的隔离环境， 比如部署两个脚本，一个需要用 Python 2.7，另一个需要用 Python 3.6
2. 微服务
3. 管理进程, 也就是类似 systemd 或者 supervisord 的角色
4. 保护宿主系统免受侵害

## Image vs Container（镜像与容器）

Container is a running instance of image, each time you run an image, a new container is created. You can commit a container back as an image, however, it's a little controversial

Image name format: user/image:tag

## basic usage

* `docker run OPTIONS IMAGE COMMAND` to generate a container based on given image and start it.
  * most used command is -d
  * and -it
  * --restart=always to always restart the container
  * --name=NAME to name the container
* `docker start CONTAINER_ID` to restart stopped container, note that this will reuse the options and command when `docker run` is issued
* then use `docker attach CONTAINER_ID` to reattach to the given container
* `docker exec OPTIONS CONTAINER COMMAND` to run an extra command in container

Note, docker is all about stdio, and if you would like to read something, read it from stdin, if you would like to output something, write to stdout

# building docker images

two ways:
* commit each change
* using dockerfiles

# Commands

## Container related

### run

每次执行 `docker run`, 都会根据镜像来创建一个全新的 container, 可以使用 `docker start` 或者 `docker attach` 来连接上已经创建的 container。image 和 container 的关系大概类似于程序和进程之间的关系。

Syntax:

`docker run [options] [image name] [command]`
`docker exec -it [container] bash` can be used as a ssh equivalent
`-d` detach the container and runs in background
`-p` set ports [host:container]
`--name` set the name
`--rm` clean the container after running
`--net` sets the network connected to
`-w` sets working dir
`-e` sets env variable
`-u` sets user
`-v` sets volume host_file:container_file:options

### status

`docker ps -a` shows which container is running

## Image ralated

`docker pull`
`docker images`
`docker search`
`docker build`	 docker build -t user/image [dir]

## 网络相关

基础命令

```
docker network ls	ls the network interfaces
docker network inspect	inspect the network for details
docker network create/rm	create network interface
docker network connect/disconnect [net] [container]	connect a container to a network
```

by setting network, docker automatically create /etc/hosts file inside the image, and you can use the name of the container to access the others.

docker 有两个网络模式

### 桥接模式

使用 `docker run --net="bridge"，这种模式会使用虚拟网卡 docker0 做了一层 NAT 转发，所以效率比较低，优点是不用改变应用分配固定端口的代码，docker 会在宿主机上随机分配一个端口，避免冲突。

### Host 模式

使用 `docker run --net="host"，宿主机和 docker 内部使用的都是同一个网络，比如说 eth0

## 卷

Docker 容器一般来说是无状态的，除了保存到数据库之外，还可以使用卷来把容器中的状态保存出来。

docker volume create --name hello
docker run -d -v hello:/container/path/for/volume container_image my_command

## 日志

You could use `docker logs [contianer]`  to view stdout logs. But the logs sent to /var/logs/*.log are by default inside the container.

Remove stopped images
docker rm $(docker ps -aq)

使用 docker 的时候不使用 sudo

```
sudo gpasswd -a ${USER} docker
```

然后登出再登录当前用户即可

## 参考

1. https://blog.talpor.com/2015/01/docker-beginners-tutorial/
