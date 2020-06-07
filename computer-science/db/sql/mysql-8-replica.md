# mysql 基础知识 (8) - 主从复制

wp_id: 181
Status: publish
Date: 2018-06-18 17:31:09
Modified: 2020-05-16 11:08:36

mysql 有三种主从复制方式

MySQL 传统的高可用解决方案是通过 binlog 复制来搭建主从或一主多从的数据库集群。主从之间的复制模式支持异步模式 (async replication) 和半同步模式 (semi-sync replication)。无论哪种模式下，都是主库 master 提供读写事务的能力，而 slave 只能提供只读事务的能力。在 master 上执行的更新事务通过 binlog 复制的方式传送给 slave，slave 收到后将事务先写入 redo log，然后重放事务，即在 slave 上重新执行一次事务，从而达到主从机事务一致的效果。 

![](http://tva1.sinaimg.cn/large/006tNc79gy1fsfd8akzrlj30o108at9e.jpg)

## MySQL 的三种日志

- binlog
- redo log
- undo log

## 参考

http://mysql.taobao.org/monthly/2017/08/01/
http://blog.csdn.net/d6619309/article/details/53691352
http://blog.51cto.com/wangwei007/1893703
https://www.digitalocean.com/community/tutorials/how-to-configure-mysql-group-replication-on-ubuntu-16-04
http://blog.csdn.net/d6619309/article/details/53691352
http://mysql.taobao.org/monthly/2017/08/01/