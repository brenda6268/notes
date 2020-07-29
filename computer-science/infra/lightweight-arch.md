# 从零开始的轻量级架构（持续更新中）

<!--
ID: 625dbdd3-d43e-48ed-a161-85c90549de4c
Status: draft
Date: 2019-09-14T00:00:00
Modified: 2020-06-20T07:35:28
wp_id: 943
-->

## 前言

本文所有的软件都在一台 2C8G 的 ubuntu 机器上部署。

Choose boring, but future-proof technology. 比如说我们不会选择 Oracle，Oracle 虽然非常稳定，但是不是未来的趋势。引入一个新技术的底线是你要读过他的源码，或者知道它所有的实现原理。

不过对于初级工程师的另一个问题是：不知道好多工具的存在，比如说我刚毕业的时候 redis 都不知道，然后去重新发明一遍 redis 那也太傻逼了。

## 复用

应该把可复用的组件抽离出来，比如用户系统，比如分层级的项目管理 (group_id 指向上一级）

## 代码管理

### Git 和开发模型

monorepo 是 Google 和 Facebook 都在采用的开发模型，也叫 Thunked Based Development（TBD）。也就是所有的代码全部提交到一个仓库中，并且只有一个长期存在的主分支。monorepo 的好处是方便集成和公司内部的代码共享，避免出现不同的库不兼容或者重新造轮子的情况。另一方面，由于现在只有我一个人开发，更没有必要搞很多的仓库了。

Git 托管工具可以选的包括：

- GitHub, 速度太慢了
- GitLab，资源占用太大，功能太多太复杂
- BitBucket，付费，而且不支持 issue 功能
- gogs，听起来不如 gitea 好听
- Gitea，小巧轻便，就它了

### 参考文献

1. https://testerhome.com/topics/10146

## 部署

### CI/CD 工具

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

和上面提到的 monorepo 的模式结合的话，需要为每一个 jenkins file 都新建一个 multibranch pipeline 就好了，除此之外一切都很流畅。另一个比较 tricky 的地方是得为每一个 pipeline 配置好触发器，如果用默认的可能一个 commit 直接出发所有 pipeline 了。

### 参考

1. https://devops.stackexchange.com/questions/8539/jenkinsfile-for-monorepo-monobranch

### 私有镜像仓库

由于镜像仓库实在太费资源了，因此还是不自建了。我们选择使用七牛的免费云存储作为镜像仓库。

## 底层架构 (Kubernetes)

毫无疑问，应该采用面向服务的架构。在现在的环境下，不管你喜不喜欢，kubernetes 都是唯一的选择。当然，kubernetes 实在太大了，而且占用的基础资源也很多，这里我们采用 k3s.

我们使用 helm 来安装 kubernetes 上的大多数组件，虽然 helm 也不是很理想，但是还是让我们的工作简单了很大一部分。Helm 官方库里的好多包都太老了。 

我们使用 longhorn 作为 storage class，尽管 longhorn 才仅仅是一个 beta 版的软件，但是毕竟是 rancher 出品，和 K3S 的兼容性肯定没有问题。


## 对象存储和 CDN

对象存储直接使用腾讯云了，毕竟内网不算流量。

## 定时任务 (CRON)

定时任务其实就是一个分布式的 Cron 的作用，使用第三方的工具还是 k8s 原生呢？经过调研，发现 k8s 的 cron 还是有诸多不足的，还是直接使用 apscheduler 自研一个吧。 

实际上 ndscheduler 也不错，但是他使用 twisted 写得，后期维护起来可能不太好弄，正好联系一下 react。

## 工作流管理

使用 Airflow 还是 luigi 呢

## RPC

所有的接口都不应该暴露实现细节，但是应该给出调用的费用（也就是时间复杂度），每个接入方都应该有一定的限额。

## 数据库

### 关系型数据库

我们使用 MySQL，虽然我一直也在听说 Postgres 有多么好，但是限于精力有限，暂时还是采用 MySQL 了。

### 对象存储

S3 不解释。

## 后端的前端

对于 Python 来说，自然主要是 Django 和 Flask 两种框架了，Django 的问题在于 ORM 不好用，无法在 django 外部使用，而且有链接丢失的问题。

Django or: `User.objects.filter(Q(gender="M") | Q(age__gt=18))`
peewee or: `User.select().where((User.gender == "M") | (User.age > 18))`

## Debug

### 监控报警

监控我们采用 Prometheus，直接通过 Helm 安装在 K8S 集群上。使用 Grafana 作为面板。

### 日志

日志我们采用 Loki，同样直接安装在 K8S 集群上。