# 从零开始的轻量级架构（持续更新中）

## 前言

本文所有的软件都在一台 2C8G 的 ubuntu 机器上部署

## Git 和开发模型

monorepo 是 Google 和 Facebook 都在采用的开发模型，也叫 Thunked Based Development（TBD）。也就是所有的代码全部提交到一个仓库中，并且只有一个长期存在的主分支。monorepo 的好处是方便集成和公司内部的代码共享，避免出现不同的库不兼容或者重新造轮子的情况。另一方面，由于现在只有我一个人开发，更没有必要搞很多的仓库了。

Git 托管工具可以选的包括：

GitHub, 速度太慢了
GitLab，资源占用太大，功能太多太复杂
BitBucket，付费，而且不支持 issue 功能
gogs，听起来不如 gitea 好听
Gitea，小巧轻便，就它了

### 参考文献

1. https://testerhome.com/topics/10146

## CI/CD 工具

开始觉得 jenkins 有点老了，于是去看了 drones 和 concourse，但是感觉还是很薄弱，也很难拓展，社区也小。看了一圈，发现还是 jenkins 比较符合现有的直觉和习惯。jenkins blueocean 作为 jenkins 的新版本也支持了 jenkinsfile 这种 pipeline as code 的模式。

jenkins 的安装部署也很简单，直接使用下面的 docker-compose.yml 就行了。

```yaml
version: "3"

services:
  jenkins:
    user: root  # 用 root 省很多事，虽然不太安全
    container_name: jenkins
    image: jenkinsci/blueocean
    ports:
      - "8002:8080"
    volumes:
      - "jenkins-data:/var/jenkins_home"
      - "/var/run/docker.sock:/var/run/docker.sock"  # 这样才能支持 docker in docker

volumes:
  jenkins-data:
```

和上面提到的 monorepo 的模式结合的话，需要为每一个 jenkins file 都新建一个 multibranch pipeline 就好了，除此之外一切都很流畅。

另一个比较 tricky 的地方是得为每一个 pipeline 配置好触发器，如果用默认的可能一个 commit 直接出发所有 pipeline 了。

### 参考

1. https://devops.stackexchange.com/questions/8539/jenkinsfile-for-monorepo-monobranch

## 底层架构

毫无疑问，应该采用面向服务的架构。在现在的环境下，不管你喜不喜欢，kubernetes 都是唯一的选择。当然，kubernetes 实在太大了，而且占用的基础资源也很多，这里我们采用 k3s

## 私有镜像仓库

由于镜像仓库实在太费资源了，因此还是不自建了。我们选择使用七牛的免费云存储作为镜像仓库。

## 对象存储和 CDN

对象存储直接使用腾讯云了，毕竟内网不算流量。