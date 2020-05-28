# 爬虫如何尽量模拟浏览器


wp_id: 465
Status: publish
Date: 2017-08-14 22:21:00
Modified: 2020-05-16 11:49:00


# http headers
 
发送http请求时，Host, Connection, Accept, User-Agent, Referer, Accept-Encoding, Accept-Language这七个头必须添加，因为正常的浏览器都会有这7个头。
 
其中：

1. Host一般各种库都已经填充了
2. Connection填Keep-Alive
3. Accept一般填text/html 或者application/json
4. User-Agent使用自己的爬虫或者伪造浏览器的UA
5. Referer一般填当前URL即可，考虑按照真是访问顺序添加referer，初始的referer可以使用google。
6. Accept-Encoding 从gzip和deflate中选，好多网站会强行返回gzip的结果
7. Aceept-Language根据情况选择，比如zh-CN, en-US

# cookies

cookie是需要更新的
 
# others
 
可能有一些人类不可见的陷阱链接，不要访问这些链接


# 爬取间隔自适应

就是已经限制了你这个IP的抓取，就不要傻傻重复试，怎么也得休息一会。网易云音乐操作起来比较简单，sleep一下就好了。其实sleep的间隔应该按情况累加，比如第一次sleep 10秒，发现还是被约束。那么久sleep 20秒... 这个间隔的设置已经自适应的最终效果是经验值。

ref

1. http://www.cnblogs.com/jexus/p/5471665.html