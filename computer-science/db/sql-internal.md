# 完全理解 SQL 的内在逻辑


ID: 182
Status: publish
Date: 2018-04-08 17:48:49
Modified: 2020-05-16 11:34:32


太多的程序员认为SQL像是洪水猛兽一样。它是少有的几种声明式的语言，和其他的命令似的面向对象的甚至函数使得语言大相径庭。
我每天都会写SQL而且在我的开源项目中大量的使用SQL，因此我非常地想要把SQL的美展现给你们这些还在挣扎着使用它的渣渣们。下面的教程适合

1. 使用过SQL但是从来没有完全理解他的人
2. 很了解SQL，但是从来没有思考过他的语法的人
3. 想要把SQL交给其他人的人

这个教程将会这关注SELECT语句，其他的DML将会在另一篇文章中介绍

# SQL是声明式的

首先要记住，声明式。唯一的一种范式就是你可以只是声明你想要的结果就得到了他。而不是告诉你的电脑怎样去把这个结果计算出来，不错吧？

    Select first_name, last_name FROM employees WHERE salary > 100000

很简单，你不需要关心employee的记录是存在哪里的，你只想要知道那些薪水还不错的人。

如此简单，那么问题在哪里呢？问题在于我们大部分时候是在按照命令式的编程思维在思考,比如“机器，干这个，然后干那个，但是在这之前检查一下，如果是这样或者那样就不行”。这其中包括了存储临时结果在变量里，循环，迭代，调用函数等等。

忘掉那些东西，思考如何声明东西，而不是告诉机器怎样去计算。

# SQL语法的顺序有些问题

常见的混乱的来源可能是SQL语法并不是按他们的执行顺序来排序的，词法（Lexical）排序是

1. SELECT [DISTINCT]
2. FROM
3. WHERE
4. GROUP BY
5. HAVING
6. UNION
7. ORDER BY
	
简洁起见，并没有列出所有语句，而从逻辑上来说，真正的逻辑执行顺序是这样的：

1. **FROM**。FROM后面的表标识了这条语句要查询的数据源。和一些子句如，（1-J1）笛卡尔积，（1-J2）ON过滤，（1-J3）添加外部列，所要应用的对象。FROM过程之后会生成一个虚拟表VT1。

    1. **(1-J1)笛卡尔积** 这个步骤会计算两个相关联表的笛卡尔积(CROSS JOIN) ，生成虚拟表VT1-J1。
    2. **(1-J2)ON过滤** 这个步骤基于虚拟表VT1-J1这一个虚拟表进行过滤，过滤出所有满足ON 谓词条件的列，生成虚拟表VT1-J2。
    3. **(1-J3)添加外部行**  如果使用了外连接，保留表中的不符合ON条件的列也会被加入到VT1-J2中，作为外部行，生成虚拟表VT1-J3。

2. **WHERE** 对VT1过程中生成的临时表进行过滤，满足where子句的列被插入到VT2表中。

3. **GROUP BY** 这个子句会把VT2中生成的表按照GROUP BY中的列进行分组。生成VT3表。

4. **HAVING** 这个子句对VT3表中的不同的组进行过滤，满足HAVING条件的子句被加入到VT4表中。

5. **SELECT** 这个子句对SELECT子句中的元素进行处理，生成VT5表。

    1. **(5-1)计算表达式** 计算SELECT 子句中的表达式，生成VT5-1
    2. **(5-2)DISTINCT** 寻找VT5-1中的重复列，并删掉，生成VT5-2
    5. **(5-3)TOP** 从ORDER BY子句定义的结果中，筛选出符合条件的列。生成VT5-3表

6. **ORDER BY** 从VT5-3中的表中，根据 ORDER BY 子句的条件对结果进行排序，生成VC6表。

当然强大的 SQL 执行引擎在实际执行过程用会有各种优化，不一定严格按照这个顺序来。但是在写和看 SQL 的时候可以按照这个逻辑思考。

## 例子

可以思考一下下面这个语句的执行过程

```
SELECT C.customerid, COUNT(O.orderid) AS numorders
FROM dbo.Customers AS C
  LEFT OUTER JOIN dbo.Orders AS O
    ON C.customerid = O.customerid
WHERE C.city = &#039;Madrid&#039;
GROUP BY C.customerid
HAVING COUNT(O.orderid) &lt; 3
ORDER BY numorders
```

# SQL是关于表的（而不是列）

因为词法排序和逻辑排序上的不同，很多的初学者认为列的值是SQL中的一等公民，实际上，不是。最重要的是表的引用。

比如说

```
FROM a,b
```

这个语句实际上是 `a cross join b`，也就是笛卡尔乘积。比如说，a 中有3列3行数据，b中有5列5行数据。上面的一句产生的结果是一个3+5=8列，3x5=15行的数据。

不过，尽量显式 join 的表，而不要使用逗号。

SQL 中衍生的表可以看做表的变量。

```
-- A derived table
FROM (SELECT * FROM author) a -- 后边这个变量是可选的
```

```
-- Get authors&#039; first and last names, and their age in days
SELECT first_name, last_name, age
FROM (
  SELECT first_name, last_name, current_date - date_of_birth age
  FROM author
)
-- If the age is greater than 10000 days
WHERE age &gt; 10000
```

在 MySQL 8.0 中还可以使用 with 语句

```
WITH a AS (
  SELECT first_name, last_name, current_date - date_of_birth age
  FROM author
)
SELECT *
FROM a
WHERE age &gt; 10000
```

SQL 中的 Select 语句在关系代数中被称作投影（projection）。一旦你生成了表的引用，然后过滤，转换，接着你就可以把它投影成另一种形式。在 select 语句中，你终于可以按列操作生成的表了。也就是说其他的语句都是按表，或者说按照行操作的，只有到了 select 语句中你才可以操作列。

执行完了 select 语句之后，你就可以执行其他的集合排序等等操作了。

- distinct 删除重复的行
- union 把两个查询组合起来，并且删除重复的行
- union all 把两个查询组合起来，并且不删除重复
- except 做差集并且删除重复的行
- intersect 求交集

ORDER BY 排序


Ref：

1. https://web.archive.org/web/20150424213133/http://tech.pro:80/tutorial/1555/10-easy-steps-to-a-complete-understanding-of-sql
2. http://www.cnblogs.com/myprogram/archive/2013/01/24/2874666.html