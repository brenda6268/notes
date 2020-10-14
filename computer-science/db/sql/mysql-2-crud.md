# mysql 基础知识 (2) - 增删改查

<!--
ID: 5d0050f5-1144-4b1a-ac1c-60754ec8ec5f
Status: publish
Date: 2017-11-12T17:01:18
Modified: 2020-05-16T11:52:35
wp_id: 175
-->

我们还是使用上篇文章定义的例子来说明问题

## 插入数据

使用 `INSERT` 语句。

```
insert into students(**field_names) values(**VALUES), values(**VALUES);
```

### 批量插入

如果一次要插入所有数据的话，可以直接省略前面的字段名。MySQL 可以一次插入多行数据或者一行数据，但是这并不是 SQL 标准规定的。使用批量插入可以大幅度提高性能。

在批量插入的语句中，如果有一行是错的，那么就会导致整个插入失败，可以使用 insert ignore 语句。

如果要在批量插入不同的表，可以一次执行多个语句，而不是只执行一个。

如果在有 unique 索引的表中，如果插入重复数据可能会引起错误，这时候有两个解决方法：

1. insert ignore, 忽略插入的新数据
2. insert on duplicate update, 遇到重复数据则更新。

insert ignore 的语法是：

```sql
INSERT IGNORE INTO table(column_list)
VALUES( value_list),
      ( value_list),
      ...
```

也就是说和普通的插入语句相比就是多了 ignore 关键字，除此之外，再无区别。如果数据中有重复的，有不重复的，那么不重复的会插入成功。

但是 insert ignore 的问题在于它会忽略所有的错误，比如说不能为 null 的值提供了 null.

insert on duplicate update 的语法是：

```sql
INSERT INTO table (column_list)
VALUES (value_list)
ON DUPLICATE KEY UPDATE
   c1 = v1, 
   c2 = v2,
   ...;
```

insert on duplicate update 的问题在于它会消耗掉一个 id, 虽然并没有实际插入，导致 id 不是连续的，而是有好多空洞。而且会执行实际的写操作。另外在语法上也非常傻屌，竟然需要把插入的值在后面在写一遍。

## 更新数据

使用 `UPDATE` 语句。

```
update students set math_score = 100 where first_name = "luke";
```

## 删除数据

使用 `DELETE` 语句。

```
delete from students where name = "luke";
```

## 参考

1. http://www.mysqltutorial.org/mysql-insert-ignore/
2. https://www.mysqltutorial.org/mysql-insert-or-update-on-duplicate-key-update/
3. https://stackoverflow.com/questions/548541/insert-ignore-vs-insert-on-duplicate-key-update
