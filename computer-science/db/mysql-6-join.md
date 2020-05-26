# mysql 基础知识(6) - Join


ID: 179
Status: publish
Date: 2018-04-11 17:29:20
Modified: 2020-05-16 11:35:11


看到网上[有篇文章][1]用韦恩图来讲解了一下 SQL 的 join 操作，但是感觉举的例子似乎不太实际，遂自己写了一篇，图是从那篇文章里面盗的（逃

假设我们有下面两张表，上边的是表 user，下边的是 package，表示每个用户对应的包裹

id | name
---|-----
1  | Luke
2  | Leia
3  | Anakin
4  | Padem

id | content     | user_id
---|-------------|--------
1  | droid       | 3
2  | lightsaber  | 2
3  | blaster     | 1
4  | R2D2        | 5

创建这两个表的语句分别是：

```
create table user (id integer, name string);
create table package (id integer, content string, user_id integer);
insert into user (id, name) values (1, &#039;Luke&#039;);
insert into user (id, name) values (2, &#039;Leia&#039;);
insert into user (id, name) values (3, &#039;Anakin&#039;);
insert into user (id, name) values (4, &#039;Padme&#039;);
insert into package (id, content, user_id) values (1, &#039;droid&#039;, 3);
insert into package (id, content, user_id) values (2, &#039;lightsaber&#039;, 2);
insert into package (id, content, user_id) values (3, &#039;blaster&#039;, 1);
insert into package (id, content, user_id) values (4, &#039;R2D2&#039;, 5);
```

Veen diagram（韦恩图）是一种表示集合的图形语言。SQL 的 join 本质上也是从集合论里面来的，可以从集合论的角度来学习和记忆 Join 的语法。

# Inner Join

如果我们要选出每个有包裹的人，以及对应的包裹，可以使用 inner join。内连接（inner join）计算的是两个表的交集，也就是 `A ∩ B`。

```
select
user.id, user.name, package.id, package.content 
from
user inner join package
on user.id == package.user_id;
```

![](https://blog.codinghorror.com/content/images/uploads/2007/10/6a0120a85dcdae970b012877702708970c-pi.png)

结果一共有3列，每个表中的第四列都因为在对方表中没有而没有出现在结果里。

```
id          name        id          content
----------  ----------  ----------  ----------
1           Luke        3           blaster
2           Leia        2           lightsaber
3           Anakin      1           droid
```

# Full Outer Join

如果我们想要选出所有的任何包裹的对应关系，哪怕是对应得人或者包裹不存在的话，可以使用 full outer join。全连接计算的是两个表的并集，也就是 `A ∪ B`。

```
select
user.id, user.name, package.id, package.content
from
user full outer join package
on user.id == package.user_id;
```

![](https://blog.codinghorror.com/content/images/uploads/2007/10/6a0120a85dcdae970b012877702725970c-pi.png)

结果一共有6列，注意其中缺字段的地方被补上了 null。另外 SQLite 不支持 full outer join。感觉这个 Join 似乎用的不是太多，因为实际情况中，往往 package.user_id 是 user.id 的外键，所以不会出现 user_id 不存在的情况。

```
// 结果省略
```

# Left Outer Join

如果我们要取出每个人的包裹情况，没有包裹的也写上 null，那么这用情况下应该使用 left outer join。

```
select
user.id, user.name, package.id, package.content
from
user left outer join package
on user.id == package.user_id;
```

![](https://blog.codinghorror.com/content/images/uploads/2007/10/6a0120a85dcdae970b01287770273e970c-pi.png)

```
id          name        id          content
----------  ----------  ----------  ----------
1           Luke        3           blaster
2           Leia        2           lightsaber
3           Anakin      1           droid
4           Padme       NULL        NULL
```

# Cross Join

要获得A表和B表左右可能的交叉组合的话，可以使用 cross join，也就是笛卡尔乘积。

```
select
user.id, user.name, package.id, package.content
from
user cross join package;
```
结果如下
```
id          name        id          content
----------  ----------  ----------  ----------
1           Luke        1           droid
1           Luke        2           lightsaber
1           Luke        3           blaster
1           Luke        4           R2D2
2           Leia        1           droid
2           Leia        2           lightsaber
2           Leia        3           blaster
2           Leia        4           R2D2
3           Anakin      1           droid
3           Anakin      2           lightsaber
3           Anakin      3           blaster
3           Anakin      4           R2D2
4           Padme       1           droid
4           Padme       2           lightsaber
4           Padme       3           blaster
4           Padme       4           R2D2
```

[1]: https://blog.codinghorror.com/a-visual-explanation-of-sql-joins/