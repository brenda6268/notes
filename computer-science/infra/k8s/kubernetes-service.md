# kubernetes 初探——服务治理


wp_id: 547
Status: publish
Date: 2019-01-18 21:33:00
Modified: 2020-05-16 11:06:01


服务治理有两种方式：

- 一种是直接在服务中集成熔断降级等操作
- 一种是使用 sidecar 模式，有公共组件来处理

两种模式的区别如图：

![](https://ws1.sinaimg.cn/large/006tNc79ly1fzbu3a41c3j30gw09jabr.jpg)

# 参考资料

1. [Service Mesh 的本质、价值和应用探索 ](https://mp.weixin.qq.com/s/1zAxecTzeZToaWFymeY-sw)
2. [Istio, K8S 的微服务支持](https://www.kubernetes.org.cn/2350.html)
3. [微服务之熔断、降级、限流](https://blog.csdn.net/aa1215018028/article/details/81700796)
4. [微服务化之服务拆分与服务发现](https://mp.weixin.qq.com/s?__biz=MzI1NzYzODk4OQ==&mid=2247484925&idx=1&sn=5c15ba98fb03a2a0d9c823136f34e162)