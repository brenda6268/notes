## 为什么速度快

1. 顺序读写磁盘，性能比内存读写还要高
2. 使用 sendfile，保证了零拷贝
3. 每个 topic 分成不同的 partition，水平拓展。 

partition 由多个 segment 实现，每个 segment 包括了 index 和 log 两个文件。“.index”索引文件存储大量的元数据，“.log”数据文件存储大量的消息

每个 partition 都有一个 High watermark 和 Log end offset. consumer 最多消费到 HW 处

每个 partition 内部都有 ISR，通过设置 min.insync.replicas 和 replica.lag.max.messages 来配置。ISR 中最小的 LEO 作为 HW

发送消息是可以通过设置来保证有几个 replica 写入了消息：request.required.acks

## 参考

1. https://www.infoq.cn/article/depth-interpretation-of-kafka-data-reliability