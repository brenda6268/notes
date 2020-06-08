# kubernetes 初探——服务治理


wp_id: 547
Status: publish
Date: 2019-01-18 21:33:00
Modified: 2020-05-16 11:06:01


服务治理有两种方式：

- 一种是直接在服务中集成熔断降级等操作
- 一种是使用 sidecar 模式，有公共组件来处理

两种模式的区别如图：

![](https://ws1.sinaimg.cn/large/006tNc79ly1fzbu3a41c3j30gw09jabr.jpg)

# 服务

## 相关概念

Service. 如果一个 Deployment 对外（pod 外）提供服务的话，可以暴露为 Service。它是服务的抽象, 通过 kube-proxy 和 DNS 等提供负载均衡给后端 RC 定义的 Pod。服务一共有三种类型：

* clusterIP. 服务暴露在集群内部的一个虚拟 IP，生命周期和服务相同
* nodePort. 暴露在所有 Node 上的服务端口，不建议在生产环境使用。
* LoadBalancer，通过外部的LB，暴露对应的服务。

另外还可以使用 Ingress Controller. Service 只是对集群内部暴露了服务，ingress controller 用于把 Service 再对外暴露。就相当于一个虚拟主机。

如果一个 deployment 需要对集群内部或者是外部提供服务的话，可以使用 service。

这时将创建一个 clusterIP，需要特别注意的是，这个 clusterIP 也是虚拟的，并没有和任何 pod 绑定，而是绑定到了服务上，可以理解为绑定到了这个服务对应的内部负载均衡上，并且是不变的。即使你的 Deployment 中指定了多个副本，那么也只有这一个 clusterIP，pod 的创建和销毁也都不会影响到 clusterIP。

# 参考资料

1. [Service Mesh 的本质、价值和应用探索 ](https://mp.weixin.qq.com/s/1zAxecTzeZToaWFymeY-sw)
2. [Istio, K8S 的微服务支持](https://www.kubernetes.org.cn/2350.html)
3. [微服务之熔断、降级、限流](https://blog.csdn.net/aa1215018028/article/details/81700796)
4. [微服务化之服务拆分与服务发现](https://mp.weixin.qq.com/s?__biz=MzI1NzYzODk4OQ==&mid=2247484925&idx=1&sn=5c15ba98fb03a2a0d9c823136f34e162)