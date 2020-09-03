# mysql 基础知识 (5) - 聚合语句 (group by)

<!--
ID: d5b18ee7-ec5a-4620-952c-21341afac88a
Status: publish
Date: 2018-04-09T17:28:39
Modified: 2020-05-16T11:34:49
wp_id: 178
-->

`Group by` 用来按照某一列或者某几列的值聚合数据。`group by x` 按照 x 相同的值聚合，`group by x, y` 按照 x 和 y 都相同的值聚合。而查询的列要么是聚合的列，要么应该通过聚合函数来选取一列。而且所有的 null 会被聚合成一行

比如说下面的数据表中

![](https://daks2k3a4ib2z.cloudfront.net/589e47d231ee752554896f1f/58dc686fb5bd4cf41639ef71_Screen%20Shot%202017-03-29%20at%207.07.17%20PM.png)

```
-- How many countries are in each continent?
select
  continent
  , count(*)
from
  countries
group by
  continent
```

执行查询可以得到每个洲的国家的数量。

# 过滤

在 SQL 中，Where 子句是在 group 子句之前运行的，所以我们无法通过 where 来过滤 group 之后的结果，而应该使用 having 子句来过滤。

```
select
 continent
  , max(area)
from
  countries
group by
  1
having
  max(area) >= 1e7
```

# 隐式聚合

当你没有使用 `group by`，而使用了 max、min、count 等聚合函数的时候已经在聚合了

```
-- What is the largest and average country size in Europe?
select
  max(area) as largest_country
  , avg(area) as avg_country_area
from
  countries
where
  continent = "Europe"
```

# MySQL 的特殊处理

如果在查询中有没有聚合的列，那么 MySQL 就会随机选取一个列，比如下面就会随机选取一个州。

```
select
  country
  , state
  , count(*)
from
  countries
group by
  country
```

# ref

这篇文章主要参考这里：https://www.periscopedata.com/blog/everything-about-group-by
