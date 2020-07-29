# Kubernetes 探针

<!--
ID: 38a23839-a53c-4669-8664-2fb6f7d15074
Status: draft
Date: 2020-06-07T17:35:04
Modified: 2020-06-07T17:35:04
wp_id: 1033
-->

Kubernetes 使用探针来确定服务当前的状态，以及是否需要重启和分配流量。

Kubernetes 中共有三类探针：

1. Startup Probe，用来探测 Pod 是否启动完成；
2. Liveliness Probe，用来探测 Pod 是否存活；
3. Readiness Probe，用来探测 Pod 是否就绪，可否分配流量。

看起来我们似乎只需要一个 Liveliness Probe 或者 Readiness Probe 就够了，毕竟只有当容器存活的时候我们给他分配流量就够了，为什么要分三个呢？

为什么需要 Startup Probe？

假设你的容器启动很慢，比如说启动的时候需要编译字节码之类的，那么你需要定义一个 Startup Probe，否则在启动过程中就可能因为没有响应而被干掉重启了，从而陷入死循环。

为什么需要 Readiness Probe？

假设你的容器已经启动了，可以响应简单的 Liveliness Probe 了，但是程序的主要功能需要加载一个很大的文件，这时候还不能提供席上服务，那么你需要定义一个 Readiness Probe，在数据加载完成后再通过检测，这时候 Kubernetes 才会分配流量。

当一个 Pod 启动的时候，大概的流程是这样的：

1. 如果定义了 Startup Probe，那么首先检查这个探针，直到这个探针成功的时候才开始检测 Liveliness Probe。
2. 如果定义了 Liveliness Probe，那么当这个探针检测失败的时候，重启服务。
3. 如果定义了 Readiness Probe，那么当这个探针成功的时候，给当前服务分配流量。

## 探针的实现方式

大概分为三种：

1. exec，看 shell 命令返回是不是 0
2. http get，看返回的状态码是不是正常的
3. tcp port，看端口有没有打开

## 参考

1. https://kubernetes.io/docs/tasks/configure-pod-container/configure-liveness-readiness-startup-probes/