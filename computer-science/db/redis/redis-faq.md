# redis 常见问题

<!--
ID: f0b4b2d4-d3b5-490c-9f3a-1d7d064a171c
Status: publish
Date: 2018-07-20T04:03:00
Modified: 2020-05-16T11:20:38
wp_id: 576
-->

主要参考这篇文章：https://mp.weixin.qq.com/s/vS8IMgBIrfGpZYNUwtXrPQ

# 1. 集合操作避免范围过大

使用 sortedset、set、list、hash 等集合类的 O(N) 操作时要评估当前元素个数的规模以及将来的增长规模，对于短期就可能变为大集合的 key，要预估 O(N) 操作的元素数量，避免全量操作，可以使用 HSCAN、SSCAN、ZSCAN 进行渐进操作。集合元素数量过大在使用过程中会影响 redis 的实际性能，元素个数建议尽量不要超过 5000，元素数量过大可考虑拆分成多个 key 进行处理。

# 2. 合理使用过期时间

如果 key 没有设置超时时间，会导致一直占用内存。对于可以预估使用生命周期的 key 应当设置合理的过期时间或在最后一次操作时进行清理，避免垃圾数据残留 redis。redis 不是垃圾桶。

# 3. 利用批量操作命令

假设要给一个集合导入 5000 个元素：

方案 1：直接使用 redis 的 HSET 逐个设置

```
for _ in 0..5000
    HSET hash, k，v
```
结果：失败。redis ops 飙升，同时接口响应超时

方案 2：改用 redis 的 HMSET 一次将所有元素设置到 hash 中

```
map<k, v> = 50000 个元素
HMSET hash map
```

结果：失败。出现 redis 慢日志


方案 3：依然使用 HMSET，只是每次设置 500 个，循环 100 次

```
map_chunk<k, v> = 500 个元素
for i in 0..100
    HMSET hash map_chunk[i]
```

结果：成功

MSET/HMSET 等都支持一次输入多个 key，LPUSH/RPUSH/SADD 等命令都支持一次输入多个 value, 也要注意每次操作数量不要过多，建议控制在 500 个以内

# 4. 合理设置值的大小

String 类型尽量控制在 10KB 以内。虽然 redis 对单个 key 可以缓存的对象长度能够支持的很大，但是实际使用场合一定要合理拆分过大的缓存项，1k 基本是 redis 性能的一个拐点。当缓存项超过 10k、100k、1m 性能下降会特别明显。关于吞吐量与数据大小的关系可见下面官方网站提供的示意图。

在局域网环境下只要传输的包不超过一个 MTU（以太网下大约 1500 bytes），那么对于 10、100、1000 bytes 不同包大小的处理吞吐能力实际结果差不多。

# 5. 禁用一些命令

keys、monitor、flushall、flushdb 应当通过 redis 的 rename 机制禁掉命令，若没有禁用，开发人员要谨慎使用。其中 flushall、flushdb 会清空 redis 数据；keys 命令可能会引起慢日志；monitor 命令在开启的情况下会降低 redis 的吞吐量，根据压测结果大概会降低 redis50% 的吞吐量，越多客户端开启该命令，吞吐量下降会越多。


keys 和 monitor 在一些必要的情况下还是有助于排查线上问题的，建议可在重命名后在必要情况下由 redis 相关负责人员在 redis 备机使用，monitor 命令可借助 redis-faina 等脚本工具进行辅助分析，能更快排查线上 ops 飙升等问题。

# 6. 避免大量 key 同时过期

如果大量的 key 过期时间设置得过于集中，到过期的时间点，redis 可能会出现短暂的卡顿现象。一般需要在时间上加一个随机值，使得过期时间分散一些。

# 7. Redis 如何做持久化

bgsave 做镜像全量持久化，aof 做增量持久化。因为 bgsave 会耗费较长时间，不够实时，在停机的时候回导致大量丢失数据，所以需要 aof 来配合使用。在 redis 实例重启时，优先使用 aof 来回复内存状态，如果没有 aof 日志，就会使用 rdb 来恢复。

如果 aof 文件过大会导致恢复时间过长，不过 redis 会定期做 aof 重写，压缩 aof 文件日志大小。在 redis 4.0 之后还有了混合持久化的功能，将 bgsave 的全量和 aof 的增量做了融合处理，这样既保证了回复的效率有兼容了数据的安全性。

为了避免断电时后丢失数据，还可以设置 aof 日志的 sync 属性，极端情况下，可以每次写入都执行，不过会对性能有影响，一般每秒一次就可以。

# 8. 保存失败

redis 报错：Can't save in background: fork: Cannot allocate memory。

原因是 redis 在后台保存的时候会直接 fork 一下，然后保存。由于数据库过大，就会 fork 失败，但是实际上由于 copy-on-write 机制的存在，并不会产生问题。所以可以直接更改系统的配置，允许 fork。

把 `/etc/sysctl.conf` 文件修改如下：

```
vm.overcommit_memory=1
```

然后重新加载：

```
sysctl -p /etc/sysctl.conf
```

参考资料：

1. https://stackoverflow.com/questions/11752544/redis-bgsave-failed-because-fork-cannot-allocate-memory
