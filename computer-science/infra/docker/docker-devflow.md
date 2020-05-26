# 一种使用 Docker 的开发流程


ID: 518
Status: draft
Date: 2018-06-16 18:15:00
Modified: 2020-05-16 11:40:18


两个 Dockerfiles，一个用于开发，一个用于部署。

构建开发镜像直接把当前目录拷贝进镜像中，然后运行，设置debug为true等

构建部署的镜像可以从git仓库拉取源码，设置debug为false等。

当前解决方案

本地直接构建镜像，然后

COPY current directory to /opt/
RUN apt-get
RUN pip install

TODO: 例子