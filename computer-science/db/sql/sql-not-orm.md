# ORM 教会了我什么？学学 SQL 吧！

<!--
ID: 67ecd734-1ad4-416e-a81c-118b8dcaec40
Status: draft
Date: 2020-10-21T21:47:29
Modified: 2020-10-21T21:47:29
wp_id: 2115
-->

今天喷不动了，翻译一篇国外的文章，告诉大家辛辛苦苦学的 ORM 都是没用的。

原文链接先贴上：

> https://wozniak.ca/blog/2014/08/03/1/

以下为译文：

我已经得出结论了，对我来说，ORM 的损害比收益还大。简而言之，在程序里，ORM 可以稍稍地增强 SQL, 但是完全替代不了 SQL.

一些背景：在过去的 30 个月里，我一直在写用到 PostgreSQL 和 SQLite 的代码。大多是的时候是用 SQLAlchemy（我还挺喜欢的）和 Hibernate（我不喜欢）. 我使用过已有的代码和数据模型，也设计过自己的。大多数的数据是事件驱动的存储方式（时间线）并且需要创建很多报告。

关于"对象-关系-不匹配"这个话题好多人写过很多了。只有经历过才能懂这个东西。

## 参考

1. https://wozniak.ca/blog/2014/08/03/1/
2. http://blogs.tedneward.com/post/the-vietnam-of-computer-science/
3. https://news.ycombinator.com/item?id=24845300