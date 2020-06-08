Date: 2019-11-08

进入容器中

kubectl exec -it PODNAME -- bash

获取各种资源列表

kubectl get node/pod/deploy/svc

设置返回参数 -o wide/yaml/name

详细描述资源

kubectl describe node/pod/deploy/svc

-n 指定命名空间

kubectl top node/pod 显示当前节点的一些信息

kubectl port-forward my-pod 5000:6000，本地5000端口转发到 pod 6000

kubectl edit deployment/my-nginx 编辑 kubernetes 的配置文件

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