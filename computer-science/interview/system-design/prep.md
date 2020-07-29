# 无标题

<!--
ID: e4bf9d25-ebec-4c60-b799-a48bb69f9d54
Status: draft
Date: 2020-03-21T00:00:00
Modified: 2020-07-29T23:37:30
wp_id: 1674
-->

But they do expect you to have some insight into aspects of such a design. The good news is that these questions usually focus on web backends, so you can make a lot of progress by reading about this area. An incomplete list of things to understand is:

1. HTTP (at the protocol level)
2. Databases (indexes, query planning)
3. CDNs
4. Caching (LRU cache, memcached, redis)
5. Load balancers
6. Distributed worker systems

阅读 High Scalability 博客

Once you've done this reading, answering system design questions is a matter of process. Start at the highest level, and move downward. At each level, ask your interviewer for specifications (should you suggest a simple starting point, or talk about what a mature system might look like?) and talk about several options (applying the ideas from your reading). Discussing tradeoffs in your design is key. Your interviewer cares less about whether your design is good in itself, and more about whether you are able to talk about the trade-offs (positives and negatives) of your decisions. Practice this.

http://blog.sae.sina.com.cn/archives/1290

- Message Queue
- Load Balancer
- Sharding
- Cache
- CDN
- Analytical
- R/W Seperate
- I/O or CPU