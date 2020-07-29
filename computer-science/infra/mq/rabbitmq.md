# rabbitmq 教程

<!--
ID: cae4aefe-4de2-476f-aad6-4f419e8e71ee
Status: publish
Date: 2018-08-07T17:10:00
Modified: 2020-05-16T11:22:57
wp_id: 614
-->

更新：弃坑了，rabbitmq 在我这里总是崩溃，实在没法正常使用


评估了几款 Message Queue，发现还是 rabbitmq 比较简单一些，各种特性也支持地很好。网上好多教程说“rabbitmq 非常重量级，适合企业应用开发”，这些话可以说是人云亦云，瞎扯了。实际上 rabbitmq 采用 erlang 开发，不光性能强大，而且从操作和运维上来说都是非常轻量级的。

# 基础概念

rabbitmq 实现的是 AMQP 0.9.1 协议，其中重要概念有：

* producer：生产者，生产消息
* consumer：消费者，消费消息
* routing-key: 每个消息中决定消息如何分发的参数
* exchange：类似路由，消息实际发送给 exchange，可以指定几种不同的分发算法，然后用 routing-key 作为参数计算出该发送到哪个队列中，一个exchange 可以和一个或者多个 queue 绑定，exchange 有如下几种分发算法
  * direct，直接按照 routing-key 和 queue 名字匹配
  * fan-out，发送到所有绑定的 queue 中
  * topic，利用 routing-key 和 queue 的名字模式匹配
* queue：缓冲消息，需要和 exchange 绑定
* binding：指的是 exchange 和 queue 之间的绑定关系

# 安装

Ubuntu:

```
sudo apt-get install rabbitmq-server
```

Python 客户端 pika

```
pip install pika
```

# 基础使用

和其他一些队列不一样的是，rabbitmq 的队列需要显式创建，不能直接发消息过去生成。可以使用 `sudo rabbitmqctl list_queues` 命令查看已有的队列。

下面是实现一个生产者，多个消费者的关系，如图所示：

![](https://www.rabbitmq.com/img/tutorials/prefetch-count.png)

生产者

```
import pika

connection = pika.BlockingConnection(pika.ConnectionParameters("localhost"))
channel = connection.channel()
channel.queue_declare(queue="hello", durable=True)  # 声明一个队列，rabbitmq 中的队列必须首先创建才能使用

# 发送消息需要指明发送到的 exchange，留空表示默认 exchange
# 默认的 exchange 会根据 routing-key 把消息发到对应的队列中
channel.basic_publish(exchange="",
                      routing_key="hello",
                      body="Hello World!",  # 消息体
                      properties=pika.BasicProperties(
                         delivery_mode = 2,  # AMQP 定义的，其中 1 代表不要持久化，2 代表需要持久化
                      ))
print(" [x] Sent "Hello World!"")

# 最后关闭链接
connection.close()
```

消费者

消费者通过注册处理函数，来消费消息，可以同时使用多个消费者消费同一个队列。

```
#!/usr/bin/env python
import pika

connection = pika.BlockingConnection(pika.ConnectionParameters(host="localhost"))
channel = connection.channel()


channel.queue_declare(queue="hello", durable=True)

def callback(ch, method, properties, body):
    print(" [x] Received %r" % body)
    ch.basic_ack(delivery_tag = method.delivery_tag)

channel.basic_qos(prefetch_count=1)  # 最多有一个消息没有 ack
channel.basic_consume(callback,
                      queue="hello",
                      no_ack=False)  # 默认情况加就是 False，也就是需要 ack

print(" [*] Waiting for messages. To exit press CTRL+C")
channel.start_consuming()

```

可以直接使用多个消费者来消费同一个队列，默认情况下 rabbitmq 采用了 round robin 的算法，也就是消息会依次发送给每一个消费者。

如果没有 ack 的话，rabbitmq 的内存最终可能会占满

# 使用其他的 exchange

rabbitmq 中默认的 exchange 是 `direct` exchange，也就是直接把收到的消息放到 routing key 对应的队列中。rabbitmq 还支持不少其他的类型，可以看文章开始的讨论。

下面的例子通过使用一个 fanout 类型的 exchange 来实现消息发送给所有消费者。

![](https://www.rabbitmq.com/img/tutorials/python-three-overall.png)

```
#!/usr/bin/env python
import pika
import sys

connection = pika.BlockingConnection(pika.ConnectionParameters(host="localhost"))
channel = connection.channel()

# 声明一个 fanout 类型的 exchange，名字为 logs
channel.exchange_declare(exchange="logs",
                         exchange_type="fanout")

message = " ".join(sys.argv[1:]) or "info: Hello World!"
channel.basic_publish(exchange="logs",
                      routing_key="",
                      body=message)
print(" [x] Sent %r" % message)
connection.close()
```

消费者

Exchange 需要和 queue 绑定才会发送消息，否则会直接丢掉。
queue 需要和 exchange 绑定之后才能够接收到消息，而所有的 queue 默认已经是和默认 exchange 绑定的，所以在上一个例子中并没有使用绑定。



```
#!/usr/bin/env python
import pika

connection = pika.BlockingConnection(pika.ConnectionParameters(host="localhost"))
channel = connection.channel()

channel.exchange_declare(exchange="logs",
                         exchange_type="fanout")

# 声明一个临时的私有 queue
result = channel.queue_declare(exclusive=True)
queue_name = result.method.queue

# 绑定 queue 到刚刚声明的 exchange
channel.queue_bind(exchange="logs",
                   queue=queue_name)

print(" [*] Waiting for logs. To exit press CTRL+C")

def callback(ch, method, properties, body):
    print(" [x] %r" % body)

channel.basic_consume(callback,
                      queue=queue_name,
                      no_ack=True)

channel.start_consuming()
```

# 常见问题

## 在一个循环中发送消息，为什么有时候会提示 Channel Closed?

使用 BlockingConnection 需要手动管理心跳，如果超过心跳时间就会被关闭链接。常见的错误包括使用了 time.sleep 导致长时间没有 publish 消息，从而链接被关闭。

可以通过单独开一个心跳线程的方法，或者使用 [connction.sleep](https://github.com/pika/pika/commit/df6a31630c530559cc61df14c1f23813b870d80a)。当然使用 connction.sleep 无法避免本身操作时长超过了心跳时间的情况。

# channel 和 connection 的区别？

Connection 表示的是到 rabbitmq broker 的一个物理连接，一般一个程序使用一个链接，或者使用一个连接池，可以使用心跳来维护一个链接，理论上应该在多个线程之间分享，很遗憾 python 的客户端 pika 并不是线程安全的。

而channel 则应该是短时效的，在每个线程内部创建，不是线程安全的。

1. https://stackoverflow.com/questions/18418936/rabbitmq-and-relationship-between-channel-and-connection
2. https://www.rabbitmq.com/tutorials/amqp-concepts.html

## 如果客户端重启，之前的匿名队列会被删除吗？如果没有别删除，还能连接上之前的匿名队列吗？如果连不上是不是消息就都丢了？

To be answered

# UI管理工具

在向队列中发消息的过程中，尤其是在学习或者排查错误的时候，可以通过 rabbitmq 的管理工具来查看当前消息队列中的消息。

首先，激活管理工具插件：

```
rabbitmq-plugins enable rabbitmq_management
```

然后添加用户

```
rabbitmqctl add_user username password
rabbitmqctl set_user_tags username administrator
rabbitmqctl set_permissions -p / username ".*" ".*" ".*"
```

然后可以打开：http://server-name:15672/ 查看，使用刚刚设置的密码登录

![](https://ws1.sinaimg.cn/large/0069RVTdly1fu228vp43hj31kw0v9jyg.jpg)

# 参考：

1. http://www.rabbitmq.com/management.html
2. https://www.rabbitmq.com/tutorials/tutorial-three-python.html
3. https://github.com/pika/pika/issues/196