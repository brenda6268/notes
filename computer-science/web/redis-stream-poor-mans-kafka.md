# Redis Stream - 穷人版的Kafka


ID: 608
Status: draft
Date: 2018-07-15 04:57:00
Modified: 2020-05-16 11:18:37


2019-02-15 更新

仔细想了下，redis stream 看起来很好，但是实际上用处却不大。redis stream 虽然模仿了 kafka 的消息模型，但是 kafka 的强势在于消息堆积能力，而 redis stream 把消息放在内存里，也没有很好的 replica 机制。

----------正文----------

Redis 5.0 终于把期待已久的 Stream 类型添加了而进去，Stream 类型简单来说就是一个
内存版的 Kafka。虽然实现完全不同，但是和 Kafka 的好多概念都是相通的，下文假设你
已经对 Kafka 的使用比较熟悉了。

Redis Stream 相对于 Kafka 最大的优点就是简单了。Kafka 必须要搭建集群，而且首先要
先搭建一个 ZooKeeper 集群，而 Redis 只需要单机运行就可以了。

Redis Stream 也是一个日志流，支持 Consumer Group 等概念。

## 基本操作

### 插入事件（消息）

使用 XADD 命令来向 Stream  中插入一个消息

```
&gt; XADD mystream * sensor-id 1234 temperature 19.8
1518951480106-0
```

注意其中的星号，表示我们要求 redis 生成一个唯一的消息 ID，这个 ID 是单调递增的。
一般情况下我们都会让 Redis 来生成这个ID。

```
&gt; XLEN mystream
(integer) 1
```

### 读取消息

redis 支持 kafka 中 consumer group 的概念。

### XRANGE

#### 按区间读取消息

```
&gt; XRANGE mystream - +
1) 1) 1518951480106-0
   2) 1) &quot;sensor-id&quot;
      2) &quot;1234&quot;
      3) &quot;temperature&quot;
      4) &quot;19.8&quot;
2) 1) 1518951482479-0
   2) 1) &quot;sensor-id&quot;
      2) &quot;9999&quot;
      3) &quot;temperature&quot;
      4) &quot;18.2&quot;
```

其中 - 和 + 表示最开始的消息和最后的消息

#### 按时间范围读取消息

因为Redis 默认生成的消息ID 中包含了时间戳，所以我们还可以按照时间范围来读取消息

```
&gt; XRANGE mystream 1518951480106 1518951480107
1) 1) 1518951480106-0
   2) 1) &quot;sensor-id&quot;
      2) &quot;1234&quot;
      3) &quot;temperature&quot;
      4) &quot;19.8&quot;
```

这样做的原理是：redis stream 的 ID 是由两部分构成的，如果省略了后半部分，那么在作为开始的ID
中会认为是0，而在结束的ID中会认为是最大ID。

XRANGE 还支持 count 参数，用来限定返回的消息数量。

```
&gt; XRANGE mystream - + COUNT 2
1) 1) 1519073278252-0
   2) 1) &quot;foo&quot;
      2) &quot;value_1&quot;
2) 1) 1519073279157-0
   2) 1) &quot;foo&quot;
      2) &quot;value_2&quot;
```

XRANGE 的复杂度是 O(logn)，所以可以使用 XRANGE + COUNT 来实现遍历。

### XREAD

XREAD 命令从一个或者多个 stream 中读取消息，所以返回结果中包含了队列的名字
```
&gt; XREAD COUNT 2 STREAMS mystream 0
1) 1) &quot;mystream&quot;
   2) 1) 1) 1519073278252-0
         2) 1) &quot;foo&quot;
            2) &quot;value_1&quot;
      2) 1) 1519073279157-0
         2) 1) &quot;foo&quot;
            2) &quot;value_2&quot;
```

### Consumer Group

- XGROUP，用来创建消费组
- XREADGROUP，用来通过消费组读消息
- XACK 用来标记一个消息已经被处理了

创建消费组，语法是 `XGROUP CREATE stream_name group_name last_msg_id`

```
&gt; XGROUP CREATE mystream mygroup $
OK
```

其中 $ 表示从当前最后一个消息开始读取，而 0 表示从第一个消息开始读取。

消息从 stream 中读出之后就进入了 pending 状态，当客户端处理完毕这条消息之后应该
使用 XACK 确认消息执行完毕。
使用 XREADGROUP 从消费组中读取消息，格式是：

```
XREADGROUP GROUP group_name consumer_name COUNT n STREAMS stream_name msg_id ...
```


```
&gt; XREADGROUP GROUP mygroup Alice COUNT 1 STREAMS mystream &gt;
1) 1) &quot;mystream&quot;
   2) 1) 1) 1526569495631-0
         2) 1) &quot;message&quot;
            2) &quot;apple&quot;
```

注意我们使用了一个特殊的 ID `>`, 使用这个 ID 表示读取一个从来没有处理过的消息，
并且把 last_msg_id +1. 我们还可以使用一个具体的ID，这时候只会读取pending的消息，
而不会有有其他的副作用


确认消息执行完成：

```
&gt; XACK mystream mygroup 1526569495631-0
(integer) 1
```

需要注意的一点：XREADGROUP 虽然是一个读操作，但是他是有副作用的（增大了
last_msg_id），所以他也是一个写操作，也就只能在主节点上操作。

一个操作 redis stream 的 Python 例子：

```
import redis
import sys

if len(sys.argv) &lt; 2:
    print(&#039;Please specify a consumer name&#039;)
    sys.exit(1)

consumer_name = sys.argv[1]
group_name = &quot;mygroup&quot;

r = redis.StrictRedis()

def process_message(id, msg):
    print(f&#039;{consumer_name} {id} = {msg.inspect()})

last_id = &#039;0-0&#039;

print(f&#039;consumer {consumer_name} starting...&#039;)
check_backlog = True

while True:
    # Pick the ID based on the iteration: the first time we want to
    # read our pending messages, in case we crashed and are recovering.
    # Once we consumer our history, we can start getting new messages.
    if check_backlog:
        myid = last_id
    else:
        myid = &#039;&gt;&#039;

    items = r.xreadgroup()

```