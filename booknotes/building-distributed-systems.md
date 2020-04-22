Date: 2019-09-16


总体来说是一本比较一般的书。豆瓣评分也只有 6.3

Sidecar 模式

主要用途是在不改动原有代码的前提下，封装老服务。比如提供 https 支持，提供本地的配置文件等。

另一种是为容器添加统一的功能，比如提供一个 topz 接口查看容器的进程情况，提供统一的代码更新后重启服务的功能。

其实有点像设计模式里面的装饰器模式。

Ambassador 模式

其实就是 LB

Adapter 模式

和设计模式中的适配器模式一样，适用于把不同应用的日志和监控信息做归一化，统一收集。

Replicated Load Balancer

最重要的是要有 readiness probe

```yaml
readinessProbe:
  httpGet:
    path: /ready
    port: 8080
  initialDelaySeconds: 5
  periodSeconds: 5
```