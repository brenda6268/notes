# 分布式系统的一致性

wp_id: 560
Status: draft
Date: 2018-06-22 06:37:00
Modified: 2020-05-16 11:11:20

## CAP 理论

CAP 理论并不是简单的三选二，而是至少保证 P，然后在 CA 中二选一。P 指的是分区容忍性，也就是网络分区，比如两个数据中心之间的网络断掉的情况如何提供服务的。所以 CAP 应该理解为当 P 发生的时候，A（可用性）和 C（一致性）只能而选一。也就是当发生网络分区的时候，如果我们要继续服务，那么强一致性和可用性只能 2 选 1。

当发生网络分区的时候，在如果要提供服务就可能无法保证强一致性，如果保证一致性，就不一定能提供服务。实际上强一致性不一定是必须的，往往满足了最终一致性就可以了。

## ACID vs BASE

ACID 就是传统 SQL 数据库支持的事务特性，在单机上运行良好，但是在分布式系统中很难做到。BASE 指的是基本可用，最终一致

# raft 协议

参考：

1. https://www.zhihu.com/question/64778723
2. http://www.infoq.com/cn/articles/cap-twelve-years-later-how-the-rules-have-changed
3. http://www.hollischuang.com/archives/666
4. https://zhuanlan.zhihu.com/p/32052223
5. https://zhuanlan.zhihu.com/p/25933039
6. https://github.com/happyer/distributed-computing/tree/master/src/raft