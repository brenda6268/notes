# Loki




Elastic Search 本身是一个适合读多写少的架构，而日志恰恰是一个写多读少的场景

Loki 并不索引所有的字段，只索引一些元信息。索引是非常昂贵的操作，还不如直接在内存里面 grep 呢。

## Collecting Logs

Loki uses `promtail` to collect logs from Kubernetes cluster. When using docker alone, we can use
the official plugin.

### Docker plugin

Install via:

```
docker plugin install grafana/loki-docker-driver:latest --alias loki --grant-all-permissions
```

You can set the docker's default logging driver to loki, in `/etc/docker/daemon.json`:

```
{
    "debug" : true,
    "log-driver": "loki",
    "log-opts": {
        "loki-url": "https://<user_id>:<password>@logs-us-west1.grafana.net/loki/api/v1/push",
        "loki-batch-size": "400"
    }
}
```

or specify each logging driver for each container.

```yml
version: "3.7"
services:
  logger:
    image: grafana/grafana
    logging:
      driver: loki
      options:
        loki-url: "https://<user_id>:<password>@logs-prod-us-central1.grafana.net/loki/api/v1/push"
```

### Promtail

To be added

## Storage backend

Loki supports many different kinds of storage backends, such as S3 or Casandrra. But for local
experiement, it's OK to use filesystem and local boltDB, which is similar with what Prometheus does.



## Exmaple Config

```yaml
auth_enabled: false

server:
  http_listen_port: 3100

ingester:
  lifecycler:
    address: 127.0.0.1
    ring:
      kvstore:
        store: inmemory
      replication_factor: 1
    final_sleep: 0s
  chunk_idle_period: 5m
  chunk_retain_period: 30s

schema_config:
  configs:
  - from: 2020-05-15
    store: boltdb
    object_store: filesystem
    schema: v11
    index:
      prefix: index_
      period: 168h

storage_config:
  boltdb:
    directory: /tmp/loki/index

  filesystem:
    directory: /tmp/loki/chunks

limits_config:
  enforce_metric_name: false
  reject_old_samples: true
  reject_old_samples_max_age: 168h
```

## References

1. https://grafana.com/docs/loki/latest/clients/docker-driver/
2. https://grafana.com/blog/2020/05/12/an-only-slightly-technical-introduction-to-loki-the-prometheus-inspired-open-source-logging-system/
