# 使用 Nomad 编排服务


wp_id: 559
Status: publish
Date: 2018-11-22 22:57:00
Modified: 2020-05-16 11:06:38


2019-01-02 更新：相对于 Kubernetes 来说，Nomad 还是太简陋了，弃坑


Nomad 是 HashiCorp 出品的一个容器编排服务，相较于重量级的 Kubernetes 来说，Nomad 的特点在于

1. 轻量级，只有一个二进制文件。K8s 的安装可能就要花上半天，在国内还有万恶的防火墙问题。
2. 概念也比较清晰，专注于任务的调度的编排，而不像 Kubernetes 一样引入了各种五花八门的概念。
3. 除了编排容器之外，Nomad 还可以直接编排普通应用，使用 cgroups 安全运行应用。

# 安装

从官网下载二进制文件，复制到 /usr/local/bin 就好了，不再赘述

# 使用

```
$ sudo nomad agent -dev

$ nomad node status
ID        DC   Name   Class   Drain  Eligibility  Status
171a583b  dc1  nomad  <none>  false  eligible     ready

$ nomad server members
Name          Address    Port  Status  Leader  Protocol  Build  Datacenter  Region
nomad.global  127.0.0.1  4648  alive   true    2         0.7.0  dc1         global
```

# Job

Nomad 的调度单元称作 Job，Job 分为了三种类型：

1. Batch，也就是一次批处理，程序运行之后就结束了。不过也可以通过 cron 字段指定任务定期运行
2. Service，程序是一个常驻内存的服务，如果退出之后，Nomad 会按照给定的策略重启
3. System，在每一个 Nomad 节点上都需要运行的服务

Job 可以使用 HCL 文件来定义，HCL 文件在语义上和 JSON 是等价的，只不过是省去了一些多余的引号逗号之类的。也可以使用 JSON 文件来定义。

## 创建一个新的 Job

创建一个空白的 job 文件

```
$ nomad job init
Example job file written to example.nomad
```

打开生成的 example.nomad 文件，我们看到生成了一大推配置，默认定义了一个 redis 服务器的 job。Job 中包含了 Group，Group 中包含了 Task，task 可以认为是我们最终需要运行服务的那个命令。比如这里就是定义了运行 redis:3.2 这个 docker 镜像。

```
task "redis" {
  # The "driver" parameter specifies the task driver that should be used to
  # run the task.
  driver = "docker"

  # The "config" stanza specifies the driver configuration, which is passed
  # directly to the driver to start the task. The details of configurations
  # are specific to each driver, so please see specific driver
  # documentation for more information.
  config {
    image = "redis:3.2"
    port_map {
      db = 6379
    }
  }
```

我们可以运行一下这个 job

```
-> % nomad job run example.nomad
==> Monitoring evaluation "4f5559e0"
    Evaluation triggered by job "example"
    Allocation "98959767" created: node "ecf9f7cd", group "cache"
    Evaluation within deployment: "e66e0957"
    Evaluation status changed: "pending" -> "complete"
==> Evaluation "4f5559e0" finished with status "complete"
```

然后查看一下 job 的运行状态：

```
$ nomad status example
...
Allocations
ID        Node ID   Task Group  Version  Desired  Status   Created  Modified
8ba85cef  171a583b  cache       0        run      running  5m ago   5m ago
```

在最下面一行我们可以看到 Allocation 的状态。Allocation 可以理解为一个 Job 的一个实例化。

我们可以再查看这个 Alloc 的状态：

```
$ nomad alloc status 8ba85cef
...
Recent Events:
Time                   Type        Description
10/31/17 22:58:49 UTC  Started     Task started by client
10/31/17 22:58:40 UTC  Driver      Downloading image redis:3.2
10/31/17 22:58:40 UTC  Task Setup  Building Task Directory
10/31/17 22:58:40 UTC  Received    Task received by client
```

查看 Alloc 的日志

```
$ nomad alloc logs 8ba85cef redis
```

## 修改 Job

比如说，我们可以把这个 Job 中 cache task group 需要运行的副本数量改为 3

```
count = 3
```

使用 nomad job plan 来 dry run 一下。

```
$ nomad job plan example.nomad

+/- Job: "example"
+/- Task Group: "cache" (2 create, 1 in-place update)
  +/- Count: "1" => "3" (forces create)
      Task: "redis"
...
Job Modify Index: 7
To submit the job with version verification run:

nomad job run -check-index 7 example.nomad
...
```

注意到其中返回了一个 check-index 这个是为了避免同时更改同一个 job 造成冲突。

```
$ nomad job run -check-index 7 example.nomad
```

# 集群

在生产环境中，我们当然应该使用集群模式，而不是单机。nomad 可以直接利用 consul 来实现 bootstrap 集群。

服务端配置：

```
# /etc/nomad.d/server.hcl

data_dir = "/etc/nomad.d"

server {
  enabled          = true
  bootstrap_expect = 3
}
```

启动：

```
$ nomad agent -config=/etc/nomad.d/server.hcl
```

客户端配置：

```
# /etc/nomad.d/client.hcl

datacenter = "dc1"
data_dir   = "/etc/nomad.d"

client {
  enabled = true
}
```

启动：

```
$ nomad agent -config=/etc/nomad.d/client.hcl
```