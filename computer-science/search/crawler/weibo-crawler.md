# 抓取新浪微博的数据

<!--
ID: c5eba3b3-7c21-42ca-bee6-89156ca3071f
Status: draft
Date: 2020-08-08T16:33:50
Modified: 2020-08-08T16:33:50
wp_id: 1857
-->

新浪微博的数据总体来说可以通过几个接口获取：

1. 网页版 (weibo.com)
2. 移动版 (m.weibo.cn)  JSON 接口数据很丰富
3. WAP 版 (weibo.cn), 数据经常不全。和上面两个接口的 ID 不是一套。
4. 开放平台的接口，需要创建一个应用然后使用，感觉局限性挺大的，除非抓取量很小。

新浪微博的数据有两套 id, 一个叫 id/mid, 是数字类型的，另一套叫做 bid, 是字符类型的。


## 根据关键词抓取指定微博

可以使用移动端的微博，翻页也不需要登录，随便撸

```
https://m.weibo.cn/api/container/getIndex?containerid=100103type%3D1%26q%3D%E8%8B%B9%E6%9E%9C%E8%BE%93%E5%85%A5%E6%B3%95&page_type=searchall&page=99
```

### 抓取微博的评论

这个接口翻页需要登录

```
https://m.weibo.cn/comments/hotflow?id=4282494510984677&mid=4282494510984677&max_id_type=0
```

### 抓取单条微博的接口

不需要登录，随便撸

```
https://m.weibo.cn/statuses/show?id=JgPmzBaKZ
```

### 抓取用户微博

不需要登录，翻页也不需要，随便撸

```
https://m.weibo.cn/api/container/getIndex?uid=5524254784&t=0&luicode=10000011&containerid=1076035524254784&since_id=4378269463566752
```

## 几个尚未查看的项目

1. https://github.com/nghuyong/WeiboSpider


## 参考

1. [移动端关键词抓取](https://github.com/gaussic/weibo_wordcloud)
2. [微博搜索 API](https://open.weibo.com/wiki/Search)
3. [移动端抓包](https://segmentfault.com/a/1190000022751731)
