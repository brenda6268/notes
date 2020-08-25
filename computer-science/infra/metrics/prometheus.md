# 使用 Prometheus 监控应用数据

<!--
ID: 0b574398-0507-417d-8015-8b2e1e00f046
Status: publish
Date: 2020-07-29T19:46:41
Modified: 2020-07-29T19:46:41
wp_id: 1092
-->

Prometheus 是使用 Go 语言开发的一个监控工具和时序数据库，它的实现参考了 Borgmon。监控系统大体来说分两种模式，push 和 pull。push 模式就是应用程序主动把监控数据推送到监控服务，pull 模式就是监控服务来主动拉取应用的数据。Prometheus 采用的是 Pull 模式。

对于自己编写的应用，可以使用 prometheus 的 sdk 来自己提供 metrics，对于开源的软件，可以使用对应的 exporter .

![](https://blog.frognew.com/images/2017/05/prometheus-architecture.png)

## 监控系统基础原则

- 尽量简单，不要上来就想搞个大新闻，喧宾夺主
- 告警也尽量简单，只发需要处理的告警
- 简单的架构就是最好的架构，业务系统都挂了，监控也不能挂。

不要想着把所有的数据都显示到监控上，太多了反倒是让人失去了重点。想象一下最容易出错的情况，以及在这种情况下你应该怎么用监控来排错。

- 一个控制台不要有超过 5 个图。
- 每个图上不要有超过五条线。当然堆栈图和饼形图除外。
- 当使用提供的模板时，避免在右手边的表格里有多过 20-30 个条目。

系统的每个部分都应该有一个监控，至少让你大概知道这个系统现在的情况如何。

也不要想着把特别复杂的业务数据画到监控系统上，监控是监控，业务是业务，不能相互替代。

## Prometheus 的指标类型

Prometheus 常用的有四种类型：计数器 (counter), 刻度 (gauge), 直方图 (histogram), 摘要 (summary).

计数器只增不减，用来记录一件事情发生了多少次，可以使用 `rate(some_counter[interval])`（具体含义后面会说到）来计算一件事情的速率。Counter 类型主要是为了 `rate` 而存在的，即计算速率，单纯的 Counter 计数意义不大，因为 Counter 一旦重置，总计数就没有意义了。rate 会自动处理 Counter 重置的问题，Counter 的任何减少也会被视为 Counter 重置。

Gauges 可以被设定，可以增高，可以减小。用来记录状态，比如正在进行的请求的数量，空闲内存数，温度等。对于 gauge 值，不要使用 `rate`. 可以使用 `max_over_time` 等来处理 gauge 数据。

Histogram 和 Summary 都是采样观测量，典型的比如请求的时间和相应的体积等等。他们记录观测的数量和观测的所有值，允许你计算平均值等。Histogram 实际上是一个复合值，由三部分组成，一部分是观测到的值，存在不同的 bucket 中，而 bucket 的大小则由用户指定，默认情况下是观测一个网页请求的延迟。观测的数量（也就是`_count`) 变量是一个 counter 类型的值，观测的和（也就是`_sum`) 变量也类似一个 counter, 当观测值没有负数的时候。显然响应时间和响应体积都是正的。

Histogram 类型数据最常用的函数是 histogram_quantile 了，可以用来计算 P95,P99 等数据。

如果有一个观测值叫做 `http_request_duration_seconds`, 那么要计算刚过去的 5 分钟内的平均时长可以这样算：

```prometheus
# 先不用理解，后边会讲到
rate(http_request_duration_seconds_sum[5m]) / rate(http_request_duration_seconds_count[5m])
```

Histogram 在服务端计算，Summary 在客户端计算并且不能被重新计算。如果可能的话，最好使用 Histogram, 不要使用 summary. 

另外，Prometheus 支持 labels, 也就是标签，这样就可以很好地查询过滤指标，而不需要创建很多的指标了。

## 输出指标到 Prometheus

这里以 Python 为例。

```
pip install prometheus_client
```

### Counter

```py
from prometheus_client import Counter

# 按照 Prometheus 的最佳实践, counter 类型的数据后缀是 _total
# prometheus 客户端会智能处理 _total 后缀，在后台总是有 _total 后缀的
c = Counter("http_request_failures_total", "http 请求出错计数")
c.inc()  # 默认是 1
c.inc(2)  # 也可以指定数字
```

Counter 还有一个方便的属性，叫做 count_exceptions, 可以用作装饰器或者 with 语句中。

```py
@c.count_exceptions()
def f():
    pass

with c.count_exceptions():
    pass

with c.count_exceptions(ValueError):
    pass
```

### Gauge

```py
from prometheus_client import Gauge

g = Gauge("cpu_usage", "CPU 使用率")
g.inc()
g.dec(10)
g.set(4.2)
```

Gauge 也有一些方便的辅助函数，比如说 track_inprogress 用来记录正在执行的数量。

```py
 g.set_to_current_time()

 # Increment when entered, decrement when exited.
@g.track_inprogress()
def f():
  pass

with g.track_inprogress():
  pass
```

也可以给 gauge 设定一个回调函数来取值：

```py
d = Gauge('data_objects', 'Number of objects')
my_dict = {}
d.set_function(lambda: len(my_dict))
```

### Histogram 

值得注意的是，histogram 默认定义的 buckets 大小是为了正常的网页请求设计的，也就是围绕着一秒的一些数据。如果我们需要观测一些其他的值，那么需要重新定义 buckets 的大小。

一般来说，buckets 是呈指数分布的，中间值为最常见的典型值，这样可以更好地拟合实际的分布(幂次分布)。因为 buckets 是以 label 的形式实现的，所以 buckets 最好也不要超过十个。

```py
from prometheus_client import Histogram

h = Histogram()
h.observe(4.7)

@h.time()
def f():
  pass

with h.time():
  pass

# 默认的 buckets[0.005, 0.01, 0.025, 0.05, 0.1, 0.25, 0.5, 1, 2.5, 5, 10]
h = Histogram(buckets=[1, 10, 100])
```

### 标签导出

如果要导出标签的话，需要使用 labels 方法

```py
from prometheus_client import Counter
c = Counter('my_requests_total', 'HTTP Failures', ['method', 'endpoint'])
c.labels(method='get', endpoint='/').inc()
c.labels(method='post', endpoint='/submit').inc()
```

### HTTP 服务器

前面我们提到 Prometheus 是采用的拉模型，那么从哪儿拉数据呢？需要我们的程序开启一个 http 的服务器，这样 Prometheus 才能来拉取数据。

如果实在普通的脚本里面，可以这样：

```py
from prometheus_client import start_http_server

start_http_server(8000)
```

如果本身就是个 web 服务器，那么直接 mount 导一个路径就好了。不过实际上这是不可用的，因为生产中的服务器都是多进程的，而 Prometheus 的 Python 客户端不支持多进程。

```py
from flask import Flask
from werkzeug.middleware.dispatcher import DispatcherMiddleware
from prometheus_client import make_wsgi_app

# Create my app
app = Flask(__name__)

# Add prometheus wsgi middleware to route /metrics requests
app.wsgi_app = DispatcherMiddleware(app.wsgi_app, {
    '/metrics': make_wsgi_app()
})
```

很遗憾的是, Prometheus 的 Python 客户端对于多进程的支持不好.

## 使用 PromQL 查询指标

### 数据类型

在 Prometheus 中有四种数据类型，分别是：数字，字符串，直接向量 (instant vector) 和区间向量 (range vector).

数字和字符串就不用说了，重点说一下后两个向量。直接向量其实就是指标，比如说 `http_request_count`, 他就是一个一维的时间向量。而区间向量其实是二维的，在每一个时间点都是一个向量。

那么怎么生成区间向量呢？使用 `[]` 操作符。比如说 `http_requests_total[5m]`, 表示在每个时间点，该时间点过去五分钟的时间序列，也就是二维的。那么区间向量有什么用呢？答案很简单：给 rate 函数使用。

比如说，我们常见的计算网页 qps 的函数：`rate(http_requests_toal[5m])`, 意思就是，在每个时间点都取前五分钟的统计数据计算访问速率，实际上这不就是求导么，而 5m 就是其中 dx 的取值。但是和微分不一样的是，dx 肯定不是越小越好，因为 Prometheus 抓取数据有间隔，所以显然不能小于抓取间隔，一般取抓取间隔的 4 倍左右，5m 就是个很好的值。采样周期 `5m` 如果设置的大一些，图像就会更平滑，如果小一些就会更精确。

官方建议将 Rate 计算的范围向量的时间至少设为抓取间隔的四倍。这将确保即使抓取速度缓慢，且发生了一次抓取故障，也始终可以使用两个样本。此类问题在实践中经常出现，因此保持这种弹性非常重要。例如，对于 1 分钟的抓取间隔，您可以使用 4 分钟的 Rate 计算，但是通常将其四舍五入为 5 分钟。

### 查询语法

使用 `{}` 来过滤指标, 大概相当于 SQL 中的 where 子句。除了 `=` 之外，还有 `!=` 和 `=~`（正则） 和 `!~`（不匹配）

```
<metric name>{<label name>=<label value>, ...}
```

比如：

```
api_http_requests_total{method="POST", handler="/messages"}
```

如果要查询历史数据可以使用 `offset xx` 来查询。比如下面这条表示比过去一个小时的 gc fraction 还要大 1.5 倍的数据。

```
go_memstats_gc_cpu_fraction > 1.5 * (go_memstats_gc_cpu_fraction offset 1h)
```

使用 `by` 关键字可以聚合字段：

```
# sum+rate 其实是求和的意思（求导再积分）, 然后按照 instance 聚合
sum(rate(node_network_receive_bytes_total[5m])) by (instance)
```

### 常用函数

## 使用 Dashboard 展示指标

## 可视化界面

Prometheus 自带了在 /graph 下有一个 expression browser, 可以绘制一些简单的图形，除此之外还是建议使用 grafana.

## 数据采集配置

```yaml
global:
  scrape_interval: 15s

scrape_configs:
  - job_name: prometheus
    static_configs:
      - targets: ["localhost:9090"]
```

对每一个 job 都会自动生成一些指标：

`up{job="<job-name>", instance="<instance-id>"}`: 1 if the instance is healthy, i.e. reachable, or 0 if the scrape failed.
`scrape_duration_seconds{job="<job-name>", instance="<instance-id>"}`: duration of the scrape.
`scrape_samples_post_metric_relabeling{job="<job-name>", instance="<instance-id>"}`: the number of samples remaining after metric relabeling was applied.
`scrape_samples_scraped{job="<job-name>", instance="<instance-id>"}`: the number of samples the target exposed.
`scrape_series_added{job="<job-name>", instance="<instance-id>"}`: the approximate number of new series in this scrape.

其中的 up 指标可以用来监控目标服务是否正常运行

## 报警

Prometheus 使用 AlertManager 做告警。
可以使用 predict_linear 等函数基于预测的做一些报警。

## 如何选择监控指标

首先问自己一个问题：当我的程序出了问题的时候，我需要哪些数据来 debug 呢？

Google SRE Book 中提出了四个黄金原则：延迟、流量、错误数、饱和度（需要排队无法提供服务的时间）。实际使用中对于资源可以使用 USE 指标，对于在线服务可以使用 RED 指标。

- USE 指标：Utilization、Saturation、Errors。如 Cadvisor 数据
- RED 指标：Rate、Errors、Duration。如 Apiserver 性能指标

被监控服务的类型

就监控而言，服务大概可以分为三类：在线服务，离线处理 和 跑批任务。

### 在线服务

此类系统的关键指标在于 QPS, 错误率和延迟。正在进行中的请求的数量也有用。

在线服务系统在客户端和服务端都应该做监控。如果两遍有不同的行为，那么这个对调试是很有意义的。如果一个服务有很多客户端，也不可能让服务监控每个客户端，所以客户端肯定需要依赖自己的数据。

当你按照 query 开始或结束统计数量一定要使用一致的标准。推荐使用结束来作为标准，因为比较容易实现，而且能统计错误和延迟。

### 离线系统

对每一个 stage, 记录进入的 item 的数量，有多少在处理中，上次你处理某个东西的时间，多少 item 被发送出去。如果你采用的是批处理，也应该记录进出的批的数量。

更好的方法是通过系统发送一个心跳包：一些带着时间戳的 dummy item 通过整个系统。每个 stage 都输出他看到的最近的时间戳，这样你就知道一个 item 需要多长时间才能经过整个系统了。

### 批操作

关键指标是上次成功操作的时间。
This should generally be at least enough time for 2 full runs of the batch job. For a job that runs every 4 hours and takes an hour, 10 hours would be a reasonable threshold. If you cannot withstand a single run failing, run the job more frequently, as a single failure should not require human intervention.

对于其他的子系统而言，可以选择如下指标

### 第三方库

如果一个库会访问进程外的资源，比如网络硬盘等等，至少要记录下所有的访问次数，错误和延迟。

Depending on how heavy the library is, track internal errors and latency within the library itself, and any general statistics you think may be useful.

### 日志

As a general rule, for every line of logging code you should also have a counter that is incremented. If you find an interesting log message, you want to be able to see how often it has been happening and for how long.
一个比较通用的规则，对于每一条日志，应该有一个计数器。如果你发现了一条有有意思的信息，你肯定想知道这件事

### 错误

Failures should be handled similarly to logging. Every time there is a failure, a counter should be incremented. Unlike logging, the error may also bubble up to a more general error counter depending on how your code is structured.

### 线程池

对于所有的线程池来说，核心指标是排队的请求的数量，正在使用的线程的数量，总线程的数量，已经处理的任务的数量和处理任务花费的时间，以及任务排队花费的时间。

### 缓存

缓存核心指标是总的查询数，命中数，总的延迟以及缓存所对应的线上系统的查询数量，错误率，延迟。

## 合理使用标签

比如说，不要创建 http_response_500_total 和 http_response_403_total 这种指标，创建一个 http_response_total 指标，然后使用不同的状态码作为标签。然后你就可以把整个 metric 作为一个规则和图表。

但是也不要滥用标签，前往不要用 IP 或者 email 这种信息来做标签，因为他们可能是无限的。这时候就不应该用监控系统了，可能需要一些 OLAP 的分析工具了。

总的来说，把 metrics 的秩 (cardinality) 控制在 10 以下。整个系统要控制超过 10 的 metric 的数量。绝大多数的查询不应该有标签。

为了避免秩过高的监控数据，可以添加如下的报警规则：

```
# 统计每个指标的时间序列数，超出 10000 的报警
count by (__name__)({__name__=~".+"}) > 10000
```

“坏指标”报警出来之后，就可以用 metric_relabel_config 的 drop 操作删掉有问题的 label（比如 userId、email 这些一看就是问题户）

如果不确定的话，首先别用标签，有了真实的 use case 再添加。

## 参考

1. [Should I run prometheus in a Docker?](https://grafana.com/blog/2019/05/07/ask-us-anything-should-i-run-prometheus-in-a-container/)
2. [Logs and metrics and graphs, oh my!](https://grafana.com/blog/2016/01/05/logs-and-metrics-and-graphs-oh-my/)
3. [developerWorks 上的入门文档](https://www.ibm.com/developerworks/cn/cloud/library/cl-lo-prometheus-getting-started-and-practice/index.html)
4. https://blog.frognew.com/2017/05/prometheus-intro.html
5. https://github.com/yolossn/Prometheus-Basics
6. https://mp.weixin.qq.com/s/sr8AxTMZTjUoe1XYrbRgyw
7. https://zhuanlan.zhihu.com/p/24811652
8. https://mp.weixin.qq.com/s?__biz=MzI4NTA1MDEwNg==&mid=2650782456&idx=1&sn=654615ca4199514687ae8ec65444dec9
9. https://medium.com/@valyala/promql-tutorial-for-beginners-9ab455142085
10. https://github.com/prometheus/client_python
11. http://www.xuyasong.com/?p=1717
12. https://www.section.io/blog/prometheus-querying/
13. https://github.com/danielfm/prometheus-for-developers#monitoring-uptime