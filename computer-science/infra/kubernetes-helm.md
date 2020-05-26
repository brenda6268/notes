# kubernetes 初探——使用 helm 部署服务


ID: 569
Status: publish
Date: 2018-10-06 02:52:00
Modified: 2020-05-16 11:25:03


前几篇写了一写 k8s 部署方面的东西, 后来发现阿里云的 k8s 集群还很好用...何苦自己研究几天部署呢...?

------分隔线------

在 k8s 上部署一个应用还是有些复杂的, 自己的应用当然需要自己一步一步部署, 但是对于一些通用的应用, 比如说 mysql/grafana 这种就没必要自己手工一步一步部署了. 这时候就有了 helm, 通俗的来说他就是 kubernetes 上的 AppStore, 常见的应用都已经在了, 而且你也可以按照他的格式打包自己的应用部署.

# 安装

在 helm 的 release 页面下载, 然后拷贝到本地的 /usr/local/bin/ 目录就好了. helm 运行的时候会使用 ~/.kube/config 文件, 所以本地 kubectl 可以使用就好了.

helm 分为两部分, helm 是本地命令, tiller 是服务端, 作为一个 pod 运行在, 两者的版本需要保持一致. 理论上来说, 安装好 helm 之后, 只需要执行 helm init 就可以自动在 k8s 集群中安装 tiller 了, 但是由于一些众所周知的原因, 在中国大陆地区并不能安装成功, 需要使用阿里云或者中科大的镜像:

```
helm init --stable-repo-url http://mirror.azure.cn/kubernetes/charts/
```

如果已经安装好了，

# 使用

## 概念

* Chart, 大概相当于 package 的意思
* Repository, Helm 的中心仓库
* Release, 每次运行一个 Chart 都会生成一个 Release, 每个 release 之间是独立的. Chart/Release 的关系就好比 Docker 的 Image/Container 一样.
* Revision, 每次更新 Release 都会产生一个新的版本, 可以回滚

## 基础命令

helm search 查找相关的软件包(chart), 现在 stable 仓库中大概有 200 多个包可以安装.

helm install --name NAME PACKAGE 会安装对应的 chart. 如果不指定 name, 会自动生成一个.

helm status NAME 可以查看对应的包的信息, 一般包括了如何连接使用这个包等信息, 可以当做帮助来用.

## 在安装包之前更改配置

每个 helm chart 都定义了一些默认的配置, 可以在安装之前查看并修改这些值.

helm inspect values stable/mysql 查看 mysql 的默认值. 或者去 GitHub 上看这个仓库的 readme.

把需要覆盖的变量写到 OVERRIDE.yml 文件中, helm install -f OVERRIDE.yml stable/mysql 就可以使用自己的配置了

## 更新 release

如果需要更新一个 release, 可以使用 helm upgrade -f OVERRIDE.yml RELEASE_NAME 命令更新相关的配置. 这时就会创建一个新的版本.

使用 helm list 可以查看当前部署的 release, 这时候我们可以看到部署的版本变成了 2 (最初是1).

```
-&gt; % helm ls
NAME    REVISION        UPDATED                         STATUS          CHART           NAMESPACE
mysql   1               Sat Oct  6 15:44:25 2018        DEPLOYED        mysql-0.3.0     default
```

如果当前的更新有误, 可以回退到之前的版本, 语法是 helm rollback [RELEASE] [REVISION]

## 管理 repo

helm repo list 列出当前添加的 repo

```
$ helm repo list
NAME           	URL
stable         	https://kubernetes-charts.storage.googleapis.com
local          	http://localhost:8879/charts
mumoshu        	https://mumoshu.github.io/charts
```

添加新的 repo

```
$ helm repo add dev https://example.com/dev-charts
```

# 参考文献

1. https://docs.helm.sh/
2. https://ezmo.me/2017/09/24/helm-quick-toturial/
3. https://help.aliyun.com/document_detail/58587.html
4. https://johng.cn/helm-brief/