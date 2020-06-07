# Dockerfile 基础教程


wp_id: 188
Status: publish
Date: 2017-06-27 15:24:19
Modified: 2020-05-16 11:44:26


Dockerfile 列出了构建一个docker image 的**可复现**步骤。比起一步一步通过 docker commit 来制作一个镜像，dockerfile更适用于 CI 自动测试等系统。

## Dockerfile 命令

* FROM，指定基础镜像
* MAINTAINER，作者，建议格式（`Jon Snow <jonsnow@westros.com>`）
* EXPOSE，需要暴露的端口，但是一般也会使用 -p 来制定端口映射
* USER，运行的用户
* WORKDIR，进程的工作目录
* COPY，复制文件到
* RUN，运行shell命令
* CMD，启动进程使用的命令
* ENTRYPOINT，镜像启动的入口，默认是 bash -c
* ENV，设定环境变量
* VOLUME，卷

## 几个比较容易混淆的

### COPY vs ADD

ADD 会自动解压压缩包，在不需要特殊操作的时候，最好使用COPY。

### ENTRYPOINT vs CMD

entrypoint 指定了 Docker 镜像要运行的二进制文件（当然也包括参数），而 cmd 则指定了运行这个二进制文件的参数。不过因为默认 entrypoint 是 bash -c，所以实际上 CMD 指定的也是要运行的命令。

另外，docker run 时候包含命令行参数，会执行命令行参数，而不是 CMD 的内容。如果使用 /bin/bash 作为命令行的指令，这样便替换掉 CMD 的内容，从而进入镜像中查看编译出的镜像究竟是什么样的。

个人倾向于**只使用 CMD，而不使用 ENTRYPOINT**。

### 如何理解 VOLUME 指令

Dockerfile 中的 volume 指定了一个匿名的 docker volume，也就是说在 docker run 的时候，docker 会把对应的目录mount 到一个匿名的卷。当然如果使用 `-v` 参数指定了 mount 到哪个目录，或者是指定了卷名，那就不会采用匿名的卷了。

## 使用Dockerfile 还是 commit 来构建镜像

如果可能的话，尽量使用 dockerfile，因为是可复现的。

> I've been wondering the same thing, and my impression (which could be totally wrong) it that it's really the same case as with VMs --> you don't want to not know how to recreate the vm image. In my case I have regular .sh scripts to install, and am wondering why I can't just maintain these, run docker and effectively call these, and create the golden version image that way. My scripts work to get it installed on a local PC, and the reason I want to use docker is to deal with conflicts of multiple instances of programs/have clean file system/etc 
> https://stackoverflow.com/questions/26110828/should-i-use-dockerfiles-or-image-commits

## 参考

1. https://stackoverflow.com/a/34245657/1061155
2. https://stackoverflow.com/questions/41935435/understanding-volume-instruction-in-dockerfile