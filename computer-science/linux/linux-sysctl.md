# Linux 下的内核参数调优与 sysctl

<!--
ID: 7d2742b8-6395-4570-9418-873c04f382be
Status: publish
Date: 2019-07-13T02:23:54
Modified: 2020-05-16T10:52:55
wp_id: 254
-->

最近在配置 influxdb 的 udp 端口的时候看到文档[1]里面提到：强烈建议修改 Linux 的默认网络 buffer 大小，否则会对性能有严重影响。感觉挺有意思，深入研究了一下 Linux 下 TCP 和 UDP 的一些参数配置。

## influxdb 的推荐配置

首先查看这两个配置：

```
sysctl net.core.rmem_max  # 读取 buffer 最大值
sysctl net.core.rmem_default  # 读取 buffer 默认值
```

然后更新这两个配置为 25 MiB

```
sysctl -w net.core.rmem_max=26214400
sysctl -w net.core.rmem_default=26214400
```

最后写入到配置文件，以便重启之后依然生效

```
# /etc/sysctl.conf
net.core.rmem_max=26214400
net.core.rmem_default=26214400
```

这里的设置其实就是增大网络 buffer 的大小，避免收到的 udp 包过多的时候造成丢包或者阻塞的现象。

## sysctl 命令

在上面的命令中，我们使用了 sysctl。sysctl 的 man page 也很简洁：sysctl - configure kernel parameters at runtime。也就是说在运行时调整内核参数。

```
sysctl -a 显示当前的所有参数
sysctl -w xxx=xxx 设定内核参数
sysctl xxx 显示内核参数的值
sysctl -fFILE 加载给定文件的值，默认是 /etc/sysctl.conf 也就是我们刚刚更改的文件
```

我们可以看下阿里云上默认的 ubuntu 机器的 /etc/sysctl.conf 文件：

```
tiger@iZ2ze0z0xdiqgv15k20evmZ [01:53:09 AM] [~]
-> % cat /etc/sysctl.conf
vm.swappiness = 0
net.ipv4.neigh.default.gc_stale_time=120

# see details in https://help.aliyun.com/knowledge_detail/39428.html
net.ipv4.conf.all.rp_filter=0
net.ipv4.conf.default.rp_filter=0
net.ipv4.conf.default.arp_announce = 2
net.ipv4.conf.lo.arp_announce=2
net.ipv4.conf.all.arp_announce=2

# see details in https://help.aliyun.com/knowledge_detail/41334.html
net.ipv4.tcp_max_tw_buckets = 5000
net.ipv4.tcp_syncookies = 1
net.ipv4.tcp_max_syn_backlog = 1024
net.ipv4.tcp_synack_retries = 2

kernel.sysrq=1
```

sysctl 可以控制的配置大概分成了以下几类：

- 内核子系统 (通常前缀为: kernel.)
- 网络子系统 (通常前缀为: net.)
- 虚拟内存子系统 (通常前缀为: vm.)
- MDADM 子系统 (通常前缀为: dev.)

对应的参数除了使用 sysctl 读取以外，还可以直接通过文件系统读取：

```
cat /proc/sys/net/core/
```

甚至也可以写入来直接更新内核参数，这样证实了 Linux 下一切皆文件的设计理念。


## 在 docker 中如何设置 sysctl

我们知道在 docker 中，容器适合宿主机共享同一个内核的，那么显然容器是不能随便动宿主机的配置的。所以 /proc/sys 目录在容器中默认是只读挂载的。

要想在容器运行的时候更改内核参数，需要在 docker run 的时候添加参数：

1. `--cap-add=SYS_ADMIN`
2. `--privileged`
3. `--sysctl`

以上三个参数任选其一，应该就可以了

## 在 kubernetes 中如何设置 sysctl

在 docker 中设置还好说，其实就是把默认的只读属性去掉就好了。在 kubernetes 的 pod 中要想设置 sysctl 就比较复杂了，因为你不知道 pod 究竟会调度到哪台机器上。在这里我没有深入研究了，毕竟 influxdb 这种有状态的服务还没有迁到 kubernetes 上，看了下官方文档[4]，大概思路是：

1. 给对应机器的 kubelet 指定参数，然后使用 taint 调度到这台机器上
2. 对于一些安全的属性，可以直接在 pod 中使用 securityContext 设置

```
apiVersion: v1
kind: Pod
metadata:
  name: sysctl-example
spec:
  securityContext:
    sysctls:
    - name: kernel.shm_rmid_forced
      value: "0"
    - name: net.core.somaxconn
      value: "1024"
    - name: kernel.msgmax
      value: "65536"
  ...
```


## 参考资料

1. https://docs.influxdata.com/influxdb/v1.7/supported_protocols/udp/
2. https://stackoverflow.com/questions/54845095/cannot-run-sysctl-command-in-dockerfile
3. https://www.kernel.org/doc/Documentation/sysctl/README
4. https://kubernetes.io/zh/docs/tasks/administer-cluster/sysctl-cluster/