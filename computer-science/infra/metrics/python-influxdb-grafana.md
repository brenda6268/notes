# Python + Influxdb + Grafana 的监控系统


ID: 739
Status: publish
Date: 2018-10-16 02:18:00
Modified: 2020-05-16 11:25:51


# influxdb 

为什么我们要把监控数据存到 influxdb 呢? 存到 MySQL 或者 MongoDB 甚至 Elasticsearch 不好么?

数据模型上, 监控数据是和时间相关的, 脱离点产生的时间, 那么数据将毫无意义, 传统数据库中并没又强调这一点.

性能上, influxdb 是时间序列数据库, 这类数据库面临的问题是写入非常多, 而读取比较少. 而普通的数据库一般都是读比较多, 而写入较少, 并且要保证写入的正确性. 

监控打点显然是一个面向时间序列的过程, 并且写入非常多, 而一般只有在触发告警, 排查问题的时候可能读取才比较多. 所以从性能和功能考虑上来说, 传统数据库都是不适用的.

influxdb 中常见的存储数据格式:

```
cpu_usage value=49 1502043216
cpu_usage value=50 1502193042
cpu_usage value=5 1502196258
```

## influxdb 数据模型

我们以一个 measurement(测量) 作为一个表, tag-value, field-value 都是记录数据的键值对, 区别是 tag 是由索引的, 而 field 没有, timestamp 是时间戳. tag set 自然指的是一组 tag 的组合.

```
measurement,tag=value,tag1=value1 field=value,field1=value1 timestamp
```

`measurement + tag set` 被称为一个序列(series). 每一个 series 都可以指定不同的 retention policy.

## influxdb 查询

使用类似 SQL 的语言, 执行 `influx` 进入shell

```
&gt; CREATE DATABASE mydb
&gt; SHOW DATABASES
&gt; USE mydb
```
插入数据, 和 SQL 差别还是挺大的, 其中 cpu 是 measurement, 也就是 "表名", 没指定时间的话, influxdb 会自己加上.

```
INSERT cpu,host=serverA,region=us_west value=0.64
```

查询数据, 注意多出来的 timestamp 一栏

```
&gt; SELECT &quot;host&quot;, &quot;region&quot;, &quot;value&quot; FROM &quot;cpu&quot;
name: cpu
---------
time		    	                     host     	region   value
2015-10-21T19:28:07.580664347Z  serverA	  us_west	 0.64
```


## 回收策略

默认情况下, influxdb 会永久保留数据, 一般来说这样是没有意义的, 我们可以设置短一点.

```
CREATE RETENTION POLICY &lt;retention_policy_name&gt; ON &lt;database_name&gt; DURATION &lt;duration&gt; REPLICATION &lt;n&gt; [DEFAULT]
```

其中 replication 只能设置为 1, 因为开源版只有 1. 可以设置成 30d, 1w



# Python 客户端的编写

看到这里有人可能要问了, 不是有 python-influxdb 这个库么, 好好地客户端你为什么要封装一层呢? 答案很简单: 性能.

1. 调用 `influxdb.write_points()` 是一个涉及到网络的阻塞操作, 极有可能对于程序造成性能影响.
2. 如果我们在程序中散落着各种打点的代码, 那么就会造成没打一个点都去调用一些 IO, 不如放在一个队列里面可以每次多打几个, 减少 IO 次数, 这样对程序和 influxdb 的性能都有好处.

## UDP vs http

influxdb 支持使用 UDP 和 HTTP 两种协议访问. 显然对于打点这种操纵来说, 我们不关心响应结果, 哪怕一个点没打上, 没打上就没打上吧......所以采用 UDP 就好了. 根据测试 udp 的性能在 http 的几十倍.

按照 influxdb 官网的建议, 我们需要调整 UDP buffer 的 size 到 25MB(26214400B) 为宜.

查看系统的 udp buffer 大小:

```
$ sysctl net.core.rmem_max
$ sysctl net.core.rmem_default
```

修改 `/etc/sysctl.conf` 文件: 

```
net.core.rmem_max=26214400
net.core.rmem_default=26214400
```

但是这个设置只有到下次重启才能生效, 继续使用 sysctl 设置立即生效:

```
$ sysctl -w net.core.rmem_max=26214400
$ sysctl -w net.core.rmem_default=26214400
```

另外注意, UDP 有一个大坑, 只吃吃精度为 s 的打点, 所以在配置和客户端中都必须使用这个时间精度.


P.S. 中文互联网上的好多教程都在使用 http 打点, 误人子弟, 毁人不倦啊......


参考:

1. https://docs.influxdata.com/influxdb/v1.6/supported_protocols/udp/
2. https://github.com/MikaelGRA/InfluxDB.Client/issues/31
3. https://blog.codeship.com/a-deep-dive-into-influxdb/
4. http://docs.grafana.org/features/datasources/influxdb/