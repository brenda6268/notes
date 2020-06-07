# 蛤？什么是 raft 协议？


wp_id: 562
Status: publish
Date: 2018-07-31 18:59:00
Modified: 2020-05-16 11:22:22


Raft 协议是一个分布式的一致性协议，主要通过 Leader Election 和 Log Replication 两个步骤来实现高可用的一致性状态存储。

这篇文章并不是 Raft 协议的一个完整介绍，只是其中核心概念的一个总结概括，要完全理解所有细节还是得看论文。

## Leader 选举

1. 每个节点有三种状态：follower、candidate、leader。
2. 作为 leader 有任期(term)的概念，根据基本法必须选举上台。Term 是一个自增的数字。
3. 作为 leader 要不断发送心跳给 follower，告诉他们一律不得经商。
4. 所有节点都有一个随机的定时器（150ms~300ms），当 follower 没有收到日志后就会升级为 candidate，term + 1，给自己投一票，并且发送 Request Vote RPC 给所有节点，也就是 apply for professor 啦。
5. 节点收到 Request Vote 后，如果自己还没有投票，而且比自己在的任期大，那就说明水平比自己高到不知道哪里去了，就投票出去，否则拒绝。
6. 如果节点发现自己的票超过了一半，就吟两句诗，钦点自己是 leader 了
7. 新的 leader 上台后，继续发送日志昭告天下，其他的 candidate 自动灰溜溜的变为 follower 了。

## 日志复制（Log Replication）

1. 所有的请求都发送给 leader，一律由中央负责。
2. leader 把收到的请求首先添加到自己的日志当中
3. 然后发送 Append Entries RPC 给所有的 follower，要求他们也添加这条日志
4. 当大多数的节点都添加这条日志之后，leader 上这条日志就变为了 commited
5. leader 再发送给所有的节点，告诉他们这条日志 commited
6. leader 返回给客户端，告诉他请求成功

## 分区容忍

如果网络发生了分区，也就是另立中央了，那么 raft 的日志复制机制也可以保证一致性。

比如下图中，由于中间的网络分区，出现了两个 leader，这之后如果给下面的 leader（Node B）中发送请求，因为它向一个节点中同步日志，所以只能获得两个节点的确认，因此提交失败。而如果向上面的leader 中发送请求，可以向两个节点中同步日志，也就是说一共三个节点都是同步的，那么就提交成功。不会出现两个 leader 分叉的情况。

![](https://tva1.sinaimg.cn/large/006tKfTcly1ftu1lfepqbj30zk0lmmz7.jpg)

参考资料：

1. [Raft 动画演示](http://thesecretlivesofdata.com/raft/)
2. [Raft 论文](http://www.infoq.com/cn/articles/raft-paper)