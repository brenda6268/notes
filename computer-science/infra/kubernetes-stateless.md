# kubernetes 初探——部署无状态应用


ID: 556
Status: publish
Date: 2018-10-04 17:45:00
Modified: 2020-05-16 11:24:50


kubernetes 架构图


![](https://ws2.sinaimg.cn/large/006tNbRwly1fvxa7izqb8j30mb0gcmzk.jpg)

* Master. 用于控制整个集群部署的机器, 为了高可用, 可以使用多台，一般至少三台为宜。
* Node. 工作节点, 用于部署服务. 一台机器可以既是 Master 也是 Worker，当然最好 Master 不要做 Worker。
* Pod. k8s 部署的最小单元, 一个 Pod 中可能包含多个 container. Pod 随时可能挂掉，也可能被替换。
* Label. Pod 的标签, 可以通过这些标签（组合）来选择对应的 Pod。
* Replica Set. 作为一个高可用的系统, 每个服务一般来说可能有多个 Pod. Replication Set 用来创建并保证有足够的 Pod 副本。RS 的名字总是 <Deployment的名字>-<pod template的hash值> 格式的。
* Deployment. 用户一般来说不会直接创建 Pod, 而是创建一个 Deployment 来部署服务. (在老版本中是创建 RC)
* Namespace. 命名空间, 默认情况下会有 kube-system 和 default 两个命名空间, kube-system 存放的是 k8s 系统的 pod 等资源, 而用户部署的资源会在 default 命名空间中.
* PersistendVolume. 如果把 Node 理解为抽象的 CPU 和内存资源，那么 PV 就可以理解为抽象的硬盘资源。我们通过 Pod 来使用 Node，因此我们也不直接使用 PV，而是通过 PersistentVolumeClaim 来使用 PV。
* PersistentVolumeClaim. 存储声明，用来声明需要使用的存储资源。
* Stateful Set. Deployment 对应的部署语义上没有状态的，而StatefulSet会充分运用 PV 和 PVC 实现 Pod 重启之间的状态保持。典型应用场景是数据库。
* Label 和 Selector. K8S 中的资源全部都通过 Label 来标识的选择。

# deployment

deployment 是使用 k8s 部署服务直接操作的概念。其他的概念往往都是**通过 deployment 来间接使用**的，因此理解 deployment 至关重要。


一个典型的 deployment 配置文件如下：

```
apiVersion: apps/v1
kind: Deployment
metadata:
  name: my-nginx
spec:
  selector:
    matchLabels:
      run: my-nginx
  replicas: 2
  template:
    metadata:
      labels:
        run: my-nginx
    spec:
      containers:
      - name: my-nginx
        image: nginx
        ports:
        - containerPort: 80

```

deployment 的配置可以发生改变，如果只是 replica 的数目发生了改变，那么这只是一个简单的扩容或者缩容操作，k8s只会简单的打开或者杀死新的 Pod。如果镜像、命令等参数发生了改变，那么 K8S 会把这次操作视为升级，也就是开始一个 RollOut 操作，创建新的 ReplicaSet。在这个过程中，如果 deployment 中的 spec 指定了保留历史 revision 的次数大于零，那么原有的 ReplicaSet 不会被删除，只是会被 Scale 到 0 而已，方便回滚。

文档：

> Note: a Deployment’s rollout is triggered if and only if the Deployment’s pod template (i.e. .spec.template) is changed, e.g. updating labels or container images of the template. Other updates, such as scaling the Deployment, will not trigger a rollout.

> https://stackoverflow.com/questions/42561791/right-way-to-update-deployments-on-kubernetes

# 服务

## 相关概念

* Service. 如果一个 Deployment 对外（pod 外）提供服务的话，可以暴露为 Service。它是服务的抽象, 通过 kube-proxy 和 DNS 等提供负载均衡给后端 RC 定义的 Pod。
* clusterIP. 服务暴露在集群内部的一个虚拟 IP，声明周期和服务相同
* nodePort. 暴露在 Node 上的服务端口，不建议在生产环境使用。
* Ingress Controller. Service 只是对集群内部暴露了服务，ingress controller 用于把 Service 再对外暴露。

如果一个 deployment 需要对集群内部或者是外部提供服务的话，可以使用 service。

这时将创建一个 clusterIP，需要特别注意的是，这个 clusterIP 也是虚拟的，并没有和任何 pod 绑定，而是绑定到了服务上，可以理解为绑定到了这个服务对应的内部负载均衡上，并且是不变的。即使你的 RC 中指定了多个副本，那么也只有这一个 clusterIP，pod 的创建和销毁也都不会影响到 clusterIP。

# kubectl 使用

## kubectl get

常用参数 `-o wide` 用来现实更详细信息. 用来获取集群的各种信息:

* `kubectl get pod` 显示所有 pod 信息
* `kubectl get deployment` 显示所有部署信息
* `kubectl get node` 显示所有节点信息

## kubectl create & apply

用来创建 pod, 部署等. 一般情况下都是使用 `-f` 参数来制定配置文件

```
kubectl create -f file.yml
```

和 kubectl create 还有一个类似的概念，kubectl apply 也可以用于创建资源。这两个的区别有以下几点：

- kubectl create 是过程性的，重点在于“创建”这个操作；而 kubectl apply 是声明性的，重点在于达成“应用”这个结果
- kubectl create 在创建重复资源的时候会报错，而 kubectl apply 可以用于更新。


## kubectl run

类似于 docker run, 但是由 kubernetes 接管, 直接运行在集群上. 比如运行 hello world

## kubectl delete

用来删除节点上的 pod, deployment 等信息

## kubectl logs

类似于 docker logs, 用来显示打印到 stdout 的日志


1. [deployment 和 pod 的区别](https://stackoverflow.com/questions/41325087/in-kubernetes-what-is-the-difference-between-a-pod-and-a-deployment)
2. [Kubernetes 基础概念](http://dockone.io/article/932)
3. [客户端和服务端服务发现](https://www.jianshu.com/p/1bf9a46efe7a)
4. [kubernetes 命令表](http://docs.kubernetes.org.cn/683.html)
5. [Kubernetes之kubectl常用命令使用指南:1:创建和删除](https://blog.csdn.net/liumiaocn/article/details/73913597)
6. [Kubernetes之kubectl常用命令](https://blog.csdn.net/xingwangc2014/article/details/51204224)
7. [Kubernetes基本概念以及术语](https://blog.csdn.net/u010209217/article/details/78782353)
8. [kubectl create 和 apply 的区别](https://stackoverflow.com/questions/47369351/kubectl-apply-vs-kubectl-create)
9. https://stackoverflow.com/questions/42561791/right-way-to-update-deployments-on-kubernetes
10. https://kubernetes.io/docs/concepts/workloads/controllers/deployment/
11. [K8S YAML 文件基础](https://blog.csdn.net/phantom_111/article/details/79427144)
12. [NodePort/LB/Ingress 三种方式的对比](https://medium.com/google-cloud/kubernetes-nodeport-vs-loadbalancer-vs-ingress-when-should-i-use-what-922f010849e0)
13. https://kubernetes.io/docs/tasks/access-application-cluster/service-access-application-cluster/