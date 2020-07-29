# URL 归一化

<!--
ID: ac09226f-8472-4d4d-a78a-d3c8115915de
Status: draft
Date: 2018-07-07T00:00:00
Modified: 2020-07-08T12:14:46
wp_id: 1460
-->

# 顺序归一化

url 参数的排序等，参加 normalize_url 函数

# 处理特定站点

http://example.com/article/story?storyID=19039&ref=329932&sessionID=9043275
http://example.com/article/story?storyID=19039&ref=902932&sessionID=9023409
http://example.com/article/story?storyID=19039&ref=904354&sessionID=8230235

比如一个站点可能有如上url，但是他们都实际上都是一篇文章，这时候需要找出规律把 ref 和 sessionID这个参数识别出来。

展开短链接

方法有：

1. 根据 Canonical URL 标签
2. 离线挖掘相同内容的网页的不同参数，然后写入规则中

## URL 中的数组

我们知道 URL 后面的 query string 实际上是一个字典的形式。URL 的任何一个规范中都没有定义如何在 query 中传递数组，但是这个需求也是实际存在的，于是就诞生各种奇葩的形式，本文做一个总结。

# 常见的形式

http://www.baidu.com/search?q=url&tag=foo	这里解析出来应该是一个字典 {"q": "url", "foo": "bar"}。
http://www.baidu.com/search?q=url&tag=foo&tag=bar	重复键表示数组
http://www.baidu.com/search?q=url&tag[]=foo&tag[]=bar	键后增加[]并重复表示数组
http://www.baidu.com/search?q=url&tag[0]=foo&tag[1]=bar	使用数组形式表示
http://www.baidu.com/search?q=url&tag=foo,bar	使用逗号分隔

在不同的语言中，乃至于不同的 web 框架中对以上形式有不同的解析
