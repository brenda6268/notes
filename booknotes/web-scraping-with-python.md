# 读  Web Scraping with Python


ID: 352
Status: publish
Date: 2017-05-29 14:31:00
Modified: 2020-05-16 12:09:02


#Chapter I Introduction

## 为什么要写爬虫？

1. 每个网站都应该提供 API，然而这是不可能的
2. 即使提供了 API，往往也会限速，不如自己找接口

注意已知条件（robots.txt 和 sitemap.xml）

1. robots.txt 中可能会有陷阱
2. sitemap 中可能提供了重要的链接

## 估算网站的大小

一个简便方法是使用 site:example.com 查询，然而这种方法对于大站不适用

## 识别网站所使用的技术

1. builtwith 模块

```
pip install builtwith
builtwith.parse(url) # returns a dict
```	

2. python-whois 模块
```
pip install python-whois
import whois
whois.whois(url)
```

## 下载器

下载器需要提供的几个功能：

1. 错误重试，仅当返回的错误为500的时候重试，一般400错误可认为不可恢复的网页
2. 伪装 UA
3. 策略
    a. 爬取站点地图 sitemap
    b. 通过 ID 遍历爬取
        i. ID 可能不是连续的，比如某条记录被删除了
        ii. ID 访问失效 n 次以后可以认为遍历完全了
4. 相对连接转化，这点可以利用 lxml 的 make_link_absolute 函数
5. 处理 robots.txt 可以利用标准库的 robotsparser 模块

```
import robotsparser
rp = robotparser.RobotFileParser
rp.set_url(&#039;path_to_robots.txt&#039;)
rp.read()
rp.can_fetch(&quot;UA&quot;, &quot;url&quot;)
True or False
```

6. 支持代理
7. 下载限速，粒度应该精确到每一个站点比较好
8. 避免爬虫陷阱，尤其是最后一页自身引用自身的例子
   a. 记录链接深度

例子：https://bitbucket.org/wswp/code/src/chpter01/link_crawler3.py

#Chapter II Scraping

##抽取资源的方式

1. 正则
        不适用于匹配网页结构，因为网页结构中空白等都是无关紧要的，而可能破坏正则 Structural-based
        适用于数据本身符合某种模式，比如 IP 地址，比如日期等 Content-based
2. xpath 与 CSS
        适用于匹配网页的结构信息 Strctual-based，lxml 的 CSS 选择器在内部是转换为 xpath 实现的，css 远不如 xpath 灵活
3. BeautifulSoup，慢，从来没有在生产代码中见到过

下载的第二步，就是把获得的网页传递给 Extractor 来提取内容，可以通过传递给下载函数回调来处理，但是这种耦合性太强了

#Chapter III Downloader Cache

* 书中的缓存把所有相应都做了缓存，包括500的错误响应，实际上这样的直接不缓存好了。。
* 书中的磁盘缓存把 url normalize 逻辑也加到了这里，感觉比较混乱
* 注意使用磁盘文件缓存的话会受限于磁盘单目录文件的数量，即使是 ext4 文件系统也不大

#Chapter IV

执行下载时间估算也是很重要的，每个链接下载需要多长时间，整个过程需要多长时间
多线程的下载例子，手工模拟线程池

```
def process_queue(q):
    pass
	
threads = []
while thread or crawl_queue:
    for thread in threads:
        if not threads.is_alive():            
            threads.remove(thread)
    while len(threads) &lt; max_threads and crawl_queue:
        thread = threading.Thread(target=process_queue, daemon=True)
        thread.start()
        threads.append(thread)
    time.sleep(some_time)
```
	
性能的增长与线程和进程的数量并不是成线性比例的，而是对数比例，因为切换要花费一定的时间，再者最终是受限于带宽的

#Chapter V Dynamic Content

## 逆向接口

依赖于 Ajax 的网站看起来更复杂，但是实际上因为数据和表现层的分离会更简单，但是如果逆向工程也不好得到通用的方法，如何构建一个辅助工具呢？表示出网页上哪些地方是动态加载的，列出 js 全局变量，列出可能的 jsonp 请求

利用 Ajax 接口时，可以利用各种边界情况，比如把搜索条件置为空，置为 *，置为 .

## 渲染动态网页

使用Qt，使用 Selenium 或者 PhantomJS，这时附加 Cookie 等都是很严重的问题

#Chapter VI Form Interaction

* 登录表单中往往会有隐藏的参数，比如 form_key 用于避免表单重复提交，还可能需要 cookie 验证
* Wow，竟然可以直接从浏览器加载 Cookie，使用 browsercookie 模块

#Chapter VII

使用机器识别验证码
使用 Pillow 和 pytesseract 识别验证码，但是 tesseract 本不是用来识别验证码的

##一种锐化方法
```
img.convert(&#039;L&#039;)
img.point(lambda x: 0 if x &lt; 1 else 255, &#039;l&#039;)
tessact.image_to_string(img)
```
	
还可以通过限定字符集提高识别率

还可以使用人工打码平台