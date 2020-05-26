# 后端工具和算法集


ID: 591
Status: publish
Date: 2018-06-30 08:16:00
Modified: 2020-05-16 11:14:49


总结一下后端常用的工具和蕴含的算法

TODO: 应该把 GitHub 5000 star 以上的项目都看一下



- 前端
    - 框架
        - vue


- 数据库

    - mysql(btree)
    - postgresql
    - redis
    - rocksdb/leveldb
    - elasticsearch
    - memcached

- 消息队列

    - kafka
    - redis stream
    - rabbitmq
        - amqp 协议

- RPC 和序列化

    - protobuf/grpc
    - thrift
    - msgpack
    - envoy
        - service mesh 的思想

- 负载均衡

    - 四层和七层负载均衡的区别
    - nginx
    - LVS/IPVS
    - 一致性哈希

- 部署和容器化

    - docker
        - cgroups
    - kubernetes
        - borg 论文

- CI
    - jenkins

- web 框架

    - django(MVC 模式)
    - flask

- 日志收集

    分布式系统中需要日志可能分布在不同的机器上，要想查找一条错误日志，可能需要 ssh 到不同的机器上，非常浪费时间和精力。可以把日志收集到一个统一的存储中，方便检索查看

    - filebeat
    - sentry

- 监控

    时序数据库

        - OpenTSDB
        - influxdb
        - prometheus

    前端面板

        - grafana


- 高并发厂家服务

    - 计数服务
        - [计数系统架构实践一次搞定](http://zhuanlan.51cto.com/art/201706/542217.htm)
        - [微博计数器的设计](http://blog.cydu.net/weidesign/2012/09/09/weibo-counter-service-design-2/)
        - [instagram 使用 redis 计数](https://instagram-engineering.com/storing-hundreds-of-millions-of-simple-key-value-pairs-in-redis-1091ae80f74c)
    - 限流服务
        - token bucket

- 搜索引擎相关

    - simhash
    - tf-idf

- 统一登录

    - CAS，[了解CAS协议](https://blog.csdn.net/csdnxingyuntian/article/details/54970102)
    - kerbos

- 操作系统

    - 内存换页算法
        - OPT
        - FIFO
        - LRU
        - CLOCK

- 限流



- 锁

    - 分布式锁
    - 自旋锁
    - 乐观锁、悲观锁
