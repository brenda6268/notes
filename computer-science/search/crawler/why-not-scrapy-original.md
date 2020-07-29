# 为什么不使用 scrapy？

<!--
ID: 7d9b3187-9386-433a-bc3f-e99d91aaabf6
Status: publish
Date: 2018-09-05T19:50:00
Modified: 2020-05-16T11:23:41
wp_id: 469
-->

请参考更新版本: https://yifei.me/note/838


最近面了几家公司，每当我提到头条的爬虫都是自己写的时候，对方一个下意识的问题就是: “为什么不使用开源的 scrapy？”。实际上我在头条的 lead 就是 scrapy 的 contributor，而他自己也不用自己的框架，显然说明 scrapy 不适合大型项目，那么具体问题在哪儿呢？今天终于有时间了，详细写写这个问题。

## 爬虫并不需要一个框架

Web 服务器是一个爬虫可以抽象出来的是各种组件。而 scrapy 太简陋了，比如说去重，直接用的是内存中的一个集合。如果要依赖 scrapy 写一个大型的爬虫，几乎每个组件都要自己实现，那有何必用 scrapy 呢？

## scrapy 不是完整的爬虫框架

一个完整的爬虫至少需要两部分，fetcher 和 frontier。其中 fetcher 用于下载网页，而 frontier 用于调度。scrapy 重点实现的是 fetcher 部分，也就是下载部分。

## scrapy 依赖 twisted

这一点导致 scrapy 深入后曲线非常地陡峭，要想了解一些内部的机理，必须对 twisted 比较明了。而 twisted 正如它的名字一样，是非常扭曲的一些概念，虽然性能非常好，但是要理解起来是要花上不少时间的。

## scrapy 适合的领域

scrapy 主要适合一次性地从指定的站点爬取一些数据

最重要的并不是你使用不使用 Scrapy，而是你不能为每一站点去单独写一个爬虫的脚本。代码的灵活度实在太大了，对于没有足够经验的工程师来说，写出来的脚本可能很难维护。重点是要把主循环掌握在爬虫平台的手中，而不是让每一个脚本都各行其是。


## 参考

1. [scrapy 源码解读](http://kaito-kidd.com/2016/11/01/scrapy-code-analyze-architecture/)
