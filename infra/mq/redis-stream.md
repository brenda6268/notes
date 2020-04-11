# 使用 Redis Stream 作为消息队列

我最喜欢的消息队列系统自然是 Kafka。Kafka 的 Consumer Group、Topic、Partition 这些抽象概念都非常的先进，组合使用这些概念可以高效解决绝大多数的业务问题。然而 Kafka 有一点不好的就是对系统资源消耗太高了，而我现在只有一台 2C8G 的机器，显然是连一个单实例的 kafka 都跑不起来，所以只好寻找类似的软件了。

使用 redis list 自然是非常不推荐的。

Redis 在 5.0 版本带来了全新的 stream 数据结构，基本上是按照 Kafka 的理念来设计的。支持 consumer group，rewind 等特性。但是 redis stream 也有它的局限，主要在以下几方面：

- 没有实时落盘
- 没有 partition 的概念

使用方式：

0. 每个 consumer group 必须手动创建；
1. 每一个 consumer 可以有一个 name，最好就是自己的 IP；
2. 每个 worker 消费时首先检查自己的 backlog，如果有的话，先消费 backlog；
3. 还有一个独立的线程，使用 xpending 检查是否有 worker 彻底挂掉的，并且 claim 过来。线程检查 claim 的时间要随机化，尽量避免争抢。

## 参考资料

1. https://redis.io/topics/streams-intro
