我最喜欢的消息队列系统自然是 Kafka。Kafka 的 Consumer Group、Topic、Partition 这些抽象概念都非常的先进，组合使用这些概念可以高效解决绝大多数的业务问题。然而 Kafka 有一点不好的就是对系统资源消耗太高了，而我现在只有一台 2C8G 的机器，显然是连一个单实例的 kafka 都跑不起来，所以只好寻找类似的软件了。

Redis 在 5.0 版本带来了全新的 stream 数据结构，基本上是按照 Kafka 的理念来设计的。支持 consumer group，rewind 等特性。但是 redis stream 也有它的局限，主要在以下几方面：

- 没有实时落盘
- 没有 partition