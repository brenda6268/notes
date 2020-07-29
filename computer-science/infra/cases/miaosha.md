# 秒杀

<!--
ID: 32b3ab22-0a23-4c38-80f8-38d998a55291
Status: draft
Date: 2020-07-29T19:22:30
Modified: 2020-07-29T19:22:30
wp_id: 1110
-->

如何应对高并发：扩容、静态化、限流、服务降级

如何解决超卖问题：

1. 预先分配数据到队列里，消费 token
2. 订单全部使用队列


## 参考资料

1. http://blog.sae.sina.com.cn/archives/3738