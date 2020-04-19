# helm

Date: 2019-11-24

Helm 是 Kubernetes 的一个包管理器，你可以把他理解为 apt-get 或者 App Store。Helm 中的一个包称为一个 Chart，每次安装后称为一个 Release, Release 还有 revision，可以升级或者回滚到之前的 revision。 Helm 中还可以添加不同的 repo，repos 中有不同的 Chart。

## 基本使用

添加仓库

```sh
helm repo add stable https://kubernetes.oss-cn-hangzhou.aliyuncs.com/charts  # 国内镜像
```

安装包（Chart）

```sh
helm repo update  # 更新仓库
helm install stable/mysql --generate-name  # 安装一个包
```

列出值

```
helm list  # 列出当前的 release
helm status RELEASE # 查看状态
```

自定义安装

```sh
helm show values stable/mysql
helm install -f config.yaml stable/mysql --generate-name
```

升级和回滚

```sh
helm upgrade
helm rollback
```


卸载

```
helm uninstall
```


## 参考

1. https://helm.sh/docs/intro/quickstart/
2. https://www.lixf.io/2019/06/13/k8s-docker-images-mirrors/
