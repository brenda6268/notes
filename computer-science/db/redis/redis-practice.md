# redis 实战总结

<!--
ID: 7e6899e0-8b4c-423e-ac24-f0f2e5c294b5
Status: publish
Date: 2017-05-30T14:33:00
Modified: 2020-05-16T12:03:33
wp_id: 577
-->

## redis 是做什么的

一个数据结构存储器，数据驻留在内存里，可以在程序的两次之间保存数据

## 一些实现细节和比较好的地方

redis 的 string 是 binary-safe 的，可以存储任意的二进制数据（bytes），甚至可以把图片存储在 redis 中

## 经常用到的场合

1. 用作缓存

  1. 最基础的，最经典的应用场合，当查询数据库或者 ES 等存储代价比较高的时候，直接用查询的语句做 key，查询结果用作缓存

2. 用做队列。Redis 5.0 之后最好用 Redis Stream，不要用 list。

3. 用做集合，也就是存储一批数据的池子。用作有序集合

## 经常遇到的问题

过期之间只能指定到键级别，而不能指定到集合的键级别

## pipeline

imporve performance by combining multi command into one and reduce TCP times

```
>>> p = r.pipeline()        # 创建一个管道
>>> p.set("hello","redis")
>>> p.sadd("faz","baz")
>>> p.incr("num")
>>> p.execute()
[True, 1, 1]
>>> r.get("hello")
"redis"

or

>>> p.set("hello","redis").sadd("faz","baz").incr("num").execute()
```

默认的情况下，管道里执行的命令可以保证执行的原子性，执行 pipe = r.pipeline(transaction=False) 可以禁用这一特性。


# key 的命名

colon sign : is a convention when naming keys. Try to stick with a schema. For instance "object-type:id:field" can be a nice idea, like in "user:1000:password". I like to use dots for multi-words fields, like in "comment:1234:reply.to".

## 使用方法

Redis 是个好东西，提供了很多好用的功能，而且大部分实现的都还既可靠又高效（主从复制除外）。所以一开始我们犯了一个天真的用法错误：把所有不同类型的数据都放在了一组 Redis 集群中。

- 长生命周期的用户状态数据
- 临时缓存数据
- 后台统计用的流水数据


导致的问题就是当你想扩分片的时候，客户端 Hash 映射就变了，这是要迁移数据的。而所有数据放在一组 Redis 里，要把它们分开就麻烦了，每个 Redis 实例里面都是千万级的 key。


根据数据性质把 Redis 集群分类；我的经验是分三类：cache、buffer 和 db

- cache：临时缓存数据，加分片扩容容易，一般无持久化需要。
- buffer：用作缓冲区，平滑后端数据库的写操作，根据数据重要性可能有持久化需求。
- db：替代数据库的用法，有持久化需求。

规避在单实例上放热点 key。

同一系统下的不同子应用或服务使用的 Redis 也要隔离开
