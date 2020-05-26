# 每个程序员都应该知道的延迟数字


ID: 166
Status: publish
Date: 2018-07-23 20:40:52
Modified: 2020-05-16 11:21:15


动作                        | 时间           | 换算
----------------------------|----------------| ---
L1 缓存访问                 | 0.5 ns         | 0.5ns
分支预测错误                | 5 ns           | 5ns
L2 缓存访问                 | 7 ns           | 7ns
互斥锁/解锁                 | 25 ns          | 25ns
内存访问                    | 100 ns         | 100ns
使用 Zippy压缩 1KiB         | 3,000 ns       | 3 µs
通过 1 Gbps 网络发送 2KiB   | 20,000 ns      | 20 µs
SSD 随机读取                | 150,000 ns     | 150 µs
内存中连续读取 1 MB         | 250,000 ns     | 250 µs
同一个数据中心的来回        | 500,000 ns     | 0.5 ms
从 SSD 上连续读取 1 MB*     | 1,000,000 ns   | 1 ms
机械磁盘寻道                | 10,000,000 ns  | 10 ms
机械磁盘连续读取 1 MB       | 20,000,000 ns  | 20 ms
发送数据包 加州->荷兰->加州 | 150,000,000 ns | 150 ms

* 假设 ~1GB/sec SSD

如果把这些时长都乘以 10 亿的话:

动作                        | 时长       | 相当于
----------------------------| -----------| ----
L1 缓存访问                 | 0.5 s      | 一次心跳 (0.5 s)
分支预测错误                | 5 s        | 打个哈欠
L2 缓存访问                 | 7 s        | 打个长哈欠
互斥锁/解锁                 | 25 s       | 冲一杯咖啡
内存访问                    | 100 s      | 刷牙
使用 Zippy压缩 1KiB         | 50 min     | 一集电视剧(包括广告)
通过 1 Gbps 网络发送 2KiB   | 5.5 hr     | 从午餐到下午工作结束
SSD 随机读取                | 1.7 days   | 一个普通的周末
内存中连续读取 1 MB         | 2.9 days   | 一个长周末
同一个数据中心的来回        | 5.8 days   | 一个普通假期
从 SSD 上连续读取 1 MB*     | 11.6 days  | 等快递等了两周
机械磁盘寻道                | 16.5 weeks | 大学里的一个学期
机械磁盘连续读取 1 MB       | 7.8 months | 几乎能造个人了
上面两个加起来              | 1 year     | 整整一年
发送数据包 加州->荷兰->加州 | 4.8 years  | 快能读个博士了



可视化网页：
https://people.eecs.berkeley.edu/~rcs/research/interactive_latency.html

# 这些数字的作用是什么？

了解这些时间的量级有助于比较不同的解决方案。通过这些数字，你可以看出来从远程服务器的内存中读一些数据时比直接从硬盘上读取快的。在一般的程序中，这也就意味着使用磁盘存储比使用数据库服务器要慢，因为数据库通常把所有东西都放在内存里了。而且这也说明了为什么在服务全球客户的时候 CDN 至关重要。从北美到欧洲的一个 ping 就要花上 100+ ms，所以从地理上来说，内容应该是分布式部署的。

The idea is more about knowing the scale of time it takes to help compare different solution. With those number you can see that it's faster to get data in memory from a distant server than to read the same data from disk. In common application that means using disk storage is less efficient that storing it in a database on an other server, since it usually keeps almost everything in memory. It also tells a lot about why CDN are needed if you are serving client worldwide. A ping from North America to Europe will always takes 100+ ms, so having geographically distributed content is a good idea.

对于互斥锁的开启锁定时间
mutex lock/unlock time is important for anyone writing code that depends on code that is accessing the same data structures at the same time. If you don't know that there is a considerable cost to writing such code, now you do; and this number can quantify it.

还需要注意顺序读写和批量读写带来的提速

# 常见问题

## 随着摩尔定律的发展，这些数字会不会不太准确了？

首先摩尔定律基本上经失效了。其次，这些数字的重点是他们之间的比例，而不是具体数字。

## 延迟, 带宽和吞吐之间的区别和联系?

![Tube](https://i.stack.imgur.com/IMknJ.jpg)

- 延迟表示通过管道需要花费的时间
- 带宽表示管道的宽度
- 每秒钟流过的水的数量就是吞吐

吞吐 = 延迟 x 带宽

然而不幸的是, 吞吐这个词经常被用作两个意思. 有时候吞吐的意思是指的系统总荷载, 有时候又指
的是每秒吞吐量, 也就是带宽(当然单位不同).


参考：

1. https://gist.github.com/hellerbarde/2843375 
2. https://softwareengineering.stackexchange.com/questions/312485/how-can-jeff-deans-latency-numbers-every-programmer-should-know-be-accurate-i
3. https://stackoverflow.com/questions/36949735/what-is-the-difference-between-latency-bandwidth-and-throughput