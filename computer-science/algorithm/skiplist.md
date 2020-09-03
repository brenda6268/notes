# 跳表（skiplist）

<!--
ID: eda4f3c5-1ec5-40c8-9c75-bfe102d4bad0
Status: publish
Date: 2018-04-04T06:36:00
Modified: 2020-05-16T11:34:18
wp_id: 493
-->

平衡二叉树可以实现 O(logn) 的查找复杂度。跳表可以实现相当于平衡二叉树的复杂度查询数据，而代码实现比较简单。在 Redis 中，zset 就用到了 skiplist。

跳表是用**并连的链表**来实现的查询结构

![](https://tva1.sinaimg.cn/large/006tNc79gy1fq102txkvvj30hs07haaf.jpg)

* 每个节点包含的指针的层数是由一个随机数决定的。
* 跳表的时间复杂度和平衡二叉树相同，但是在实现上要简单很多。
* 跳表是有序的，跳跃表的特点就是有序的，所以对于一些有序类型的数据，比如整数，日期这种，用跳跃表可以进行范围查找。
* 在构建跳跃表和查询跳跃的复杂度一致，所以也比较适合于在线的实时索引查询，可以来一个文档，一边查找就一边知道要如何进行插入操作了。
* 保存到磁盘和从磁盘载入也比较简单，因为本质上是几个链表，所以保存的时候可以按照数组的方式分别保存几个数组就可以了。

## 一些优化

空间优化，把底层的表放到硬盘里，影响增加删除节点的效率

![](https://tva1.sinaimg.cn/large/006tNc79gy1fq1043qhraj30hs06i3zn.jpg)

时间优化，用数组代替链表，可以使用二分查找而非遍历

![](https://tva1.sinaimg.cn/large/006tNc79gy1fq104leytgj30hs06j0tf.jpg)


对于类似时间这种数据，比如 24 小时对应 1440 分钟对应 86400 秒钟

甚至可以固定直接用索引随机访问

![](https://tva1.sinaimg.cn/large/006tNc79gy1fq106sqt91j30hs06j758.jpg)

## 实现

https://github.com/begeekmyfriend/skiplist/blob/master/skiplist.h
