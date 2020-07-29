# 分布式系统通信设计


<!--
ID: e00dab54-fe04-4073-9fec-f6da92980dec
Status: draft
Date: 2018-06-22T06:53:00
Modified: 2020-05-16T11:11:36
wp_id: 558
-->


服务之间的通信方式对比

一般来说，不同的服务之间有这么几种通信方式：扫表、消息队列和 RPC。其实和操作系统中的进程间通信方式也都是对应和类似的。

通过消息队列调用是异步的，而通过 rpc 调用是同步的

RESTful is not suitable for every situation. For resources, we could use RESTful, but for non-resources, such as user login/signup, restful is not working.

Thinking GET as query, POST as push is also a viable method. keep query/command seperated.

解耦：每个模块都是独立的，可以独立测试，调试
MQ：使用一个消息队列把所有的组件串联起来，这个 MQ 要求绝对的稳定，没有 bug，而其他的服务都不是长期运行的，每次都会被完全从头调用，也就是可重入的，不保存状态。

each component should be a middleware
each thread should do only one thing
each thread should be easily seperated easily
each middleware should be easily bypassable mockable dry-runable
2 way to communicate between components: MQ or RPC