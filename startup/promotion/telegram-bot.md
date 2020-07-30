# telegram 机器人研发

<!--
ID: 5b51b998-8056-42b4-bf0c-792cc5d05201
Status: draft
Date: 2018-04-16T10:27:00
Modified: 2020-05-16T11:36:05
wp_id: 368
-->

# telegram

普通的 tg 账户需要使用手机号注册，同时 telegram 也可以创建 bot，不需要用手机号注册，和普通账户是不一样的，有点类似钉钉机器人。

telegram 的 api 也分为两类，telegram api 和 telegram bot api。在 Google 上搜 telegram api 的话大部分结果都是 telegram bot api 的封装，好不容易找到了如下几个库。

## 第三方库

地址 | 类型 | 语言  | 文档
----|------|------|------
https://github.com/kimrgrey/go-telegram | bot | go    | -
https://github.com/slowriot/libtelegram | bot lib| c++| - 
https://github.com/vysheng/tgl          |client lib| c| -
https://github.com/vysheng/tg           | client | c  | -
https://github.com/shelomentsevd/telegramgo | client | go | - 
https://github.com/pyrogram/pyrogram | client lib | python  | - 
https://github.com/LonamiWebs/Telethon | client lib | python  | [readthedocs](http://telethon.readthedocs.io/en/latest/index.html)

上面的库中，telethon 应该是有文档并且社区最大的了，基于 Python，开发应该也还比较简便。


### 获取 app id

* 登录 Telegram core: https://my.telegram.org.
* 点击 ‘API development tools’ 并填写信息
* 你将会获得基本地址和 `api_id` 和 `api_hash`。在用户授权的时候会需要。
* 目前每个号码只能有一个 api_id

### 用户授权

用户授权需要用户的加密id：`auth_key_id`。第一步，使用`auth.SendCode/Call`方法发送验证码或者验证电话到用户手机上。同时，这个函数会返回`phone_registered`字段表示这个手机号是否注册。第二步，如果已经注册过，调用`auth.SignIn`方法；如果没有注册过，需要让用户填写基本资料，并且调用`auth.SignUp`函数。

## telethon 概要

### 搭建环境

```
% create-venv
% pip install telethon
```

### 第一个 telefarm 机器人

```
from telethon import TelegramClient

api_id = 12345
api_hash = "0123456789abcdef0123456789abcdef"
session_name = "telefarm"

client = TelegramClient(session_name, api_id, api_hash)
```

telethon 会把得到的 auth_key_id 用 sqlite3 存到本地 session_name.session 文件中。这样就不需要每次登录了。

### 创建与登录账号

如上面所述步骤，第一步我们需要创建账户或者登录，[文档](http://telethon.readthedocs.io/en/latest/telethon.html)中相关的函数有：

函数  | 说明
-----|-------
`client.is_user_authorized() -> bool` | 返回是否已经获得了当前用户的授权
`client.send_code_request(phone, force_sms=False) -> SentCode` | 申请 tg 服务器向用户发送
`client.sign_up(code, first_name, last_name='') -> User` | 注册用户
`client.sign_in(phone=None, code=None, password=None, bot_token=None, phone_code_hash=None)` | 登录

注意电话号码必须是 +86xxxxxxxxxxx 这种格式的，必须带上国家区号。

### 会话(session)

* 使用 `client.send*` 系列函数发送消息
* 使用 `client.add_event_handler` 或者使用 `@client.on` decorator 来注册时间处理函数 

session 和用户的对应关系

从当前 Telethon 的代码来看，一个 session 对应了一个 auth_key，也就是一个用户。

如果需要把 telethon 的 session 保存出来，现在看来需要重写一个对应的 Session。和 telethon 源码中的类的继承关系如下：

```
telethon.sessions.AbstarctSession
             ^
             |
telethon.sessions.MemorySession
             ^
             |
       +-----+-----+
       |           |
SqliteSession  TelefarmSession（我们的）
```

### Bot 农场

要创造一个大规模的 bot 农场，主要需要创建账号和运营账号两个方面。

### 


### 可能出现的问题

1. 封禁。
    1. 同一个 IP 创建账号过多触发封禁
    2. 创建成功后因为频繁更换登录 IP 出现封禁
    3. 验证码平台提供的手机号已经被人撸过一遍，无法使用
2. 账号丢失。tg 返回的授权 token 有有效期。使用验证码平台的号码肯定不可能再次接受短信找回，所以可能需要机制定时刷新 token，避免丢失账号。

### 实际遇到的问题

IP 或是 API_ID 限流

可以通过换 IP 或者放慢速度来解决。

验证码平台号码失效

多换几个试一下。。



# twitter