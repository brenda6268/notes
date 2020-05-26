# MySQL 中的 wait_timeout 是做什么的？


ID: 227
Status: publish
Date: 2018-07-23 14:29:52
Modified: 2020-05-16 11:21:05


Mysql 中默认的 wait_timeout 和 interactive_timeout 的值是八小时，也就是一个连接（交互式和非交互式的）只有在 8 小时没有活动之后才会被关闭掉。对于互联网公司来说，这个值实在太大了，一个库可能被很多脚本和服务访问，可能只是一个简短的查询就不需要数据库了，如果每个查询都占据了8小时的时间，那么 mysql 很快连接数就会满了，报出 too many connections 错误。

mysql 默认的连接数可以修改 max_connections 参数，但是一个服务器能支撑的连接数显然是由硬件决定的。

设置 wait_timeout 过短可能会造成一些问题，如果在 django 中两次查询的之间时间大于 wait_timeout，就会报 (2006, 'MySQL server has gone away')。django 官方给的建议是：

1. 当你的脚本不需要使用数据库的时候，主动关闭连接，比如在 django 中使用 `from django.db import connection; connection.close()`
2. 增大 wait_timeout 的值

不过django默认 CONN_MAX_AGE 是 0，也就是在查询数据库之后会立即关闭链接，理论上应该不会报这个错误。但是这样不能复用链接，会造成对数据压力很大。

CONN_MAX_AGE 应该小于数据库本身的最大连接时间wait_timeout，否则应用程序可能会获取到连接超时的数据库连接，这时会出现MySQL server has gone away的报错。

可以在 settings.py 中动态地获取并填充这个值，然后写到 CONN_MAX_AGE 中

理论上这样就不会再报错了，但是难免数据库重启或者什么时候会报错，总是使用 close_old_connections 还是很烦。

有一种思路是在检测到和数据库链接断开的时候，自动重连，但是这样会破坏 django.db.atomic，但是可以实现一种不同的backend。可以参考这两个：

1. https://github.com/django/django/pull/2740/commits/38f58aa4d751ad83f1dc76d5b945a1036239584f

2. https://github.com/django/django/pull/2454/commits/36b8bf870cab183b7ad63c0d8e7e8c02e314a053#diff-f8a587a973ef4c3a94d7550a5b85342c

还有一种解决思路是使用 connection pooling，我们可以使用 sqlalchemy 的 连接池作为django连接数据库的工具。参考这里：http://menendez.com/blog/mysql-connection-pooling-django-and-sqlalchemy/, 不过这种方法比较 hack。


## 参考

1. https://code.djangoproject.com/ticket/21597#no2
2. https://github.com/django/django/commit/2ee21d9f0d9eaed0494f3b9cd4b5bc9beffffae5
3. https://stackoverflow.com/questions/1125504/django-persistent-database-connection
4. [django 优化](https://blog.csdn.net/u011546806/article/details/45576669)
5. https://docs.djangoproject.com/en/2.1/ref/databases/#persistent-connections
6. [如何设置 max_age](https://stackoverflow.com/questions/19937257/what-is-a-good-value-for-conn-max-age-in-django)