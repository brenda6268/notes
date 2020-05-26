# redis 中如何给集合中的元素设置 TTL


ID: 572
Status: publish
Date: 2018-07-16 07:54:00
Modified: 2020-05-16 11:19:31


我们知道在 redis 中可以给每个 key 设置过期时间（TTL），但是没法为每个集合中的每一个元素设置过期时间，可以使用zset来实现这个效果。

直接上代码吧，Python 版的。

```
class RedisSet:

    def __init__(self, key):
        self.client = redis.StrictRedis()
        self.key = key

    def add(self, val, ttl=60):
        now = time.time()
        # 把过期时间作为 score 添加到 zset 中
        self.client.zadd(self.key, now + ttl, val)
        # 删除已经过期的元素
        self.client.zremrangebyscore(self, now, &#039;+inf&#039;)

    def getall(self):
        # 只读取还没有过期的元素
        return self.client.zrangebyscore(self.key, &#039;-inf&#039;, time.time())
```



参考：https://github.com/antirez/redis/issues/135