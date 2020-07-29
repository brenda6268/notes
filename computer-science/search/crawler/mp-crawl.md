# 微信公众号抓取

<!--
ID: 1b1d7b5d-413a-4dce-bf8b-6e1b85619c24
Status: draft
Date: 2017-05-30T07:11:00
Modified: 2020-05-16T12:00:07
wp_id: 454
-->

# URL 解析

公众号文章地址

链接：`http://mp.weixin.qq.com/s?__biz=XXX&mid=XXX&idx=XXX&sn=XXX`


* __biz  公众号的一个外部 id
* mid	 推送消息的编号，每次推送一组消息会产生一个 mid
* idx	 文章在消息中的位置，第一条 idx 为 1
* sn  一个加密字段，如果没有这个字段，无法打开文章

# 二维码接口

http://mp.weixin.qq.com/mp/qrcode?scene=10000004&size=XXX&__biz=MzA5Njg3MjAzOA==


# 微信UA

```
Mozilla/5.0 (Linux; Android 6.0.1; Redmi Note 4X Build/MMB29M; wv) AppleWebKit/537.36 (KHTML, like Gecko) Version/4.0 Chrome/53.0.2785.49 Mobile MQQBrowser/6.2 TBS/043305 Safari/537.36 MicroMessenger/6.5.8.1060 NetType/WIFI Language/zh_CN
```

# 万能 key

获得账号认证信息, `https://mp.weixin.qq.com/mp/getverifyinfo?__biz=MjM5NjM4MDAxMg==`，2017年7月万能key已经失效


如果包含`个人`字样，则是个人账号，否则是公司账号