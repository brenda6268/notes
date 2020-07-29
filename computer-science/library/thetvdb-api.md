# 美剧数据库 TheTVdb API 介绍

<!--
ID: 0c9d9a78-cbd3-4a7d-b1d7-5cd8760a2fac
Status: draft
Date: 2018-08-05T15:50:00
Modified: 2020-05-16T11:22:52
wp_id: 621
-->

首先上官方网址：https://api.thetvdb.com/swagger。所有的 API 的终点都是：https://api.thetvdb.com/，下文不再重复

# 登录

TheTVdb 的所有 API 都需要登录授权，可能是为了防止过量访问吧。首先需要注册一个账户，然后到 [API Access](https://www.thetvdb.com/member/api) 页面查看自己的授权码。

需要注意的是，TheTVdb 的 API 是仅对非盈利项目免费的，如果是商业项目，可以每个月向他们捐款五美元

> We have an API that is free for non-commercial and educational projects. If you plan on using our data in a commercial project (regardless of how it makes money), we kindly request that you make a $5 (or more) monthly donation to help support our project, and to keep our API free for non-commercial and educational purposes.  To set up that donation, please click the Donate button below.

填写项目名称，得到如图所示的 API KEY

![](https://ws3.sinaimg.cn/large/006tKfTcly1ftznkoerkzj318i0lstbd.jpg)

1. 使用上一步获取的 API KEY，POST 到 /login 获取 token，curl 请求如下：

```
curl -X POST \
--header "Content-Type: application/json" \
--header "Accept: application/json" \
-d "{"apikey": "xxxxxxx"}" \
"https://api.thetvdb.com/login"
```

返回如下：

```
{
  "token": "xxx"
}
```

2. 之后所有的访问，都需要加上如下的 header

```
Authorization: Bearer <上一步得到的token>
```