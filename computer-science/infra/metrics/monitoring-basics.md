# 监控系统基本概念与选型


<!--
ID: 8813dc40-6e2c-499c-8a4e-19c334f37537
Status: publish
Date: 2018-09-17T23:16:00
Modified: 2020-05-16T11:24:01
wp_id: 741
-->


## 时序数据库

监控系统的基础是时序数据库

现代的监控系统一般都有如下几部分组成：

时序数据库 + 前端显示 + 报警系统 + 指标收集

一般需要实现的功能:

- 度量数据收集和可视化
- 收集尽可能多的性能和状态数据
- 图形化做有意义的展示
- 如果发现可疑问题,可以关联其他图表找到原因
- 错误检测
- 按需告警, 触发条件越宽松则告警应该越少
- 避免误报

从监控的层次划分的话,一般包含三层监控:

- 基础层: 主机的CPU,内存,网络及IO等
- 中间层: 应用运行的中间件层, Nginx, Tomcat, MySQL, Redis
- 应用层: 服务端及客户端性能数据,如API访问次数和响应时间等

现代的监控越来越关注应用层和其他层数据的整合能力, 具有快速找到系统瓶颈, 方便扩容或代码优化.

## 时序数据库的选择

监控数据往往都带有时间戳，其实就是一种典型时间序列数据，而这方面已经有很多专门的存储系统，如 opentsdb，influxdb，prometheus 等。相比 mysql 这样的传统数据库，这类系统在存储、查询上针对时间序列数据都做了特别的优化。

其中 opentsdb 基于 hadoop 生态系统，考虑到搭建的复杂度，暂时不考虑了。influxdb 和 prometheus 都是 Golang 编写的，直接一个二进制文件就可以运行。两者的区别有：

- prometheus 对于保存长时间的数据有一些问题，influxdb 似乎没有问题
- 另外 influxdb 可以直接写入，而 prometheus 是基于拉(pull)模式的，也就是说程序不能直接写入 prometheus，而是需要由 prometheus 去定期拉监控数据，太反人类了。
- influxdb 的查询类似 SQL，而 prometheus 的查询语法更加简洁，但是有学习成本，各有千秋吧

所以选用 influxdb了。

## 前端显示

唯一的标准自然是越漂亮越好，所以我们选择 grafana。

当然另一需要考虑的是编写查询界面不要过于复杂，这方面 grafana 只需要拖拽空间和勾勾选选就可以了，显然不成问题。

## 报警系统

grafan 自带了一些报警，但是只能根据阈值报警，显然不能满足我们的需求。我们这里选择了 bosun，是 Stack Overflow 开源的一款监控系统。通过简单的几个语句就可以编写复杂的报警条件。

## 指标收集

按照前面的分析，对于应用层，也就是我们自己的代码，可以随意地添加代码打点，这里不再赘述。对于系统的 metrics 的收集，可以使用 influxdb 公司钦定的 telegraf。telegraf 也有一些不同的插件，可以很好地支持 mysql、redis 等的监控数据收集。


## 参考

1. [Logs and Metrics and Graphs, Oh my!](https://grafana.com/blog/2016/01/05/logs-and-metrics-and-graphs-oh-my/)
2. [Prometheus 和 influxdb 对比](https://www.gaott.info/prometheus-vs-influxdb/)
3. [360基于Prometheus的在线服务监控实践](https://dbaplus.cn/news-72-1462-1.html)
4. [虎牙直播运维负责人张观石：基于时序数据库的直播业务监控实践](http://www.yunweipai.com/archives/20983.html)
5. [监控系统选型](http://xoyo.space/2017/04/new-monitor-architecture/)
6. [openTSDB/Bosun报警语法 介绍/学习笔记](https://blog.csdn.net/lslxdx/article/details/79454916)
