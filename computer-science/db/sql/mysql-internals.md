# MySQL 内部原理面试常考题

<!--
ID: 406dff26-1ced-497c-83f1-00692a0ab6c5
Status: publish
Date: 2020-07-29T23:37:30
Modified: 2020-07-29T23:37:30
wp_id: 1643
-->

* InnoDB 有行级别的锁，而 MyISAM 只能锁定到表级别。
* InnoDB 有更好的故障恢复机制。
* InnoDB 实现了事务、外键和关系限制，MyISAM 没有。

总的来说，引用完整性和事物才是数据库的本质，所以说：“MyISAM is a file system that understands SQL. There’s no comparison. If you want a database engine with MySQL, use InnoDB.”

## 聚簇索引

MyISAM 没有使用聚簇索引，InnoDB 使用了聚簇索引。

## 参考

1. https://dba.stackexchange.com/questions/1/what-are-the-main-differences-between-innodb-and-myisam

2. https://jeremystein.com/journal/innodb-versus-myisam-no-comparison/

## 四种隔离界别

1. 读未提交 Read Uncommitted（在本次事务中可以读到其他事务中没有提交的数据 - 脏数据）
2. 读已提交 Read Committed （只能读到其他事务提交过的数据。如果在当前事务中，其他事务有提交，则两次读取结果不同）
3. 可重复读 Repeatable Read（MySQL 默认，保证了事务中每次读取结果都相同，而不管其他事物是否已经提交。会出现幻读）
4. 序列化 Serializable（隔离级别中最严格的，开启一个 serializable 事务，那么其他事务对数据表的写操作都会被挂起）

1. 读未提交：别人修改数据的事务尚未提交，在我的事务中也能读到。
2. 读已提交：别人修改数据的事务已经提交，在我的事务中才能读到。
3. 可重复读：别人修改数据的事务已经提交，在我的事务中也读不到。
4. 串行：我的事务尚未提交，别人就别想改数据。

## 聚簇索引

InnoDB 使用聚簇索引，聚簇索引按照主键的顺序在磁盘上。MyISAM 不使用聚簇索引，行按照插入顺序在磁盘上。

聚簇索引的优势在于按照主键范围读取，而劣势在于主键中插入可能造成性能问题。

## 参考文献

1. https://learnku.com/articles/13849/understanding-four-isolation-levels-in-mysql#2000d4
2.
