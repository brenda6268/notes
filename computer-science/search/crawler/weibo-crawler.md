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
2. 移动版 (m.weibo.cn)
3. WAP 版 (weibo.cn), 数据经常不全. 和上面两个接口的 ID 不是一套.
4. 开放平台的接口

其中开放平台的接口需要创建一个应用然后使用，感觉局限性挺大的，除非抓取量很小。

## 根据关键词抓取指定微博

可以使用移动端的微博接口:

```
https://m.weibo.cn/api/container/getIndex?type=wb&queryVal={}&containerid=100103type=2%26q%3D{}&page={}
```

### 根据关键词获取指定微博评论

## 参考

1. [移动端关键词抓取](https://github.com/gaussic/weibo_wordcloud)
2. [微博搜索 API](https://open.weibo.com/wiki/Search)
3. [移动端抓包](https://segmentfault.com/a/1190000022751731)