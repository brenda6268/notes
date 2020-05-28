# RocksDB 基础概念教程


wp_id: 573
Status: publish
Date: 2017-11-09 09:12:00
Modified: 2020-05-16 11:51:44


RocksDB起源于LevelDB, 并且从HBase中吸取了不少代码[1]. RocksDB 设计的初衷是能够利用好SSD和内存的高性能, 而且可以通过配置来承载高强度的读或者高强度的写.

RocksDB 是一个嵌入式的key-value数据库, 并且所有的键都是有序的. RocksDB 支持的常用操作有 `Get(Key)`, `Put(Key)`, `Delete(Key)`, `Scan(Key)`.

RocksDB 中三个最基础的结构分别是 memtable, sstfile 和 logfile. memtable 是一个内存数据结构, 新的写入首先写入到memtable, 然后有可能写入到 logfile 中. logfile 是一个在硬盘上顺序写入的文件. 当 memtable 存满了之后, 它会被 flush 到 sstfile, 然后相应的 logfile 就可以安全的删除了. sstfile 中的数据为了方便查找key排序.

## RocksDB 的功能

`Get` 可以从数据库中读出一个kv对, `MultiGet`可以从数据库中读出多个kv对. 数据库中的所有数据在逻辑上都是有序的, 一个应用可以指定一个key的比较方法, 从而让所有的 key 按这种方法有序. 可以通过使用 `Iterator` API 可以对数据库做一个 `RangeScan`

使用 `Put` 方法可以更新一个数据, 使用`Write` 可以原子性的更新多个数据. 这两个操作都会直接覆盖老数据.

RocksDB 使用 checksum 来校验数据的损坏. 一般来说校验是按照 block 来进行的. 一个 block 如果被写入到硬盘之后就不会再变化了.

整个数据库写入的吞吐取决于compaction的速率, 据观测, 在SSD上多线程compaction的速率是单线程的10倍. 整个数据库被存储为一系列的sstfile. 当一个memtable满了之后, 他会被写入到一个Level0 的 sstable上. 在写入到L0的过程中, RocksDB会把memtable中的重复的已删除的键全部都清理掉. 一些文件会被周期性的读入合并到一起, 这个行为叫做compaction.

RocksDB支持两种形式的comapaction. 其中一种叫做Universal Style Compaction. 在这种模式下, 所有的文件都存在L0模式, 并且按照时间排序. 这时候一个compaction会把时间上相连的两组文件合并并组成一个新的文件, 再放回到L0. 所有的文件都有可能有重复的键.

另一种模式 Level Style Compaction. 数据按层存储, 也就是L0...Ln. 最新的数据存储在L0, 最老的数据存储在Lmax层. 在L0的文件可能会有交叉的key, 但是在其它层就不会有. compaction发生的时候, 去除Ln的一个文件, 和在Ln+1层所有有相同key的文件, 把他们合并之后作为一个新的文件存储在Ln+1层. 通常来说USC比LSC 产生比较小的写入放大, 但是比较大的空间放大.

MANIFEST 文件存储了数据库的状态.

程序可以通过定义compaction filter来实现, key的TTL, 清洗数据等功能.

RocksDB支持压缩. 典型的配置是 L0-L2 没有压缩，中间层使用 snappy 算法压缩，Lmax 使用 zlib 压缩。

RocksDB 会把所有的transaction都存贮在logfile中, 重启的时候 RocksDB 会再去处理这些logfile. 这些logfile可以和sstfile 存放在不同的目录, 比如为了性能把sstfile存放在性能更高的存储上, 而把logfile存放在性能低一点的存储上.







[1] https://github.com/facebook/rocksdb/wiki/RocksDB-Basics