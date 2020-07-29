# 服务发现注册中心 consul 的使用

<!--
ID: 0a9c2d54-a260-4d41-af9b-6300afbac19b
Status: draft
Date: 2018-01-18T07:11:00
Modified: 2020-05-16T11:30:04
wp_id: 609
-->

Consul 这个词本来的意思是古罗马议会的执政官。历史上凯撒和屋大维都通过这个职务来把持罗马的权力。把这个词用作服务发现的注册中心还是比较形象的。

服务发现的意思就是由各个服务来主动向注册中心注册自己的地址，而不是手工把配置写到文件里。作为注册中心就承担了为各个服务提供解析的功能，有点类似于 DNS 系统（事实上 consul 的确提供了 DNS 解析功能），所以注册中心的可用性必须很高。为了实现这一点，consul 使用 [raft 协议][1]在多个节点之间同步状态。

Consul 主要提供了以下功能

- 服务注册和服务发现
- 健康检查
- 高可用的kv存储

另外，值得提到的是，consul 原生提供了一个简单的管理界面，非常方便

## 安装

Ubuntu上可以使用下面的脚本：

```
curl -o consul.zip https://releases.hashicorp.com/consul/1.2.1/consul_1.2.1_linux_amd64.zip
unzip consul.zip
sudo mv consul /usr/local/bin
```

## 运行

上面提到，Consul 为了保证高可用性，在多个节点上运行，并且使用 raft 协议同步状态。所以我们需要在多个节点上启动 consul。

Consul 可以以开发模式单节点启动，但是仅供调试，在这里我们就不在赘述了。直接看如何在生产环境中启动 consul。Consul 建议以 3-5 个服务器来作为节点。

关于 consul 的启动参数可以查看：https://www.consul.io/docs/agent/options.html

以三个节点为例，在每个节点上执行：

```
consul agent -server -bootstrap-expect=3 \
    -data-dir=/var/consul -node=NODE_NAME -bind=0.0.0.0 \
    -enable-script-checks=true -config-dir=/etc/consul.d
```

然后在其中一台上执行：

```
consul join ip1 ip2 ip3
```

然后可以查看集群中的节点

```
consul members
```

## 注册服务

### 通过配置文件

```json
{
    "service": {
        "name": "redis.db",
        "tags": ["db"],
        "port": 80
    }
}
```

查询服务：

```
curl http://localhost:8500/v1/catalog/service/redis
```

更新服务配置：

可以通过修改配置文件，然后使用 consul reload 重新加载配置

## 客户端与服务器

当我们启动了 consul 集群之后，就可以查询服务了，上面介绍的都是以服务器形式启动了 consul，在一般的节点，还需要运行 consul 客户端节点，而其他的服务访问的也都是本地的节点。

> Normally you'll run a separate set of Consul servers (usually 3 or 5) and then run the Consul client agent on every other machine in your infrastructure. Applications always talk to the local Consul client agent, which will automatically forward requests to and keep track of the Consul servers. The Consul servers provide stable storage for the catalog, key/value store, and provide coordination for things like locks and semaphores. The Consul client agents on each other machine manage registering local services on that machine, and provide interfaces to Consul for applications on that machine (HTTP or DNS). There's usually no need to have redundancy at the Consul agent level on each machine, as that's part of the same failure domain as the machine itself.
> from: https://github.com/hashicorp/consul/issues/1916

## 使用 systemd 部署

待续

## Consul template

## Registrator

## 参考

1. consul 学习笔记（API 介绍）：https://skyao.gitbooks.io/learning-consul/content/docs/agent/httpapi/
2. consul 集群部署：https://www.hi-linux.com/posts/28048.html
3. 通过Consul-Template实现动态配置服务：https://www.hi-linux.com/posts/36431.html
4. python consul 文档：https://python-consul.readthedocs.io/en/latest/
5. 一个可能的 bug：https://github.com/hashicorp/consul/issues/4404