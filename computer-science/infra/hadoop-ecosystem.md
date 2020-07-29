# 大数据相关工具（Hadoop 生态）

<!--
ID: 766641f4-8a07-402b-8b86-fbfc16800009
Status: draft
Date: 2018-06-19T02:44:00
Modified: 2020-05-16T11:09:04
wp_id: 554
-->

## Hive

Hive 构建在基于静态批处理的 Hadoop 之上，Hadoop 通常都有较高的延迟并且在作业提交和调度的时候需要大量的开销。因此，Hive 不适合在大规模数据集上实现低延迟快速的查询。Hive 可以使用 SQL 查询。


## Storm

A Storm application is designed as a "topology" in the shape of a directed acyclic graph (DAG) with spouts and bolts acting as the graph vertices. Edges on the graph are named streams and direct data from one node to another. Together, the topology acts as a data transformation pipeline. At a superficial level the general topology structure is similar to a MapReduce job, with the main difference being that data is processed in real time as opposed to in individual batches. Additionally, Storm topologies run indefinitely until killed, while a MapReduce job DAG must eventually end.


## HBase

## 参考

1. https://www.wolfcstech.com/2017/03/07/ApacheHBase%E5%85%A5%E9%97%A8/
2. http://www.aloo.me/2016/07/24/HBase%E5%85%A5%E9%97%A8%E7%B2%BE%E8%A6%81-%E7%99%BE%E9%97%BB%E4%B8%8D%E5%A6%82%E4%B8%80Run/
3. https://learnhbase.wordpress.com/2013/03/02/hbase-shell-commands/