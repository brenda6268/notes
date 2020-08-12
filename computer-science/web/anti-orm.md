# 为什么不要使用 ORM?

<!--
ID: 80fb75b6-e559-47fc-87b1-1f840ddec901
Status: draft
Date: 2020-08-02T21:57:02
Modified: 2020-08-02T21:57:02
wp_id: 1856
-->

连外键都不用的今天，再用 ORM 还有什么意义呢？别人云亦云，认真思考下这个问题。

- 兼容不同数据库？一般一个项目几乎是不可能更换数据库的。而开发和线上使用不同的数据库是一种非常危险的行为。
- 比使用存储过程好？我从来没用过存储过程。
- 减少了很多复制属性的重复工作？对于静态语言，感觉自动生成的 DAL 更好，对于动态语言，直接一个字典搞定，根本不存在这个问题。
- 自动转换类型？这个也不应该是 ORM 的一部分，而应该是 DB API 的一部分。

总之，ORM 就是计算机科学界的越南战争泥坑（美国视角）, SQL 和面向对象本来就是不 match 的，非要强行 map 起来，能舒服了才怪。

ORM 的缺点则很致命：无法控制生成的 SQL.

ORM 隐藏了 SQL 语句，使得我们没法使用 SQL 的方式思考，容易写出性能较低的代码。ORM 生成的 SQL 有的也很低效。

在我们编写 SQL 相关的程序的时候很容易犯的一个错误是 "N+1" 查询，也就是说本来应该用一个语句实现的查询，我们却使用了 N+1 个查询。

读取的数据过多。一般情况下，我们可能只需要读取一两个字段，但是 ORM 默认的确是 `select *`, 导致性能下降。

如果使用 ORM 的话，实际上你在学习一门新的 DSL, 而且这个 DSL 还不是很通用。这点其实是最最重要的问题了，sql 的语法是 universal 的，是到处可用的，作为一个程序员你必须也不可能绕过去。

ORM 库往往和数据库的链接池，也就是 IO 部分耦合在一起，导致在需要不同的链接管理方式的时候非常难以修改。

## 参考

1. https://stackoverflow.com/questions/494816/using-an-orm-or-plain-sql
2. https://medium.com/@mithunsasidharan/should-i-or-should-i-not-use-orm-4c3742a639ce
3. https://stackoverflow.com/questions/448684/why-should-you-use-an-orm
4. https://web.archive.org/web/20090528082618/http://www.cforcoding.com/2009/05/orm-or-sql.html
5. https://blog.codinghorror.com/object-relational-mapping-is-the-vietnam-of-computer-science/