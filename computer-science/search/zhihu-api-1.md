# 知乎 API 整理（1）—— Web API


ID: 460
Status: draft
Date: 2018-04-28 02:43:00
Modified: 2020-05-16 11:36:52


首先，我们对知乎站点进行建模。知乎站内一共分为以下几个实体，括号中是知乎在 API 中采用的英文单词：

- 用户（member）
- 问题（question）
- 回答（answer）
- 评论（comment）
- 话题（topic）
- 专栏（column）
- 文章（article）
- 收藏夹（favlist）
- 私信（message）
- 想法（pin）

其中**回答**可以说是知乎站点的核心资源，下面我们逐个分析，然后依次找到相应的接口。

# 接口

### web 端 API

知乎 web 站点采用了 React 框架，因此绝大多数内容都是通过 ajax 加载渲染的，所以说一定有一个方便 js 访问的 API 存在，这个 API 主要用于 web 端访问

v4 API 都以 `https://www.zhihu.com/api/v4/` 为前缀，在获得了登录的合法 cookies 之后，可以在浏览器中直接访问这些 API。如何登录并获得合法 cookies 不是本文关注的重点，读者可以自行查找相关资料（或者直接从浏览器中把你登录后的 cookie 拷贝出来）。

### 移动端 API

通过使用 mitmproxy 在 iOS 上转包，发现知乎的 API 以 `https://api.zhihu.com` 开头。同时令人惊喜的是，只要有登录后的 Cookies，可以直接在浏览器中访问。

PS：收藏夹 API 无法打开。https://api.zhihu.com/collections/100776277/contents?excerpt_len=150

## 概览

本文中的 API 包括了：

类别     | API                      | 地址                                         | 文档   | 测试
----     | ------                   | ------                                      | ------ | ------
用户     | 当前用户基本信息         | GET me/                                        | Y      | Y
用户     | 用户基本信息             | GET members/xxx                                | Y      | Y
用户     | 修改个人信息             | PUT me/                                        | Y      | -
用户     | 关注用户                 | PUT members/xxx/followers                      | P      | -
用户     | 取关用户                 | DELETE members/xxx/followers                   | P      | -
用户     | 关注列表                 | GET members/xxx/followees                      | Y      | Y
用户     | 粉丝                     | GET members/xxx/followers                      | Y      | Y
用户     | 拉黑用户                 | POST members/xxx/actions/block                | -      | Y
用户     | 取消拉黑用户             | DELETE members/xxx/actions/block               |-      | Y
**问题** |
问题     | 问题基本信息             | GET questions/xxx                              | P      | Y
问题     | 创建问题                 | POST questions                                  | -      | -
问题     | 修改问题                 | PUT questions/xxx                              | -      | -
问题     | 关注问题                 | POST questions/275166974/followers            | -      | Y
问题     | 取关问题                |DELETE questions/275166974/followers            | -      | Y
问题     | 用户创建的问题           | GET members/xxx/questions                      | Y      | -
问题     | 用户关注的问题           | GET members/xxx/following-questions            | -      | -
用户     | 问题的关注者             | GET questions/xxx/followers             | -      | -
回答     | 问题的回答               | GET questions/xxx/answers                      | Y      | Y
**回答** |
回答     | 回答基本信息             | GET answers/xxx                                | Y      | Y
回答     | 发布答案                 | POST questions/xxx/answers              | -      | -
回答     | 修改答案                 | PUT answers/xxx                                | -      | -
回答     | 删除答案                 | DELETE answers/xxx                             | -      | -
回答     | 赞同答案                 | POST answers/xxx/voters {type: "up"}              | -   | -
回答     | 反对答案                 | POST answers/xxx/voters {type: "down"}          | -      | -
回答     | 取消投票                 | POST answers/xxx/voters {type: "neutral"}          | -      | -
回答     | 感谢答案                 | POST answers/32522952/thankers               | -      | -
回答     | 没有帮助答案             | POST answers/32522952/unhelpers            | -      | -
回答     | 用户的回答               | GET members/xxx/answers                        | Y      | Y
回答     | 用户赞同的答案           | -                        | -      | -
回答     | 答案的赞同者             | GET answers/xxx/voters                         | -      | -
回答     | 用户反对的答案           | -                                              | -      | -
回答     | 答案的反对者             | -                                              | -      | -
回答     | 收录回答的收藏夹         | GET answers/32522952/favlists                   | -      | -
**评论** |
回答     | 评论基本信息             | GET comments/xxx                               | Y      | Y
评论     | 发表评论                 | POST {questions/answers/articles}/xxx/comments | -      | -
评论     | 删除评论                 | DELETE comments/xxx                            | -      | -
评论     | 赞同评论                 | POST comments/62471009/actions/like   | -      | -
评论     | 问题的评论               | GET questions/51408060/comments                | Y      | Y
评论     | 回答的评论               | GET answers/36174172/comments                  | Y      | Y
评论     | 文章的评论               | GET articles/36174172/comments                 | Y      | Y
评论     | 想法的评论               | -                 | Y      | Y
**话题** |
话题     | 话题基本信息             | GET topics/xxx                                 | Y      | Y
话题     | 最佳回答者               |GET topics/19550994/best_answerers | - | -
话题     | 最新讨论                 |GET topics/19550994/feeds/top_activity | - | -
话题     | 精华讨论                 |GET topics/19550994/feeds/essence
话题     | 创建话题                 | -                                              | -      | -
话题     | 修改话题                 | -                                              | -      | -
问题     | 话题下的问题             | GET topics/19550994/feeds/top_question          | -      | -
话题     | 父话题                  | GET topics/19550994/parent
话题     | 子话题                  | GET topics/xxx/children
**专栏** |
专栏     | 专栏基本信息             | GET columns/wangnuonuo                  | -      | -
专栏     | 专栏文章列表             | GET columns/wangnuonuo/articles                     | -      | -
专栏     | 创建专栏                 | -                                              | -      | -
专栏     | 关注专栏                 | POST columns/wangnuonuo/followers                | -      | -
专栏     | 取关专栏                 | DELETE columns/wangnuonuo/followers              | -      | -
专栏     | 专栏的关注者             | GET columns/wangnuonuo/followers            | -      | -
**专栏** |
文章     | 文章基本信息             | -                                              | -      | -
文章     | 发表文章                 | -                                              | -      | -
**专栏** |
收藏     | 收藏基本信息             | GET favlists/xxx                       | -      | -
收藏     | 创建收藏夹               | -                                              | -      | -
收藏     | 关注收藏夹               | -                                              | -      | -
收藏     | 添加到收藏夹             | -                                              | -      | -
收藏     | 删除文章                 | -                                              | -      | -
收藏     | 获取用户收藏列表         | GET members/xxx/favlists                       | -      | -
收藏     | 获取收藏夹文章列表       | -                                              | -      | -
收藏     | 获取收藏夹的关注人       | -                                              | -      | -
**专栏** |
私信     | 私信基本信息             | -                                              | -      | -
私信     | 获得私信列表             | GET me/message-threads                         | -      | -
私信     | 发送私信                 | -                                              | -      | -
**专栏** |
想法     | 想法基本信息             | GET pins/xxx                                   | -      | -
想法     | 创建一条想法             | -                                              | -      | -
想法     | 删除一条想法             | -                                              | -      | -
想法     | 为一条想法鼓掌           | -                                              | -      | -
想法     | 取消鼓掌                 | -                                              | -      | -
想法     | 获取想法列表             | GET members/xxx/pins                           | -      | -
想法     | 获取用户鼓掌过的想法     | -                                              | -      | -
想法     | 一条想法鼓掌的用户        | -                                              | -      | -


可见知乎的 API 真是非常得 restful 了，至于这样到底好不好，那就仁者见仁智者见智了。

## 返回结果和参数说明

知乎的 API 设计很有规律，按照不同类型，大体可以分为两类：

1. 根据 ID 获取某一个对象的API。一般返回一个字典对象，比如某个用户的接口，某个问题的接口。比如：
    1. members/xxx，获取某个用户
    2. answers/xxx，获取某个答案

2. 根据条件获取某个列表的API。一般返回一个对象数组，比如粉丝列表接口，回答列表接口。每一个列表都有固定的分页信息（paging）字段，和数据（data）字段。比如：
    1. members/xxx/followers 获取某个用户的粉丝
    2. questions/xxx/answers 获取某个问题的答案

其中分页信息是这样的：

```
&quot;paging&quot;: {
    &quot;is_end&quot;: false,
    &quot;totals&quot;: 11,
    &quot;previous&quot;: &quot;https://www.zhihu.com/members/kongyifei/questions?limit=10&amp;offset=0&quot;,
    &quot;is_start&quot;: true,
    &quot;next&quot;: &quot;https://www.zhihu.com/members/kongyifei/questions?limit=10&amp;offset=10&quot;
},
```

我们可以使用 limit 和 offset 两个参数来遍历所有的分页，其中 limit 的最大取值为 20。还可以使用 sort_by 来按不同的方式排序。sort_by 的可选值如下：

参数 | 含义
-----|----
default | 默认排序
created | 创建时间

对于每一个对象，接口都有一个默认的返回字段，如果想要获得更多信息，需要使用 include 参数指定需要的字段。知乎的多数接口都支持使用 include 参数，include 后面包含了一个`,`分隔的列表，用于指定额外获取的字段。另外还可以采用`;`分组，指定不同的字段集合。每一个对象都有不同的字段，后面的表中列出了不同对象的字段和含义。

对于返回一个对象的接口，直接指定字段即可，比如使用了参数：

```
include=voteup_count,business
```

会在结果中增加：

```
{
    &quot;voteup_count&quot;: 704,
    &quot;business&quot;: ...
}
```

对于复合在其他对象中的字段，需要使用 json path 指定前缀，对于使用了参数：

```
include=data[*].answer_count,articles_count
```

会在结果中增加：

```
{
    &quot;paging&quot;: {
        ...
    },
    &quot;data&quot;: [
        {
            ...
            &quot;answer_count&quot;: 100,
            &quot;articles_count: 100
            ...
        },
        ...
    ]
}
```

### 对象的字段（可以在 include 中使用）

用户字段如下：

参数 | 说明 | 说明
----|-----|------
locations | 所在城市 |列表
employments | 工作经历 | 列表
gender | 性别 | 1 男性，0 女性
educations | 教育经历 | 列表
business | 行业 | 列表
voteup_count | 获得赞同 | int
thanked_Count | 获得感谢 | int
follower_count | 粉丝 | int
following_count | 关注数量 | int
cover_url | 封面图片
following_topic_count | 关注话题
following_question_count | 关注问题
following_favlists_count | 关注收藏夹
following_columns_count |关注专栏
avatar_hue |
answer_count | 回答数
articles_count | 文章数
pins_count | 想法数
question_count | 提问数
columns_count | 专栏数
commercial_question_count | 商业提问数
favorite_count | ？
favorited_count | ？
logs_count | ？
included_answers_count | ？
included_articles_count | ？
included_text | ？
message_thread_token | 一个用于私信的 token
account_status | 账户状态
is_active | ？
is_bind_phone | 是否绑定手机
is_force_renamed | 是否被强制更名
is_bind_sina | 是否绑定微博
is_privacy_protected | ？
sina_weibo_url | 新浪微博
sina_weibo_name | 新浪微博用户名
show_sina_weibo | 是否展示新浪微博
is_blocking | 是否拉黑此用户
is_blocked | 是否被此用户拉黑
is_following | 是否关注此用户
is_followed | 是否被此用户关注
is_org_createpin_white_user | ？
mutual_followees_count | 共通关注数量
vote_to_count | 点了多少支持
vote_from_count | 收到多少支持
thank_to_count | 
thank_from_count |
thanked_count | ？
description | 介绍
hosted_live_count | 主持 live 数量
participated_live_count | 参与 live 数量
allow_message | 是否可以发私信
industry_category | ？
org_name | ?
org_homepage | ?
badge[?(type=best_answerer)].topics | ?

问题字段如下：

字段 | 含义
----|----
anthor | 作者

回答字段如下：

字段 | 含义
-----|-----
is_normal | ?
is_sticky | ?
collapsed_by | ?
suggest_edit | ?
comment_count | 评论数
collapsed_counts |
reviewing_comments_count | 审核中评论数
can_comment | 能否评论
content | 内容
editable_content | ？
voteup_count | 赞同数量
reshipment_settings | ？
comment_permission | 评论权限
mark_infos | ？
created_time |创建时间
updated_time | 更新时间
relationship | ？
is_author | 是否作者
voting | ？
is_thanked | 是否已感谢
is_nothelp | 是否已没有帮助
upvoted_followees | 点赞的关注者

评论的字段如下：

字段 | 含义
----|----
"allow_reply" | true,
"collapsed" | false,
"created_time"| 1445988512,
"featured"| false,
"reviewing"| false,
"allow_vote"| true,
"allow_like"| true,
"is_author"| false,
"can_recommend"| false,
"id"| 100969802,
"is_delete"| false,
"url"| "http://www.zhihu.com/api/v4/comments/100969802",
"content"| "你好請問ralink和ramips有什麼區別，刷小米路由器mini時要用哪種",
"allow_delete"| false,
"can_collapse"| false,
"type"| "comment",
"resource_type"| "answer"

话题的字段如下：

专栏的字段如下：

参考：https://www.zhihu.com/api/v4/columns/wangnuonuo

字段 | 含义
----|----
accept_submission| 接受投稿
title | 题目
comment_permission | 评论权限
updated | ？
image_url | 头像
type | 类型：column
id  | 专栏的 url 后缀
author | 作者

文章的字段如下：

参见：https://www.zhihu.com/api/v4/columns/wangnuonuo/articles

字段 | 含义
----|----
"image_url"| 题图链接
"updated"| 1521005699,
"topics" | [],
"excerpt"| 摘要
"admin_closed_comment": false,
"can_tip": false,
"excerpt_title": "",
"id": 34536955,
"voteup_count": 10068,
"upvoted_followees": [],
"voting": 0,
"author": {},
"url": "http://zhuanlan.zhihu.com/p/34536955",
"comment_permission": "all",
"created": 1521005343,
"comment_count": 577,
"is_title_image_full_screen": false,
"title": "其实，我们还有一个见霍金一面的机会",
"can_comment": {},
"type": "article",
"suggest_edit": {}

收藏的字段如下：


下面把接口逐个展开介绍一下。

## 用户

### 自身信息

地址：https://www.zhihu.com/api/v4/me

用于获取当前用户自身的基本信息。

```
请求：

GET https://www.zhihu.com/api/v4/me

响应：

{
    &quot;avatar_url_template&quot;: &quot;https://pic4.zhimg.com/71084089289f9820f529a9457a93db02_{size}.jpg&quot;,
    &quot;uid&quot;: 26963964067840,
    &quot;follow_notifications_count&quot;: 0,
    &quot;user_type&quot;: &quot;people&quot;,
    &quot;badge&quot;: [],
    &quot;editor_info&quot;: [],
    &quot;default_notifications_count&quot;: 0,
    &quot;url_token&quot;: &quot;kongyifei&quot;,
    &quot;id&quot;: &quot;e8002099d78754129be0180a00890361&quot;,
    &quot;messages_count&quot;: 0,
    &quot;name&quot;: &quot;Angry Bugs&quot;,
    &quot;is_advertiser&quot;: false,
    &quot;url&quot;: &quot;http://www.zhihu.com/api/v4/people/e8002099d78754129be0180a00890361&quot;,
    &quot;gender&quot;: 1,
    &quot;headline&quot;: &quot;requests工程师&quot;,
    &quot;avatar_url&quot;: &quot;https://pic4.zhimg.com/71084089289f9820f529a9457a93db02_is.jpg&quot;,
    &quot;is_org&quot;: false,
    &quot;type&quot;: &quot;people&quot;,
    &quot;vote_thank_notifications_count&quot;: 0
}
```

结果说明：

1. 其中 avatar_url_template 中的 size 可以使用 xl 替换。
2. url_token 构成了用户的主页链接，是一个很重要的参数

### 修改个人信息

地址：https://www.zhihu.com/api/v4/me

方法：PUT

直接 PUT 到这个接口就会修改，同时返回修改后的结果

```
请求：

PUT https://www.zhihu.com/api/v4/me
{&quot;employments&quot;:[{&quot;job&quot;:&quot;&quot;,&quot;company&quot;:&quot;今日头条（应用）&quot;},{&quot;job&quot;:&quot;&quot;,&quot;company&quot;:&quot;汤森路透 (Thomson Reuters)&quot;}]}

响应：

{
    // 修改后的用户基本信息，结构同上
}
```

### 其他用户信息

地址：https://www.zhihu.com/api/v4/members/{URL_TOKEN|ID}

用于获取某个用户的相关信息。其中使用 url_token 或者是 ID 都是可以的。

比如：

```
请求：

https://www.zhihu.com/api/v4/members/e8002099d78754129be0180a00890361

响应：

{
    // 用户基本信息，结构同上
}
```

### 已关注用户

地址：https://www.zhihu.com/api/v4/members/{URL_TOKEN|ID}/followees

这个接口用来返回当前用户关注的用户。返回一个数组，其中每个元素就是上文中的 user 对象。

比如：

```
请求：

GET https://www.zhihu.com/api/v4/members/yksin/followees?include=data[*].answer_count

响应：

{
    &quot;paging&quot;: {
        &quot;is_end&quot;: false,
        &quot;totals&quot;: 460,
        &quot;previous&quot;: &quot;http://www.zhihu.com/api/v4/members/yksin/followees?limit=10&amp;offset=0&quot;,
        &quot;is_start&quot;: true,
        &quot;next&quot;: &quot;http://www.zhihu.com/api/v4/members/yksin/followees?limit=10&amp;offset=10&quot;
    },
    &quot;data&quot;: [
        {
            &quot;avatar_url_template&quot;: &quot;https://pic4.zhimg.com/v2-c87c70b1162392461b8bf8d014ccccf2_{size}.jpg&quot;,
            &quot;type&quot;: &quot;people&quot;,
            &quot;name&quot;: &quot;王瑞恩&quot;,
            &quot;is_advertiser&quot;: false,
            &quot;url&quot;: &quot;http://www.zhihu.com/api/v4/people/6d443177eca4f4f098b4a4b63046b4b0&quot;,
            &quot;user_type&quot;: &quot;people&quot;,
            &quot;headline&quot;: &quot;老王力气大无穷 双手举起纸灯笼&quot;,
            &quot;avatar_url&quot;: &quot;https://pic4.zhimg.com/v2-c87c70b1162392461b8bf8d014ccccf2_is.jpg&quot;,
            &quot;is_org&quot;: false,
            &quot;gender&quot;: 1,
            &quot;url_token&quot;: &quot;wang-rui-en&quot;,
            &quot;id&quot;: &quot;6d443177eca4f4f098b4a4b63046b4b0&quot;,
            &quot;answer_count&quot;: 100
        },
        ...
    ]
}
```

### 粉丝

地址：https://www.zhihu.com/api/v4/members/{URL_TOKEN|ID}/followers

这个接口用来返回当前用户的粉丝。返回一个数组，其中每个元素就是上文中的 user 对象。

```
请求：

https://www.zhihu.com/api/v4/members/yksin/followers

响应：

类似上文，略过
```

### 关注用户

地址：https://www.zhihu.com/api/v4/members/{URL_TOKEN|ID}/followers

方法 PUT

这个接口用来关注某个用户。

返回结果未知

### 取关用户

地址：https://www.zhihu.com/api/v4/members/{URL_TOKEN|ID}/followers

方法 DELETE

这个接口用来取消关注某个用户

返回结果未知

## 问题

### 问题基本信息

地址：https://www.zhihu.com/api/v4/questions/QUESTION_ID

用户获取某个问题的相关信息，其中 question_id 是这个问题的 id

```
请求：

https://www.zhihu.com/api/v4/questions/21241873

响应：

{
    &quot;question_type&quot;: &quot;normal&quot;,
    &quot;created&quot;: 1371953970,
    &quot;url&quot;: &quot;http://www.zhihu.com/api/v4/questions/21241873&quot;,
    &quot;title&quot;: &quot;如何评价凤姐的诗？&quot;,
    &quot;type&quot;: &quot;question&quot;,
    &quot;id&quot;: 21241873,
    &quot;updated_time&quot;: 1386308423
}
```


### 创建问题

```
请求：

POST questions
{&quot;type&quot;:0,&quot;title&quot;:&quot;炒土豆时如何避免过软？&quot;,&quot;topic_url_tokens&quot;:[&quot;19680763&quot;],&quot;detail&quot;:&quot;&quot;,&quot;is_anonymous&quot;:false}
```

### 用户创建的问题列表

地址：https://www.zhihu.com/api/v4/members/{URL_TOKEN|ID}/questions

获得用户创建的问题

```
请求：

https://www.zhihu.com/api/v4/questions/21241873?include=author

响应：

{
    &quot;paging&quot;: {
        &quot;is_end&quot;: false,
        &quot;totals&quot;: 11,
        &quot;previous&quot;: &quot;https://www.zhihu.com/members/kongyifei/questions?limit=10&amp;offset=0&quot;,
        &quot;is_start&quot;: true,
        &quot;next&quot;: &quot;https://www.zhihu.com/members/kongyifei/questions?limit=10&amp;offset=10&quot;
    },
    &quot;data&quot;: [
        {
            &quot;question_type&quot;: &quot;normal&quot;,
            &quot;created&quot;: 1523350938,
            &quot;url&quot;: &quot;https://www.zhihu.com/questions/271758908&quot;,
            &quot;title&quot;: &quot;如何看待广电总局要求今日头条关闭内涵段子？&quot;,
            &quot;type&quot;: &quot;question&quot;,
            &quot;id&quot;: 271758908,
            &quot;updated_time&quot;: 1523350938
        },
         ...
    ]
}
```

## 回答

一般通过问题或者用户来获得一个回答的列表。

### 创建回答

```
POST questions/xxx/answers

{&quot;content&quot;:&quot;&lt;p&gt;加点醋就好了&lt;/p&gt;&quot;,&quot;reshipment_settings&quot;:&quot;allowed&quot;,&quot;comment_permission&quot;:&quot;all&quot;,&quot;reward_setting&quot;:{&quot;can_reward&quot;:false}}
```



### 问题的回答

地址：https://www.zhihu.com/api/v4/questions/21241873/answers

```
请求：

https://www.zhihu.com/api/v4/questions/21241873/answers

响应：

{
    &quot;paging&quot;: {
        &quot;is_end&quot;: false,
        &quot;totals&quot;: 115,
        &quot;previous&quot;: &quot;http://www.zhihu.com/api/v4/questions/21241873/answers?limit=5&amp;offset=0&quot;,
        &quot;is_start&quot;: true,
        &quot;next&quot;: &quot;http://www.zhihu.com/api/v4/questions/21241873/answers?limit=5&amp;offset=5&quot;
    },
    &quot;data&quot;: [
        {
            &quot;is_collapsed&quot;: false,
            &quot;author&quot;: {
                ...
            },
            &quot;url&quot;: &quot;http://www.zhihu.com/api/v4/answers/20596524&quot;,
            &quot;id&quot;: 20596524,
            &quot;question&quot;: {
                &quot;question_type&quot;: &quot;normal&quot;,
                &quot;created&quot;: 1371953970,
                &quot;url&quot;: &quot;http://www.zhihu.com/api/v4/questions/21241873&quot;,
                &quot;title&quot;: &quot;如何评价凤姐的诗？&quot;,
                &quot;type&quot;: &quot;question&quot;,
                &quot;id&quot;: 21241873,
                &quot;updated_time&quot;: 1386308423
            },
            &quot;updated_time&quot;: 1386560586,
            &quot;extras&quot;: &quot;&quot;,
            &quot;created_time&quot;: 1386236483,
            &quot;type&quot;: &quot;answer&quot;,
            &quot;thumbnail&quot;: &quot;&quot;,
            &quot;is_copyable&quot;: true
        },
        ...
    ]
}
```

### 用户的回答

地址：https://www.zhihu.com/api/v4/members/{URL_TOKEN|ID}/answers

用于获取用户的回答

```
请求响应结构同上
```

## 评论

### 获取单个评论



### 获取评论列表

地址：https://www.zhihu.com/api/v4/{answers|articles|questions}/ID/comments

用于获取答案、文章、问题对应的评论

```
请求：

https://www.zhihu.com/api/v4/answers/30480156/comments

响应：

{
    &quot;featured_counts&quot;: 0,
    &quot;common_counts&quot;: 1,
    &quot;collapsed_counts&quot;: 0,
    &quot;reviewing_counts&quot;: 0,
    &quot;paging&quot;: {
+---  5 lines: &quot;is_end&quot;: true,---------------------------------------------------------------
    },
    &quot;data&quot;: [
        {
            &quot;id&quot;: 100969802,
            &quot;type&quot;: &quot;comment&quot;,
            &quot;url&quot;: &quot;https://www.zhihu.com/api/v4/comments/100969802&quot;,
            &quot;content&quot;: &quot;你好請問ralink和ramips有什麼區別，刷小米路由器mini時要用哪種&quot;,
            &quot;featured&quot;: false,
            &quot;collapsed&quot;: false,
            &quot;is_author&quot;: false,
            &quot;is_delete&quot;: false,
            &quot;created_time&quot;: 1445988512,
            &quot;resource_type&quot;: &quot;answer&quot;,
            &quot;reviewing&quot;: false,
            &quot;allow_like&quot;: true,
            &quot;allow_delete&quot;: false,
            &quot;allow_reply&quot;: true,
            &quot;allow_vote&quot;: true,
            &quot;can_recommend&quot;: false,
            &quot;can_collapse&quot;: false,
            &quot;author&quot;: {
                &quot;role&quot;: &quot;normal&quot;,
                &quot;member&quot;: {
+------ 13 lines: &quot;id&quot;: &quot;3be65dd46b4801b139cc8c7a59d8a679&quot;,----------------------------------
                }
            },
            &quot;is_parent_author&quot;: false,
            &quot;vote_count&quot;: 0,
            &quot;voting&quot;: false,
            &quot;disliked&quot;: false
        }
    ]
}
```



## 话题

地址：https://www.zhihu.com/api/v4/topics/TOPIC_ID

用于获取某个话题的相关信息，其中 topic_id  是这个话题的 id。

```
&gt;&gt;&gt; https://www.zhihu.com/api/v4/topics/19850467

{
    &quot;unanswered_count&quot;: 4253,
    &quot;best_answerers_count&quot;: 185,
    &quot;name&quot;: &quot;今日头条（应用）&quot;,
    &quot;url&quot;: &quot;http://www.zhihu.com/api/v4/topics/19850467&quot;,
    &quot;father_count&quot;: 2,
    &quot;excerpt&quot;: &quot;你关心的，才是头条！《今日头条》会聪明地分析您的兴趣爱好，理解您的阅读行为，自动为您推荐喜欢的内容，并且越用越懂你！&quot;,
    &quot;introduction&quot;: &quot;你关心的，才是头条！《今日头条》会聪明地分析您的兴趣爱好，理解您的阅读行为，自动为您推荐喜欢的内容，并且越用越懂你！&quot;,
    &quot;followers_count&quot;: 12620,
    &quot;avatar_url&quot;: &quot;https://pic2.zhimg.com/50/14f39d483ad0cc2ebcae6306bd974b0e_hd.jpg&quot;,
    &quot;best_answers_count&quot;: 695,
    &quot;type&quot;: &quot;topic&quot;,
    &quot;id&quot;: &quot;19850467&quot;,
    &quot;questions_count&quot;: 4253
}

```

# REF：

1. https://github.com/YaoZeyuan/ZhihuHelp/issues/89
2. https://github.com/JimmyLv/jimmylv.github.io/issues/232
3. https://github.com/lzjun567/zhihu-api/