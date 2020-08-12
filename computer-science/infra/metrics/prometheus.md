# 使用 Prometheus 监控应用数据

<!--
ID: 0b574398-0507-417d-8015-8b2e1e00f046
Status: draft
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

## Prometheus 的数据类型

Prometheus 常用的有四种类型：计数器 (counter), 刻度 (gauge), 直方图 (histogram), 摘要 (summary).

计数器只增不减，用来记录一件事情发生了多少次，可以使用 `rate(some_counter[interval])` 来计算一件事情的速率。Counter 类型主要是为了 Rate 而存在的，即计算速率，单纯的 Counter 计数意义不大，因为 Counter 一旦重置，总计数就没有意义了。Rate 会自动处理 Counter 重置的问题，Counter 的任何减少也会被视为 Counter 重置。

建议将 Rate 计算的范围向量的时间至少设为抓取间隔的四倍。这将确保即使抓取速度缓慢，且发生了一次抓取故障，您也始终可以使用两个样本。此类问题在实践中经常出现，因此保持这种弹性非常重要。例如，对于 1 分钟的抓取间隔，您可以使用 4 分钟的 Rate 计算，但是通常将其四舍五入为 5 分钟。

Gauges 可以被设定，可以增高，可以减小。用来记录状态，比如正在进行的请求的数量，空闲内存数，温度等。对于 gauge 值，不要使用 `rate`. 可以使用 `max_over_time` 等来处理 gauge 数据。

Histograms and summaries both sample observations, typically request durations or response sizes. They track the number of observations and the sum of the observed values, allowing you to calculate the average of the observed values. Note that the number of observations (showing up in Prometheus as a time series with a _count suffix) is inherently a counter (as described above, it only goes up). The sum of observations (showing up as a time series with a _sum suffix) behaves like a counter, too, as long as there are no negative observations. Obviously, request durations or response sizes are never negative.

Histogram 类型数据最常用的函数是 histogram_quantile 了，可以用来计算 P95,P99 等数据。

Histogram 和 Summary 都是采样观测量，典型的比如请求的时间和相应的体积等等。他们记录观测的数量和观测的所有值，允许你计算平均值等。

To calculate the average request duration during the last 5 minutes from a histogram or summary called http_request_duration_seconds, use the following expression:

```prometheus
rate(http_request_duration_seconds_sum[5m]) / rate(http_request_duration_seconds_count[5m])
```

Histogram 在服务端计算，Summary 在客户端计算并且不能被重新计算。如果可能的话，最好使用 Histogram, 不要使用 summary. 

- Have no more than 5 graphs on a console. 一个控制台不要有超过 5 个图。
- Have no more than 5 plots (lines) on each graph. You can get away with more if it is a stacked/area graph.
- 每个图上不要有超过五条线。当然堆栈图和饼形图除外。
- When using the provided console template examples, avoid more than 20-30 entries in the right-hand-side table.
- 当使用提供的模板时，

## 基本使用

### 输出指标到 Prometheus

这里以 Python 为例.

```
pip install prometheus_client
```

```
from prometheus_client import Counter

c = Counter("http_request_failures_total", "Descriptions of the counter")
c.inc()
```


### 使用 PromQL 查询指标

使用 `{}` 来过滤指标. 除了 `=` 之外, 还有 `!=` 和 `=~`(正则) 和 `!~`(不匹配)

```
<metric name>{<label name>=<label value>, ...}
```

比如：

```
api_http_requests_total{method="POST", handler="/messages"}
```

如果要查询历史数据可以使用 `offset xx` 阿里查询. 比如下面这条表示比过去一个小时的 gc fraction 还要大 1.5 倍的数据.

```
go_memstats_gc_cpu_fraction > 1.5 * (go_memstats_gc_cpu_fraction offset 1h)
```

使用 rate(counter[5m]) 来查询速率, 这里的采样周期 `5m` 如果设置的大一些, 图像就会更平滑, 如果小一些就会更精确.

使用 `by` 关键字可以聚合字段:

```
# sum+rate 其实是求和的意思(求导再积分), 然后按照 instance 聚合
sum(rate(node_network_receive_bytes_total[5m])) by (instance)
```


### 使用 Dashboard 展示指标

## 选择监控指标

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

对于其他的子系统而言, 可以选择如下指标

### 库

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

比如说，不要创建 http_response_500_total 和 http_response_403_total 这种指标，创建一个 http_response_total 指标，然后使用不同的状态码作为标签。然后你就可以把整个 metric 作为一个规则和图标。

总的来说，把 metrics 的秩 (cardinality) 控制在 10 以下。整个系统要控制超过 10 的 metric 的数量。绝大多数的查询不应该有标签。

为了避免秩过高的监控数据，可以添加如下的报警规则：

```
# 统计每个指标的时间序列数，超出 10000 的报警
count by (__name__)({__name__=~".+"}) > 10000
```

“坏指标”报警出来之后，就可以用 metric_relabel_config 的 drop 操作删掉有问题的 label（比如 userId、email 这些一看就是问题户）

如果不确定的话，首先别用标签，有了真实的 use case 再添加。

## 可视化界面

Prometheus 自带了在 /graph 下有一个 expression browser, 可以绘制一些简单的图形, 除此之外还是建议使用 grafana.

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

Prometheus 使用 AlertManager 做告警.
可以使用 predict_linear 等函数基于预测的做一些报警.

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