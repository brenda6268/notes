# LSM 和 sstable


wp_id: 496
Status: publish
Date: 2018-07-31 10:00:00
Modified: 2020-05-16 11:22:15


# 核心要点

lsm 是 bigtable、leveldb、rocksdb 等数据库采用的算法。

硬盘，尤其是机械硬盘，顺序写入性能远大于随机写入性能，所以 lsm 把大量的随机写入抓换成了顺序写入，从而极大地又花了写入能力。同时查找效率收到了损伤。

适用于顺序写入多，随机读取少的场景。

之所以要使用 Immutable Memtable，就是为了避免将 MemTable 中的内容序列化到磁盘中时会阻塞写操作。

## 操作

1. 插入

  写入 WAL，然后操作 memtable。WAL 是顺序读写，而memtable 是跳表，操作都很迅速

2. 更新

  和插入其实是一样的操作

3. 删除

  插入一条特殊的删除日志，在 memtable 中标记删除

4. compaction（压缩）

  当 memtable 达到设定的阈值的时候，会写入到 immutable memtable，然后写入到硬盘上的 sstable。当 sstable 的数量达到某个阈值的时候，就合并到下一级的 memtable。需要注意的是只有第一级的memtable可能有重复的键值，其他层都不会有重复的，所以可以多线程 compact。

5. 读取

  最原始的算法：首先从memtable读，然后从sstable中往高层读取。

  可以采取的优化方法：

  1. 把 sstable 的一些原始信息放到 manifest 中，放在内存中，快速查找
  2. 使用 bloom filter 先过滤一遍，看 key 是否在 LSM 中，然后再查找。

一图胜千言：

![](https://ws3.sinaimg.cn/large/801b780aly1ftt76pvzotj21kw13eh8u.jpg)


参考：

1. http://blog.fatedier.com/2016/06/15/learn-lsm-tree/