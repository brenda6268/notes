# kubernetes 初探——部署集群


<!--
ID: e3a829a1-07f5-4e33-ae07-a802736a17a5
Status: publish
Date: 2018-09-30T04:58:00
Modified: 2020-05-16T11:24:36
wp_id: 566
-->


随着 docker cloud 的关闭，容器的编排工具之争似乎已经结束了，Docker Swarm 算是完了，Kubernetes 笑到了最后。然而 k8s 的组件众多，因此部署起来也很麻烦。为此，网上有不少的网上有不少的部署教程和脚本，包括但不限于：

- kubesaz
- minikube
- kubespray
- rke
- kubernetes: the hard way

本文基于 ubuntu 18.04. CentOS 上好多默认设置都需要修改，因此建议大家基于 Ubuntu 部署 k8s。

## 使用 kubespray 安装 k8s

（零） 假设我们要在三台机器上安装，另外一台机器作为控制节点。其中每台都作为工作节点，两台作为 master 节点。

IP          | 角色
------------|-----------------------
10.4.17.165 | 控制节点，不参与 k8s 集群
10.4.17.167 | master, node
10.4.17.168 | master, node
10.4.17.169 | node

（一） 下载 kubespray 安装包，这里我们使用最新版 (2018.10), 可能需要安装 python3, 如果没有安装的话

```
VERSION=2.7.0

# download kubespray
wget https://github.com/kubernetes-incubator/kubespray/archive/v${VERSION}.tar.gz
tar xzf v${VERSION}.tar.gz

# install dependencies
pip3 install -r kubespray-${VERSION}/requirements.txt
```

（二） 生成部署的 hosts.ini

kubespray 中有一个脚本叫做 inventory_builder 用来生成部署的 hosts.ini

```
cd kubespray-v${VERSION}
cp -r inventory/sample inventory/mycluster
declare -a IPS=(10.4.17.167 10.4.17.168 10.4.17.169)
CONFIG_FILE=inventory/mycluster/hosts.ini python3 contrib/inventory_builder/inventory.py ${IPS[@]}
```
生成之后，可以查看生成的文件

```
cat inventory/mycluster/host.ini

[k8s-cluster:children]
kube-master·▸   ·
kube-node·▸ ·

[all]
node1 ▸  ansible_host=10.4.17.167 ip=10.4.17.167
node2 ▸  ansible_host=10.4.17.168 ip=10.4.17.168
node3 ▸  ansible_host=10.4.17.169 ip=10.4.17.169

[kube-master]
node1·▸ ·
node2·▸ ·

[kube-node]
node1·▸ ·
node2·▸ ·
node3·▸ ·

[etcd]
node1·▸ ·
node2·▸ ·
node3·▸ ·

[calico-rr]

[vault]
node1·▸ ·
node2·▸ ·
node3·▸ ·
```

（三） 修改一些配置

代理：

由于众所周知的原因，k8s 依赖的 gcr.io 在中国大陆范围内无法访问，我们可以使用代理访问，关于如何搭建代理超出了本文的范围。
假设我们的代理是 http://proxy.com:10086, 修改 `inventory/mycluster/group_vars/all/all.yml`  文件，设置 http_proxy 和 https_proxy 两个变量。

下载 kubectl 到本机：

设置 kubectl_localhost 和 kubeconfig_localhost 两个变量为 true. 安装完成后会在本机安装 kubectl, 并且可以使用 inventory/mycluster/artifacts/admin.conf 使用 kubectl.

（四） 部署

这里我们需要使用 tiger 用户，这个用户需要满足如下条件：

  1. 可以无密码远程登录
  2. 在远程主机上具有无密码 sudo 权限

```
ansible-playbook -i inventory/mycluster/hosts.ini cluster.yml --become --user tiger -v
```

大概过十几分钟就部署好了

（五） 验证

```
cd inventory/mycluster/artifacts
./kubectl.sh get nodes

NAME      STATUS    ROLES         AGE       VERSION
node1     Ready     master,node   1d        v1.11.3
node2     Ready     master,node   1d        v1.11.3
node3     Ready     node          1d        v1.11.3
```

## 参考

1. [HN 上关于 Docker Cloud 关闭的讨论](https://news.ycombinator.com/item?id=16665130)
2. [使用 Kubespray 部署生产可用的 Kubernetes 集群](http://www.itmuch.com/docker/kubernetes-deploy-by-kubespray/)