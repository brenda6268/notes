# mysql 基础知识 (1) - 查询数据

wp_id: 174
Status: publish
Date: 2017-07-05 16:55:19
Modified: 2020-05-16 11:45:09

[最全总结](https://mp.weixin.qq.com/s/87BoE2-0mW_3qALyNSpiTw)

# 显示操作

```
show databases;
show create database DB;
show tables;
show columns from TABLE;
show create table TABLE;
show status;
shou grants;
```

# 连接数据库

`mysql -u root -p -h HOST -P 3306`, 其中的参数代表了用户，机器地址和密码等，注意其中的密码必须之后输入，而不能直接带上，这样是为了避免把密码记录在 bash 历史中。
另一个更好的工具是 Python 写的 mycli, 谁用谁知道~

使用 `use DATABASE`来更改指定的数据库。

# 查询数据库

下面的部分都使用这个表，方便讨论。
|id   |first_name|last_name|math_score|english_score|grade   |
|-----|----------|---------|----------|-------------|--------|
|1    |master    |yoda     |100       |100          |9       |
|2    |obiwan    |kenobi   |70        |100          |8       |
|3    |luke      |skywalker|100       |70           |7       |
|4    |leia      |skywalker|90        |90           |7       |

`select field from table`, 或者 `select * from table`. 好多时候往往犯懒直接写星号，但是检索无关的列会降低数据库的效率。
有一个比较有趣的关键字，叫做`DISTINCT`, 顾名思义，就是不同的意思，如果使用这个关键字作为前缀的话，MYSQL 会做一个去重的操作，有点类似于`uniq`命令。
```
select distinct vendor_id from products
```

如果需要限定查询的结果，使用 LIMIT 和 OFFSET 两个关键字。LIMIT 限定了返回的结果数量，OFFSET 指定了从那一条开始返回。
```
select name from students limit 5 offset 3;  -- 从所有学生中选出从第 3 个开始的 5 个学生
```

## 排序

一般来说，mysql 返回的结果是按照主键排序的，如果要让结果按照某个键排序，使用 `ORDER BY` 关键字来给他们排序

```
select name from students order by score
```

默认情况下，mysql 是按照升序排列的，也就是小的在前面，如果需要大的在前面，使用 `DESC` 关键字

```
select name from students order by score desc;
```

如果排序的字段相同怎么办呢，还可以按多个字段排序，这时候需要注意的是 desc 只对一个列生效。
```
select name from students order by score desc, name;
```

## 过滤结果

可以使用 `WHERE` 子句过滤结果，比如

```
select * from students where score > 100;
```

值得注意的是，如果要比较的是 null, 那么不能使用 = 来比较，需要使用 `IS`

```
select * from students where name is null;
```

还可以使用 `AND`, `OR`, `NOT` 来计算复合表达式。
使用 `IN` 来表达在某些值之间，就像在 Python 中一样。

```
select * from students where name in ("yoda", "obiwan", "luke");
```

使用 `LIKE` 来匹配结果，`%` 表示任意字符出现任意次数，`_` 表示任意一个字符出现一次。
```
select * from students where name like "%walker";
```

## 函数与计算字段

MySQL 中有一些常见的字符串处理函数，concat, trim 等等，这些函数在常见的编程语言中都有，在 MySQL 中作用大概也是相同的。还可以使用 `AS` 来个计算出的字段来起一个别名，这样方便输出。如果是数字的话，还可以做数学运算。
```
select concat(first_name, last_name) as name from students;

select math_score + english_score as score from students;

select * from students where year(enroll_time) = 2009;
```

## 聚合与分组数据

之前说的一些函数都是把一个值变成了另一个值，也就是使用或者不使用这些函数得到的都是相同行数的数据。而使用聚合或者分组函数之后，会改变得到的数据的大小。
聚集函数常用的一共有五个：`AVG(), COUNT(), MAX(), MIN(), SUM()`. 这几个函数的意思看名字也应该知道了。.. 直接上例子了。
```
select avg(math_score) as average_math_score from students;  -- 90, null 会被忽略
```

```
select count(*) from students; -- 3, null 会被忽略
```

### 分组函数

使用 group by 关键字可以让所有的行按照某个值，聚合成相应的行，比如在我们的数据中有 3 个年纪 (grade), 那么 group by(grade) 之后就会变成 3 行。
```
select grade, count(*) as num_students from students group by grade;
```

需要注意的是 SQL 的计算顺序是先计算 WHERE 子句，然后才回去使用 `GROUP BY` 聚合，那么如果想要过滤 GROUP BY 分组之后的数据呢，这时候可以使用 HAVING 子句。
```
select grade, count(*) as num_students from students group by grade having count(*) > 1;
```

## 子查询

子查询其实很简单，就是一个查询的结果是另一个查询的数据基础。和函数调用有一些相似。
第一种常见用法，把子查询的结果用在 IN 中。
```
select * from students where id in (select sudent_id from student_awards);
```

第二种使用子查询来作为结果列的数值。
```
select id, (select count(*) from student_awards where students.id = student_awards.student_id) from students;
```

## Join

Join 太复杂了，未完待续

## 数据类型

```
TINYBLOB, TINYTEXT       L + 1 bytes, where L < 2^8    (255 Bytes)
BLOB, TEXT               L + 2 bytes, where L < 2^16   (64 Kibibytes)
MEDIUMBLOB, MEDIUMTEXT   L + 3 bytes, where L < 2^24   (16 Mebibytes)
LONGBLOB, LONGTEXT       L + 4 bytes, where L < 2^32   (4 Gibibytes)
```

史上最全的 mysql 总结：https://mp.weixin.qq.com/s/87BoE2-0mW_3qALyNSpiTw