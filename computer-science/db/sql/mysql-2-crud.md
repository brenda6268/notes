# mysql 基础知识 (2) - 增删改查

<!--
ID: 5d0050f5-1144-4b1a-ac1c-60754ec8ec5f
Status: publish
Date: 2017-11-12T17:01:18
Modified: 2020-05-16T11:52:35
wp_id: 175
-->

我们还是使用上篇文章定义的例子来说明问题

# 插入数据

使用 `INSERT` 语句。

```
insert into students(**field_names) values(**VALUES), values(**VALUES);
```

## 批量插入

如果一次要插入所有数据的话，可以直接省略前面的字段名。MySQL 可以一次插入多行数据或者一行数据，但是这并不是 SQL 标准规定的。使用批量插入可以大幅度提高性能。

在批量插入的语句中，如果有一行是错的，那么就会导致整个插入失败，可以使用 insert ignore 语句。

如果要在批量插入不同的表，可以一次执行多个语句，而不是只执行一个。

## insert or update

如果要实现 insert or update 的功能，可以使用 insert on duplicate update 语句。



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
