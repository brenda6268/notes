# mysql 基础知识(8) - 主从复制


ID: 181
Status: publish
Date: 2018-06-18 17:31:09
Modified: 2020-05-16 11:08:36


mysql 有三种主从复制方式


MySQL传统的高可用解决方案是通过binlog复制来搭建主从或一主多从的数据库集群。主从之间的复制模式支持异步模式(async replication)和半同步模式(semi-sync replication)。无论哪种模式下，都是主库master提供读写事务的能力，而slave只能提供只读事务的能力。在master上执行的更新事务通过binlog复制的方式传送给slave，slave收到后将事务先写入relay log，然后重放事务，即在slave上重新执行一次事务，从而达到主从机事务一致的效果。 

![](http://ws1.sinaimg.cn/large/006tNc79gy1fsfd8akzrlj30o108at9e.jpg)

其他文档：

http://mysql.taobao.org/monthly/2017/08/01/
http://blog.csdn.net/d6619309/article/details/53691352
http://blog.51cto.com/wangwei007/1893703
https://www.digitalocean.com/community/tutorials/how-to-configure-mysql-group-replication-on-ubuntu-16-04
http://blog.csdn.net/d6619309/article/details/53691352
http://mysql.taobao.org/monthly/2017/08/01/