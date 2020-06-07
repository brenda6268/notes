# 消息队列：从一脸懵逼到 Kafka

wp_id: 764
Status: publish
Date: 2018-07-15 04:35:00
Modified: 2020-05-16 11:17:46

消息队列是分布式系统中分离解耦、削峰填谷、横向扩展的一个利器。而其中尤其以 kafka 为代表，在性能等各方面都很出众。

Kafka 使用 ZK 作为协调器，原生支持集群。每条消息有一个 `<key, value, timestamp>` 组成。

每个 partition 可以有多台机器，其中的 leader 负责所有读写，而 follower 复制 leader 的所有操作。如果 leader 挂了， follower 就会顶上去。生产者既可以使用 RR 这些算法来往不同的 partition 发东西，做负载均衡，也可以按照某些业务规则，发到指定的 partition。

消息队列有两种模型，Queue 和 PubSub。Kafka 通过 Consumer Group 这个概念很好地解决了这个问题

## 术语

|Term|Explain|
|--------|-----------------|
|Broker  | Kafka 集群中的机器|
|Topic   | 不同的消息队列|
|Partition | 每个 topic 被分成不同的分区|
|Producer | 生产者|
|Consumer | 消费者|
|Consumer Group| 消费组，每个消费组对于同一条消息，只消费一次|

## Basics

Kafka 非常强大，基本实现了一个后端工程师对消息队列的所有幻想。excat once 语义、消息是基本有序的、可以回放消息（rewind）。唯一的一个致命缺点是：部署实在太复杂了，不光是要依赖 zookeeper，而且还有其他负载的部署步骤。另外 kafka 对内存的需求不小，官方建议不要小于 32G，不过对于企业来说这也不是什么问题。

虽然 kafka 本身能够做到 exactly once 语义，

Like many publish-subscribe messaging systems, Kafka maintains feeds of messages in topics. Producers write data to topics and consumers read from topics. Since Kafka is a distributed system, topics are partitioned and replicated across multiple nodes.[1]

What makes Kafka unique is that Kafka treats each topic partition as a log (an ordered set of messages). Messages are stored as file in each partition and new messages are appended to the file, which is very fast op for hard disk(even faster than RAM access).

Kafka retains all messages for a set amount of time, and consumers are responsible to track their location in each log. Consequently, Kafka can support a large number of consumers and retain large amounts of data with very little overhead. Thus, consumers can rewind to a old message, which is very useful in
practice.

There is no message ids in kafka, message is identified by offset. messages are appended to each partition. Hard dist appendation can be veri fast, even faster than RAM access, which is why kafka

messages with the same key are sent to the same partition

## Consumer Group

kafka implements broadcast and unicast by Consumer Group. If one message is consumed by only one consumer, then it's a unicast, otherwise, it's a broadcast.

offsets in one partition are stored in ZooKeeper. each Consumer Group has its own offset. Consumer Group are globally in Kafka, not constrained to one topic. by default, a consumer is in the default group. each message can be consumed only once for one consumer group. messages in partitions are not equally distributed to each consumer, they are just simply fixed to one consumer. which is easy to implement and more efficient.

## Python 客户端

使用 confluent-python-kafka。性能最好，而且是官方客户端。Kafka-python 这个库可能丢消息。

比较重要的配置：

```
bootstrap.servers
enable.auto.commit
enable.auto.offset.store  # 在内存中保留最后一个消息的 id, 在 commit 的时候使用
queue.buffering.max.messages  # 生产者发送消息之前，在内存中最多缓存多少
queue.buffering.max.kbytes
queue.buffering.max.ms
group.id
max.poll.interval.ms  # 超时时间
```

### TopicPartition

TopicPartition 是 kafka 中很重要的一个类，他指定了一个分区的信息，包括了 topic, partition, offset

### Message

消息表示 Kafka 的一条消息，不可以由用户初始化，如果 error() 不是 None 的话，代表了一条错误信息。

    error() 检查是否是错误
    key() 返回消息的 key
    offset() 返回消息的 offset
    partition() 返回消息的 partition
    set_key/value() 设定消息的 key 和 value
    topic() 返回消息的 topic
    value() 返回消息的内容

## Producer

发送消息到 kafka. 

    flush(timeout) 把本地缓存的消息发送到 kafka
    poll() 处理 kafka 的事件
    produce(topic, value, key, partition, on_delivery, timestamp, headers) 发送消息到 kafka
    on_delivery(err, msg) 发送成功的回调

## Consumer

    close() 停止消费并离开 Consumer Group
    commit() commit 消费的 offset, 如果没有采用 autocommit 的话，必须手工 commit
    commit([message=None][, offsets=None][, asynchronous=True])

注意其中的 message 和 offsets 只能使用一个

    get_watermark_offsets, 获取分区的最前和最后的消费 offset
    get_watermark_offsets(partition[, timeout=None][, cached=False]) -> (int, int)

根据时间来查找 offset, 非常有用的一个函数

    offsets_for_times(partitions[, timeout=None])
    pause/resume(partitions), 暂停某分区的消费
    position(partitions[, timeout=None]), 获取当前分区的 offset 位置
    seek(partition)
    poll/consume 用来读取消息，两者的不同在于 consume 可以指定消费的个数，如果没有读取到消息，consume 返回为空。
    consume(num_messages, timeout=-1)
    assign(partitions) 给 consumer 指定要消费的 partition
    subscribe(topics, on_assign=None, on_revoke=None) 订阅 topic, on_assign 和 on_revoke 用于处理 assign 到的 partitions

    def on_assign(consumer, partitions)

## 管理工具

使用命令行管理 Kafka 功能最全面也最强大，但是因为命令不常用，所以也要经常查文档。而图形界面虽然不是很高效，但是对于偶尔使用来说，还是最方便的。

## 硬件需求

Kafka 直接把文件写到磁盘，也就是交给内核，这时候内核并不是直接写到磁盘，而是放到页面缓存中，所以内存肯定是大一点好。同时，Kafka 对于内存的使用也非常的节约，一般来说不会超过 5G。所以 Kafka 官方建议内存在 32G - 64G 之间。

不过对于小型应用来说，显然用不了这么多，这时候可以简单计算一下，需要的内存等于：

    memory = write_throughtput * 30

Kafka 对于 CPU 的使用没有什么特别大的需求。

硬盘的话，一定不要使用 NFS 就好了。

## Q&A

### kafka 中可以有成千上万的 topic 吗？

不可以。因为 leader 选举的一些限制，上万都不可能。最好的方式实在 topic 中分 partition。分 partition 又是静态的。

### Kafka 为什么这么快？

硬盘顺序读写可以达到 600 MiB/s 的速度，而随机读写只有 100 KiB/s，也就是说 6000 倍的差距。甚至于顺序读写比内存访问还要快。

使用 sendfile 可以使数据直接从 page cache 发送到网卡，避免了拷贝到用户空间的开销。


## push vs pull

Push 指的是 broker 向消费端推送消息，而 pull 指的是消费者主动从 Consumer 中拉取消息。Kafka 采用了 pull 模型。如果消费者处理不过来了就堆在 Kafka 中，当处理能力跟上来了再主动追上就好了。

# 其他

## nsq

topic: 发布消息的管道，第一次向某个 topic 发消息就会创建它。
channel: 消费消息的管道，一个 topic 可以对应几个 channel，每份消息都会复制到每个 channel 中
message：消息

nsq 建议 co-location 的部署，也就是在每个发送 nsq 消息的机器上部署一个 nsqd

## nsq 的缺点

1. 消息不是 exact once，可能有重复消息
2. 消息不能保证顺序
3. 消息可能丢，没有硬盘持久化

## redis stream

redis stream 看起来很好，但是实际上用处却不大。redis stream 虽然模仿了 kafka 的消息模型，但是 kafka 的强势在于消息堆积能力，而 redis stream 把消息放在内存里，也没有很好的 replica 机制。

## 参考

0. https://segment.com/blog/scaling-nsq/
1. [Apache Kafka for beginners](http://blog.cloudera.com/blog/2014/09/apache-kafka-for-beginners/)
2. http://lihaoquan.me/2016/6/20/using-nsq.html
3. Kafka Tutorial https://www.tutorialspoint.com/apache_kafka/apache_kafka_basic_operations.htm
4. http://www.infoq.com/cn/news/2015/02/nsq-distributed-message-platform
5. https://danielmiessler.com/blog/data-processing-using-the-unix-philosophy/
6. http://www.confluent.io/blog/apache-kafka-samza-and-the-unix-philosophy-of-distributed-data
7. http://sookocheff.com/post/kafka/kafka-in-a-nutshell/
8. https://www.infoq.cn/article/2017/09/kafka-python-confluent-kafka
9. https://www.confluent.io/blog/introduction-to-apache-kafka-for-python-programmers/
10. [生产环境硬件需求](https://docs.confluent.io/current/kafka/deployment.html)
11. [Quora 上关于硬件需求的讨论](https://www.quora.com/What-is-viable-hardware-for-Zookeeper-and-Kafka-brokers)
12. [Librdkafka 的配置参数](https://zhangchenchen.github.io/2018/06/03/kafka-intro/)
13. https://stackoverflow.com/questions/49276785/monitoring-ui-for-apache-kafka-kafka-manager-vs-kafka-monitor/49292872
14. https://kafka.apache.org/quickstart
15. https://cwiki.apache.org/confluence/display/KAFKA/Ecosystem
16. https://github.com/edenhill/librdkafka/blob/master/CONFIGURATION.md
17. https://zhuanlan.zhihu.com/p/37016944
5. https://www.confluent.io/blog/introduction-to-apache-kafka-for-python-programmers/
6. https://github.com/confluentinc/confluent-kafka-python/tree/master/examples
7. https://docs.confluent.io/current/clients/confluent-kafka-python/
8. https://stackoverflow.com/questions/32950503/can-i-have-100s-of-thousands-of-topics-in-a-kafka-cluser
9. https://grokbase.com/t/kafka/users/133v60ng6v/limit-on-number-of-kafka-topic
1. https://kafka.apache.org/documentation/#design_filesystem