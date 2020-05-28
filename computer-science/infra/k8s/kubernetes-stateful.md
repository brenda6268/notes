# kubernetes 初探——部署有状态服务


wp_id: 563
Status: publish
Date: 2018-10-05 08:02:00
Modified: 2020-05-16 11:24:58


为了部署我们自己的应用, 首先需要把基础设施部署上去, 其中数据库就占了大头. 有人说数据库等应用不是和容器化部署, 但是也有人认为所有的应用都适合容器化部署. 在这里我们不讨论这些观点，仅以部署 MySQL 为例说明一下如何在 K8S 上部署有状态服务。

# 相关概念

- PersistentVolume(PV) 是集群之中的一块网络存储。跟 Node 一样，也是集群的资源。PV 跟 Volume 类似，不过会有独立于 Pod 的生命周期。这一 API 对象包含了存储的实现细节，例如 NFS、iSCSI 或者其他的云提供商的存储系统。
- PersistentVolumeClaim (PVC) 是用户的一个请求。他跟 Pod 类似。Pod 消费 Node 的资源，PVC 消费 PV 的资源。Pod 能够申请特定的资源（CPU 和 内存）；Claim 能够请求特定的尺寸和访问模式（例如可以加载一个读写，以及多个只读实例）
- Stateful Set. Deployment 是无状态的服务，而 StatefulSets 旨在与有状态的应用及分布式系统一起使用。
- ConfigMap 用来保存非密码的配置. configmap 可以以配置文件或者环境变量等方式挂在到 pod 中
- Secret 用来保存密码等私密数据
- Init Container 用于初始化的容器. 有点类似于 docker build 的过程

# 动态 PV vs 静态 PV

# 使用 Deployment PVC 还是 Stateful Set

可以看出我们即可以使用普通的 Deployment + PVC 来部署 MySQL, 也可以使用 Stateful Set 来部署, 那么哪种方式更好呢?

个人理解：

- 对于需要使用挂载一定资源的，使用 PVC 就好了，甚至只需要只读挂载就好。
- 对于强状态依赖的服务，比如数据库，肯定要使用 PVC

Stack Overflow 上的一个问题[2]也很值得参考. 


# MySQL 主从集群

本文中我们要部署一个一主多从的 MySQL 集群. 关于一主多从的优点不是本文的重点, 这里就不多说了, 可以参考下面:

> 1. 扩容解决方案：在多个slave之间扩展负载以提高性能。在这种模式下，所有的写入和更新操作都必须在主服务器上进行。然而，读取操作通过slave镜像。该模型可以提高写入操作的性能，同时，也能够通过增加slave的节点数量，从而显著地提升读取速度。
> 2. 数据安全：数据从master被复制到slave，并且slave可以暂停复制过程。因此，可以在不损坏master的情况下，在slave上运行备份服务。
> 3. 分析：现场数据可以在master上创建，而对信息的分析可以在slave进行，而不影响master的性能。
> 4. 远程数据分发：可以使用复制为远程站点创建本地数据的副本，而不必一直通过访问master。


# 参考

1. [使用 PVC 和 Deployment 部署单实例 MySQL 集群](https://blog.csdn.net/sweatOtt/article/details/81092484)
2. https://stackoverflow.com/questions/41732819/why-statefulsets-cant-a-stateless-pod-use-persistent-volumes
3. [使用普通 Deployment 部署单节点 mysql](https://kubernetes.io/docs/tasks/run-application/run-single-instance-stateful-application/)
4. https://kubernetes.io/cn/docs/tutorials/stateful-application/basic-stateful-set/
5. [如何使用 ConfigMap](https://www.cnblogs.com/zhenyuyaodidiao/p/6594410.html)
6. [Secret 文档](https://kubernetes.io/cn/docs/concepts/configuration/secret/)
7. https://stackoverflow.com/questions/41583672/kubernetes-deployments-vs-statefulsets
8. [阿里云挂载 OSS Volume](https://yq.aliyun.com/articles/640212)
9. https://jimmysong.io/posts/kubernetes-persistent-volume/
10. https://kubernetes.io/docs/concepts/storage/volumes/