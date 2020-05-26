# 如何在 URL 中表示数组


ID: 835
Status: publish
Date: 2019-12-05 15:55:19
Modified: 2020-05-16 10:46:42


我们知道 URL 后面的 query string 实际上是一个字典的形式。URL 的任何一个规范中都没有定义如何在 query 中传递数组，但是这个需求也是实际存在的，于是就诞生各种奇葩的形式，本文做一个总结。

# 常见的形式

http://www.baidu.com/search?q=url&tag=foo

这是一个正常的 URL，这里解析出来应该是一个字典 {"q": "url", "foo": "bar"}。但是 Python 会强行解析成数组 {"q": ["url"], "tag": ["foo"]}。

使用 URL 表示数组有以下几种常见形式：

http://www.baidu.com/search?q=url&tag=foo&tag=bar

重复键表示数组，Python/Node 中可以正确解析成数组，Java 只读取第一个值，PHP 只读取最后一个值。

http://www.baidu.com/search?q=url&tag[]=foo&tag[]=bar

键后增加[]并重复表示数组。PHP/Node 可以解析为 tag=[foo, bar]。Python 会解析成

PHP 的 http_build_query 会生成这种格式。

```python
In [6]: from urllib.parse import parse_qs

In [7]: parse_qs(&quot;tag=foo&amp;tag=bar&quot;)
Out[7]: {&#039;tag&#039;: [&#039;foo&#039;, &#039;bar&#039;]}

In [8]: parse_qs(&quot;tag[]=foo&amp;tag[]=bar&quot;)
Out[8]: {&#039;tag[]&#039;: [&#039;foo&#039;, &#039;bar&#039;]}

In [9]: parse_qs(&quot;tag=foo&quot;)
Out[9]: {&#039;tag&#039;: [&#039;foo&#039;]}
```

http://www.baidu.com/search?q=url&tag[0]=foo&tag[1]=bar

使用数组形式表示。貌似没有原因能够处理，但是用的还挺多的。

http://www.baidu.com/search?q=url&tag=foo,bar

使用逗号分隔。貌似没有语言默认会处理这种，需要自己手工处理。但是我最喜欢这种。

# 一个更奇葩的例子

https://www.doi.gov/careers/explore-careers?f[0]=bureaus:20&f[1]=competencies:1638&f[2]=competencies:1642&f[3]=competencies:1648&f[4]=competencies:1656&f[5]=competencies:1661&f[6]=gs_levels:17&f[7]=gs_levels:158


总之，在不同的语言中，乃至于不同的 web 框架中对以上形式有不同的解析，非常混乱。

# 参考资料

1. https://stackoverflow.com/questions/6243051/how-to-pass-an-array-within-a-query-string
2. https://stackoverflow.com/questions/11889997/how-to-send-an-array-in-url-request/11890080
3. https://stackoverflow.com/questions/1763508/passing-arrays-as-url-parameter
4. https://stackoverflow.com/questions/1746507/authoritative-position-of-duplicate-http-get-query-keys