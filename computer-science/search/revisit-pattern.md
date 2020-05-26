# 网页更新与重抓策略


ID: 456
Status: publish
Date: 2018-11-13 00:56:00
Modified: 2020-05-16 11:07:44


我们知道网页总是会更新的。在大规模的网络爬取中，一个很重要的问题是重抓策略，也就是在什么时候去重新访问同一个网页已获得更新。要获得这个问题的解，需要满足如下两个条件：

1. 尽可能地少访问，以减少自身和对方站点的资源占用
2. 尽可能快的更新，以便获得最新结果

这两个条件几乎是对立的，所以我们必须找到一种算法，并获得一个尽可能优的折衷。

可以使用泊松过程：https://stackoverflow.com/questions/10331738/strategy-for-how-to-crawl-index-frequently-updated-webpages