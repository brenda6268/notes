# 《Prometheus 监控实战》笔记

<!--
ID: d2994159-e622-4b62-a766-c203ad7fea40
Status: publish
Date: 2020-09-03T07:19:11
Modified: 2020-09-03T07:19:11
wp_id: 2008
-->

## 第一章

与安全性一样，监控也应该是应用程序的核心功能。

如果应用程序在你没有注意到的情况下发生了故障，那么及时进行了监控，你也需要考虑下正在监控的内容是否合
理。

应该监控业务事务的内容或速率，而不是监控它运行的 Web 服务器的运行时间。

静态阈值几乎总是错误的，比如说只监控 CPU 超过 80% 的情况

监控的两种机制：

- 探针，当我们对要监控的资源没有控制权的时候
- 内省

显然，应该优先采用内省来监控。但是如果应用程序由第三方提供，并且你没有深入了解其内部操作的时候。从外
部查看应用程序以了解某些网络、安全性或可用性问题通常也很有帮助。

指标是一个组件属性的度量，对这个指标持续跟踪，观察的集合称为时间序列。

单一指标和聚合指标的组合可以提供最佳的健康视图：前者可深入到某个特定问题，而后者可以查看更高阶的状态。

使用平均值描述事件序列是非常危险的。有个笑话是：一位统计学家跳进平均深度只有 25 厘米的湖中，然后差点被
淹死，因为湖中有深达十米的大洞，虽然大部分水面深度只有 10cm

平局值的坏处就在于高峰和低谷可能被平均值所掩盖。百分位数才是识别异常值的理想选择。

### 监控方法论

Gregg 的 USE 指标：

- Utilization（使用率）. 资源忙于工作的平均时间，通常用随时间变化的百分比表示。
- Saturatioin（饱和度）. 资源排队工作的指标，无法处理额外的工作。通常用队列长度表示。
- Error（错误）. 错误事件的计数

Google 的四个黄金指标

- 延迟：服务请求所花费的时间，需要区分成功和失败请求。因为失败请求可能延迟非常低，但是结果是错的
- 流量：QPS 或者 TPS
- 错误：错误的速率。包括空响应和超时等隐式错误
- 饱和度：受限的资源，和上面类似

Weaveworks 的 RED 指标

- Rate（流量）
- Error（错误率）
- Duration（延迟）

实际上已经被包含在 Google 的四个指标中了

### 警报和通知

- 哪些问题需要通知
- 谁需要被告知
- 如何告知他们
- 多久告知他们一次
- 何时停止通知或升级到其他人

通知的信息应该包含以下几方面：

- 清晰准确，可操作。应该让人能够看懂并知道如何操作
- 为通知添加上下文，应该包含其他组件的相关信息
- 只发送有意义的通知，不要因为有了通知系统就一定要使用

### 可视化

可视化系统最终要的在于：突出重点而不仅是提升视觉效果。

## 第二章

大多数监控查询和警报都是从最近（通常是一天内）的数据产生的。

Prometheus 的高可用架构建议：

- 使用两个或多个相同配置的 Prometheus 服务器收集指标
- 所有生成的警报发送到一个 Alertmanger 的集群，由 altermanager 进行消重

## 第三章

强烈建议不要单独配置每个服务的指标抓取间隔，这样能够确保你的所有时间序列具有相同的粒度。

即使向量 (Instant Vector): 一组包含每个时间序列的单个样本的时间序列集合

## 第四章

cAdvisor 作为容器运行，可以用来监控 Docker

如何设定标签体系？

1. 使用拓扑标签，比如说 datacenter, job, instance 等
2. 使用模式标签，比如 `url_path`, `error_code` 等

在这里书中有一处错误，书中说可以使用 user 作为标签，实际上绝对不要用 user 作为标签，这会让时间序列的 rank 直接爆炸

TODO avg(rate()) 是啥意思

`predict_linear` 这个函数非常有用，可以用来回答："考虑到现在磁盘使用情况，以及他的增长速率，我们会在什么时候耗尽磁盘空间？

对于向量匹配运算，在多数情况下，一对一匹配就足够了。

## 第六章

最常见的错误是发送过多的警报。

应该针对症状而不是原因发出警报，又人类来判断造成问题的具体原因。

Alertmanger 的 route 块配置警报如何处理。receivers 配置警报的目的地。在规则中 expr 配置触发警报的规
则，而 for 指定在触发警报之前，测试表达式必须为 true 的时长，annotations 用于指定展示更多信息的标签。

警报一共有三个状态：

- Inactive
- Pending, 已经为 true, 但是 for 的时间还没满足
- Firing, 处于触发状态

如果不指定 for 子句，那么警报会直接由 Inactive 转为 Firing.

在 annotation 中还可以使用模板，其中有一些变量，和 humanize 等等函数。

routes 是树形的，在 Yaml 配置中直接嵌套。

```yaml
routes:
- match:
    severity: critical
  receiver: pager
  routes:
    - match:
        servrity: application
      receiver: support_team
```

Alert 的 silence 也很重要，可以通过

- web 控制台
- amtool
- unsee 等第三方控制台

## 第七章

Prometheus 认为实现集群所投入的成本要高于数据本身的价值，所以 Prometheus 不用集群，直接两个配置走起。

## 第八章

为应用程序添加监控，从以下入口和出口做起：

1. 测量请求和响应的数量和时间
2. 测量对外部服务和 API 的调用次数和时间，比如对于数据库等的调用
3. 测量作业调度，执行和其他周期性事件
4. 测量重要业务和功能性事件的数量和时间

应用程序的指标又分为两大类

1. 技术性指标，用于衡量应用程序的性能和状态，比如吞吐量、功能和状态等等
2. 业务性指标，用于衡量应用程序的价值，比如电商网站的销售量

业务指标通常是应用程序指标的更进一步，他们通常与技术指标同义。一个技术性指标可能是交易服务的延迟，
而业务性指标可能是每个交易的价值

另外，对于长期业务指标来说，不要用监控系统了，一般来说还是用基于事件的统计系统。

## 第九章

mtail 用于从日志中抽取并发送时间序列

## 第十章

探针监控也称为黑盒监控

## 第十一章

当目标端点没有可以抓取的端点，比如批处理作业，可以使用 push gateway

Push Gateway 开箱即用，没有什么配置。
