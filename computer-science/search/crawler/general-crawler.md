# 关于通用爬虫的一些想法

<!--
ID: b6a995c1-c0ee-4a2c-b769-f127c769c1f3
Status: draft
Date: 2017-08-14T20:58:00
Modified: 2020-05-16T11:48:49
wp_id: 446
-->

总的来说，爬虫可能需要处理两种任务，一种是日常的大规模爬取，可能需要对某些站点或者全网进行周期性爬取；另一种可能是临时对某个站点的某类网页提取一些数据，只需要爬取特定的一类网页。两者没有特别明晰的界限，而且后者也可以直接从第一种已经爬过的网页中提取数据就可以了。另外，对于后者来说, 抓过的页面不需要再抓, 而对于搜索引擎来说, 还需要分辨出哪些连接需要反复抓。

# 组件

## 抽取

从网页中根据指定的规则抽取出对应的内容, 规则可以使用 xpath、CSS 或者正则表达式, 或者是训练好的模型, 或者是使用 json 或者 yaml 来表达以上规则的复合规则。

## Downloader 下载

下载需要控制封禁, 比如对一个站点的频次控制

1. 错误重试，仅当返回的错误为500的时候重试，一般400错误可认为不可恢复的网页
2. 伪装 UA
3. 策略
    1. 爬取站点地图 sitemap
    2. 通过 ID 遍历爬取
        1. ID 可能不是连续的，比如某条记录被删除了
        2. ID 访问失效 n 次以后可以认为遍历完全了
4. 相对连接转化，这点可以利用 lxml 的 make_link_absolute 函数
5. 处理 robots.txt 可以利用标准库的 robotsparser 模块

  ```
  import robotsparser
  rp = robotparser.RobotFileParser
  rp.set_url('path_to_robots.txt')
  rp.read()
  rp.can_fetch("UA", "url")
  True or False
  ```

6. 支持代理
7. 下载限速，粒度应该精确到每一个站点比较好
8. 避免爬虫陷阱，尤其是最后一页自身引用自身的例子
   1. 记录链接深度

例子：https://bitbucket.org/wswp/code/src/chpter01/link_crawler3.py

## Dispatcher

对于 dispatcher 的分发算法, 最简单可以采用 round robin, 个人感觉应该采用 hash, 同一个域名尽量发送到同一个 crawler, 这样可以复用一下之前的连接。

## Scheduler（调度器）

![](https://ws4.sinaimg.cn/large/006tKfTcly1fqaz9m1d8mj30uo0iz41v.jpg)


# 几种运行模式

## 命令行模式

这种模式只考虑小规模的数据抓取，所有的队列和集合都是用python内置的对象，放在本机内存中。存储结果也放在本地的json文件中，抓取结束后一次性的 dump 出所有结果。

## 在线模式

这种模式适合大规模的抓取，不直接从命令行执行，而是从任务调度队列取事件，再去抓取

# 一些问题

搜索引擎级的爬虫都会遇到那些问题？如何处理越来越多的webapp

hub 和 detail 两种页面不应该严格区分，而是作为每一个页面的两个属性
 
网页上的链接应该分两种类型：button和anchor。button在同一个页面内，window不会消失；anchor会加载新的页面

一个页面内抓取的是列表还是单个数据。值的列表如何重组为对象的列表。如果乳量不宜，对应就丢了，很棘手。

如果用 url 做主键也有问题，url 可能是不更新的，而页面内容在更新

## 如何分辨动态网页

初步想法，可以看加载了哪个库, 比如vue, react. 查看网页渲染前后的diff. 查看js和html的大小对比

## 需要关注的指标

- 网页的成功率（200 OK）
- 网页的下载时长
- 网页的大小
- html 解析成功率
- crawl rate，新链接的速率
- 旧链接的比例

# 提高抓取效率

1. 使用自己的dns是一个提高速度的很好方法
2. 使用 [bloom filter][1]
3. 如果可能的话，可以使用google、bing、baidu
   1. 去发现站点的新连接
   2. 获取meta信息
   3. 直接抓取google的缓存
4. auto-throttle algorithm
5. 使用你的用户作为出口节点
6. 抓取并使用所有有外网访问权限的web服务作为节点
7. 反向生成[站点模板][3]，这方面参考wenhao维护的群体特征服务

# 数据库存贮

* spider 可以是一次性的或者重复运行的
* run 表示根据 spider 生成的一次任务
* result 表示产生的结果

# 爬虫的意义

竞品监控，对于竞争对手，监控对方的数据；对于潜在收购对象，监控对方数据是否真实

在这其中，数据的可视化非常重要。[4]

# 规则设计

对于类似列表的网页，应该是每一行中再抽取出几个元素作为item。但是直接指定这些元素作为item的话，又有可能出现数量不匹配的情况。这时候还是把行作为item，然后添加一个再使用一个processor从这一行中利用正则抽取出不同的元素

# 索引

需要实时索引和离线索引两部分

# 数据结构

1. 所有数据结构通过 thrift struct 定义，不依赖于 thrift_gen
用好optional字段，通过isset判断，做好兼容性。

1. 全流程中，两个最重要的结构 CrawlDoc，MergedDoc
  1. 初始构造doc，填充一些参数，pipeline就是对doc的加工
  2. doc带有业务类型标示，还有程序开关标示，如 ignore_robots`, return_fast vs is_hot_news等
  3. 抓取中不要包含业务代码

```
service CrawlDocServlet {
    oneway void feed(list<CrawlDoc> crawl_doc_list);
    bool IsHealthy();
}
```

每个域名后面有多少IP都需要统计

对于过大的网页要抛弃，抓网页大小设置成2M就可以了

对站点抓取要控制频率，每个 domain 有一个访问频率统计

每个抓取机器都有自己的 DNS 缓存

要把文件汇聚成大文件存储, 而不要每个网页都存储一个文件, 减少磁盘寻道时间。也就是 GFS 呗。

评估指标：覆盖度，时效性，死链率

## 如何获得大量的 IP

1. 使用你的用户作为你的出口节点
2. 使用有免费接口的网络服务作为出口节点
3. 对于一些数据，可以从 Google 或者 archive.org 等处抓取

一定要启用 gzip，会大规模的减少数据的吞吐
 
 
参考：
 
[1]: http://www.cnblogs.com/coser/archive/2012/03/16/2402389.html
[2]: http://www.zhihu.com/question/24326030/answer/71813450
[3]: http://www.cnblogs.com/jexus/p/5471665.html
[4]: https://www.zhihu.com/question/27621722