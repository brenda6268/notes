# BBR 拥塞控制算法

TCP 传统的拥塞控制算法存在问题。不能使用丢包作为网络瓶颈的判定因素。

如果瓶颈路由器的缓存特别大，那么这种以丢包作为探测依据的拥塞算法将会导致严重问题：TCP链路上长时间RTT变大，但吞吐量维持不变。

BBR 保留了慢启动

随着内存的不断降价，路由器设备的缓冲队列也会越来越大，CUBIC算法会造成更大的RTT时延！


TCP 拥塞控制算法是数据的发送端决定发送窗口，因此在哪边部署，就对哪边发出的数据有效。如果是下载，就应在服务器部署；如果是上传，就应在客户端部署。

## 参考

1. https://www.zhihu.com/question/53559433
2. https://git.kernel.org/pub/scm/linux/kernel/git/netdev/net-next.git/commit/?id=0f8782ea14974ce992618b55f0c041ef43ed0b78
3. https://lwn.net/Articles/701165/