Date: 2019-09-26


Prometheus 是使用 Go 语言开发的一个监控工具和时序数据库，它的实现参考了 Borgmon。

监控系统大体来说分两种模式，push 和 pull。push 模式就是应用程序主动把监控数据推送到监控服务，pull 模式就是监控服务来主动拉取应用的数据。

对于自己编写的应用，可以使用 prometheus 的 sdk 来自己提供 metrics，对于开源的软件，可以使用对应的 exporter


## Instrumention

For monitoring purposes, services can generally be broken down into three types: online-serving, offline-processing, and batch jobs.

### Online-serving

The key metrics in such a system are the number of performed queries, errors, and latency. The number of in-progress requests can also be useful.

Online-serving systems should be monitored on both the client and server side. If the two sides see different behaviors, that is very useful information for debugging. If a service has many clients, it is also not practical for the service to track them individually, so they have to rely on their own stats.

Be consistent in whether you count queries when they start or when they end. When they end is suggested, as it will line up with the error and latency stats, and tends to be easier to code.

### offline systems

For each stage, track the items coming in, how many are in progress, the last time you processed something, and how many items were sent out. If batching, you should also track batches going in and out.

A better approach is to send a heartbeat through the system: some dummy item that gets passed all the way through and includes the timestamp when it was inserted. Each stage can export the most recent heartbeat timestamp it has seen, letting you know how long items are taking to propagate through the system.

### batch jobs

The key metric of a batch job is the last time it succeeded.

Libraries

If it is a library used to access some resource outside of the process (for example, network, disk, or IPC), track the overall query count, errors (if errors are possible) and latency at a minimum.

Depending on how heavy the library is, track internal errors and latency within the library itself, and any general statistics you think may be useful.

logging

As a general rule, for every line of logging code you should also have a counter that is incremented. If you find an interesting log message, you want to be able to see how often it has been happening and for how long.

Errors

Failures should be handled similarly to logging. Every time there is a failure, a counter should be incremented. Unlike logging, the error may also bubble up to a more general error counter depending on how your code is structured.

Threadpools

For any sort of threadpool, the key metrics are the number of queued requests, the number of threads in use, the total number of threads, the number of tasks processed, and how long they took. It is also useful to track how long things were waiting in the queue.

Caches

The key metrics for a cache are total queries, hits, overall latency and then the query count, errors and latency of whatever online-serving system the cache is in front of
For example, rather than http_responses_500_total and http_responses_403_total, create a single metric called http_responses_total with a code label for the HTTP response code. You can then process the entire metric as one in rules and graphs.

Do not over use labels

As a general guideline, try to keep the cardinality of your metrics below 10, and for metrics that exceed that, aim to limit them to a handful across your whole system. The vast majority of your metrics should have no labels.

If you are unsure, start with no labels and add more labels over time as concrete use cases arise.


## Types

Gauges can be set, go up, and go down. They are useful for snapshots of state, such as in-progress requests, free/total memory, or temperature. You should never take a rate() of a gauge.

Histograms and summaries both sample observations, typically request durations or response sizes. They track the number of observations and the sum of the observed values, allowing you to calculate the average of the observed values. Note that the number of observations (showing up in Prometheus as a time series with a _count suffix) is inherently a counter (as described above, it only goes up). The sum of observations (showing up as a time series with a _sum suffix) behaves like a counter, too, as long as there are no negative observations. Obviously, request durations or response sizes are never negative.


To calculate the average request duration during the last 5 minutes from a histogram or summary called http_request_duration_seconds, use the following expression:
  rate(http_request_duration_seconds_sum[5m])
/
  rate(http_request_duration_seconds_count[5m])
Histogram is calculated on the server, summary is calculated on the client and can not be recalculated.
We have found the following guidelines very effective:

- Have no more than 5 graphs on a console.
- Have no more than 5 plots (lines) on each graph. You can get away with more if it is a stacked/area graph.
- When using the provided console template examples, avoid more than 20-30 entries in the right-hand-side table.

This should generally be at least enough time for 2 full runs of the batch job. For a job that runs every 4 hours and takes an hour, 10 hours would be a reasonable threshold. If you cannot withstand a single run failing, run the job more frequently, as a single failure should not require human intervention.

## 参考

1. should I run prometheus in a Docker? https://grafana.com/blog/2019/05/07/ask-us-anything-should-i-run-prometheus-in-a-container/
2. Logs and metrics and graphs, oh my! https://grafana.com/blog/2016/01/05/logs-and-metrics-and-graphs-oh-my/
3. developerWorks 上的入门文档。https://www.ibm.com/developerworks/cn/cloud/library/cl-lo-prometheus-getting-started-and-practice/index.html