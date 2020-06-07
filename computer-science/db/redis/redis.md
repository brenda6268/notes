## 糟粕

redlock sentinel cluster 都是垃圾。完全没有遵循分布式系统的基本概念。

## 主从复制

使用 slaveof ip port 就可以作为副本。

主节点首先执行一次 bgsave，然后发送 RDB 文件到从节点实现一次全量复制。

主节点和从节点分别维护一个复制偏移量（offset），代表的是主节点向从节点传递的字节数；主节点每次向从节点传播N个字节数据时，主节点的 offset 增加 N；从节点每次收到主节点传来的 N 个字节数据时，从节点的 offset 增加 N。

## 参考

1. https://www.cnblogs.com/kismetv/p/9236731.html