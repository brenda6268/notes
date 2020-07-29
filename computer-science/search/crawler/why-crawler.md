# 为什么要写爬虫？

<!--
ID: 15a066dc-77be-4b1b-abad-3c5e9c60f008
Status: publish
Date: 2017-05-29T14:24:00
Modified: 2020-05-16T12:08:56
wp_id: 470
-->

为什么要爬数据？

To quote Wikipedia

> The key element that distinguishes data scraping from regular parsing is that the output being scraped was intended for display to and *end-user*, rather than as input to another program, and is therefore usually *neither documented nor structured* for convenient parsing.

* 爬取整站思路：使用图遍历算法
* 爬取更新思路：找列表页，不断刷新获得更新

如何获得列表页？
通过爬取整站，通过机器学习，查找列表页