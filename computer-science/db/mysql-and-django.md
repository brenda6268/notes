# MySQL 性能小技巧和在 Django 中的应用


ID: 184
Status: publish
Date: 2018-07-24 17:51:07
Modified: 2020-05-16 11:21:24


对于 delete update insert 等语句一定要使用 limit 子句限制影响的行数，避免一次更改特别多的行，造成数据库假死

```
while (1) {
    //每次只做1000条
    mysql_query(&quot;DELETE FROM logs WHERE log_date &lt;= &#039;2009-11-01&#039; LIMIT 1000&quot;);
    if (mysql_affected_rows() == 0) {
        // 没得可删了，退出！
        break;
    }
    // 每次都要休息一会儿
    usleep(50000);
}
```

# 2. 垂直分割

把不会用作索引的，或者是过长的字段可以考虑使用其他存储引擎，比如 rocksdb 等。

# 3. IPv4 地址可以存为 uint32

使用 uint32 存储 IP 地址不光可以节省空间，而且可以按区间查询。

# 4. 避免 select *

从数据库里读出越多的数据，那么查询就会变得越慢。并且，如果你的数据库服务器和应用服务器是两台独立的服务器的话，这还会增加网络传输的负载。

所以，你应该养成一个需要什么就取什么的好的习惯。

不要使用：

```
SELECT * FROM user WHERE user_id = 1
```

使用：

```
SELECT username FROM user WHERE user_id = 1
```

在 django 中，可以使用 `only`：

```
books = Book.objects.filter(author=&quot;Jim&quot;).only(&#039;book_name&#039;)
```

# 5. 当只要一行数据时使用 LIMIT 1

当你查询表的有些时候，你已经知道结果只会有一条结果，但因为你可能需要去fetch游标，或是你也许会去检查返回的记录数。

在这种情况下，加上 LIMIT 1 可以增加性能。这样一样，MySQL数据库引擎会在找到一条数据后停止搜索，而不是继续往后查少下一条符合记录的数据。

下面的示例，只是为了找一下是否有“中国”的用户，很明显，后面的会比前面的更有效率。（请注意，第一条中是Select *，第二条是Select 1）

```
SELECT * FROM user WHERE country = &#039;China&#039;
SELECT 1 FROM user WHERE country = &#039;China&#039; LIMIT 1
```

在 Django 中可以使用 `[:1]` 来添加 limit 1

# 6. EXPLAIN 你的 SELECT 查询

使用 EXPLAIN 关键字可以让你知道MySQL是如何处理你的SQL语句的。这可以帮你分析你的查询语句或是表结构的性能瓶颈。

# 7. 尽量让查询能 fit 进内存中

参考：

1. https://coolshell.cn/articles/1846.html