# 分布式系统中的锁


wp_id: 552
Status: publish
Date: 2017-11-15 04:42:00
Modified: 2020-05-16 11:53:48


分布式系统需要使用分布锁。首先我们来回忆一下在单机情况下的锁。

当我们的程序在需要访问临界区的时候，我们可以加一个锁，如果是多线程程序，可以使用线程锁，如果是多进程程序，可以使用进程级别的锁。但是在分布式的环境中，如果在不同主机上部署的程序要访问同一个临界区是该怎么做呢？这时候我们需要分布式的锁。

当部署的服务或者脚本不在同一台机器上时,使用分布式的锁，可以使用zookeeper或者redis实现一个分布式锁。这里主要介绍一下基于redis的分布式锁。

redis 官方给出的单机redis分布式锁:

加锁

NX 命令指定了只有在不存在的时候才会创建，如果已经存在，则会返回失败。EX指定了过期时间，避免进程挂掉后死锁。值设定为了一个随机数，这样只有加锁的进程才知道锁的值是多少

```
SET resource-name my_random_string NX EX max-lock-time
```

解锁

因为解锁时会检查是否提供了随机数的值，所以只有创建锁的进程才能够解锁。

```
if redis.call("get",KEYS[1]) == ARGV[1] then
    return redis.call("del",KEYS[1])
else
    return 0
end
```

```
EVAL "script..." 1 resource-name my_random_string
```

参考:

[1] https://redis.io/topics/distlock