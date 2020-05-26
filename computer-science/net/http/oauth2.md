# OAuth2 协议详解


ID: 582
Status: publish
Date: 2018-07-15 04:41:00
Modified: 2020-05-16 11:17:53


今天有个项目需要用到 OAuth2 来处理一些东西，然而中文互联网有时候真是很难找到像样的文档，搜索 “OAuth 教程” 的到排名前两位的[教](https://aaronparecki.com/oauth-2-simplified/)[程](https://aaronparecki.com/oauth-2-simplified/)都是翻译自一个英文教程，翻译质量奇差无比就不说了，这个英文教程本身就是有问题的，无奈只好搜索 “OAuth tutorial” 才找到几个看得过去的英文教程，总结一下放在这里，算是为中文互联网引入一些正确的知识。

看到 OAuth2 这个词，一般人肯定会想，是不是还有个 OAuth 1 协议呢？是的，有 OAuth 1 协议，但是因为协议搞得太复杂了，所以没人用，市面上的基本都是根据 OAuth 2 来的。既然实际只有一个 OAuth，以下就简称 OAuth 了。

# 为什么要使用 OAuth —— 一个例子

大家最熟悉的例子就是第三方登录了。假设有个论坛叫做“91论坛”你没有注册过，也懒得填写邮箱，然后验证邮箱注册，那么这时候可以使用 QQ 登录，当然国外可能是 Facebook。那么问题来了，当你点击 “用 QQ 登录” 这个按钮的时候，论坛怎么安全地知道你使用的是哪个 QQ 号呢？会有下面几个问题：

1. 如果你随便输入一个 QQ 号，然后91论坛就信任了，那么你就可以伪造任意的 QQ 用户了，所以论坛需要去向 QQ 验证你是否是你提供的 QQ 号的所有者。
2. 你可以提供给论坛你的 QQ 号和密码，这样论坛使用你的 QQ 号和密码测试一下能否登录就可以了，但是这样论坛就有了你QQ号的所有权限，如果论坛偷偷在你的 QQ 空间发推广消息呢？所以你不希望直接把 QQ 号和密码都告诉论坛。
3. 现在陷入了两难境界，论坛无法信任你只提供 QQ 号，你也不能信任论坛拿走你的账户密码。如果这时候能让 QQ 作为中间人只提供给论坛部分信息就好了，OAuth 就是用来做这个的。

# OAuth2

简单来说，方案如下：

1. 91 论坛在QQ上注册一个app
2. 用户在QQ上登录，通过跳转，把一个一次性授权码给 91 论坛
3. 论坛利用这个授权码获得 access token，然后利用这个 token 读取用户信息

具体解决方案如下：

1. 91论坛的开发者在 QQ 处申请一个开发者账户，获得一个开发者标识，并提供了一个回调接口：

    ```
    {
        'client_id': 91bbs,
        'client_secret': 123456,
        'callback': "http://91bbs.com/login_callback"
    }
    ```

2. 你在91论坛上点击用 QQ 登录，然后页面跳转到 QQ 域(qq.com)下，这样你可以安全的输入 QQ 密码，而不用被91论坛知道。

    用 QQ 登录对应的地址：

    ```
    https://api.qq.com/v1/auth?
    response_type=code&
    client_id=91bbs&
    callback=http://91bbs.com/login_callback&
    scope=read
    ```

    注意其中标识了论坛在上一步 client_id。在这个页面上可能写着你是否授权XX论坛访问你的个人信息等等。

    1. response_type 表示授权的类型，后面会讲到
    2. client_id 向 QQ 表明是要登录91论坛这个网站
    3. callback 指明了下一步QQ要回调91论坛的地址
    4. scope 指定了当前授权的权限范围

3. 登录QQ后，点击授权通过，然后 QQ 会把你重定向到 redirect_uri 对应的页面，并附加参数 code=xxx，这个是一个临时的一次性授权码。

    重定向到的页面：

    ```
    http://91bbs.com/login_callback&code=xxxxxx
    ```

4. 访问这个页面，就会把这个 code 传递给91论坛，但是91论坛有了这个 code 还不能直接向 QQ 询问关于你的具体信息。
5. 91论坛使用这个 code 向 QQ 申请一个 access token，使用这个 access token 就可以获取你的 QQ 号等信息，具体获得什么信息，是在第二步的 scope 页面指定的。

    访问：
    ```
    POST https://api.qq.com/v1/token
    grant_type=authorization_code&
    code=AUTH_CODE_HERE&
    redirect_uri=REDIRECT_URI&
    client_id=CLIENT_ID&
    client_secret=CLIENT_SECRET
    ```

    注意其中的参数：
    1. grant_type 指定了授权的类型，这里我们使用上一步获得的 authorization code 来获取 access token，所以grant type 就是 authorization code
    2. code 就是上一步获得的 authorization code
    3. 其他参数和上一步类似

    QQ 返回给 91 论坛的信息：
    ```
    {
        "access_token":"ACCESS_TOKEN",
        "token_type":"bearer",
        "expires_in":2592000,
        "refresh_token":"REFRESH_TOKEN",
        "scope":"read",
    }
    ```

    因为这个 access token 可以随时用来访问你的信息，所以设定了过期时间，这样即使泄露了攻击的时间窗口也不会很长。

6. 91论坛使用 access token 访问你的信息。access token 通常是放在 [Authorization](https://developer.mozilla.org/en-US/docs/Web/HTTP/Headers/Authorization) 这个 header 中。

    比如使用 curl 来表示这个访问：

    ```
    curl -H 'Authorization: Bearer 1.1Zgwxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx=' \
    'http://api.qq.com/v1/user/123456'
    ```

    如果 token 正确无误的话，QQ 服务器会返回相应的信息。

6. 论坛根据从 QQ 服务器得到的消息，从而知道你真的是 QQ 为 123456 的用户，然后为你创建账户。以后你需要登录也可以重复上面的流程，证明你的确是 QQ 123456 的用户就可以了。

# OAuth 中的术语

在上面的过程中，一共出现了四中角色：

1. 第三方程序，也就是 91论坛
2. 资源所有人，也就是用户
3. 授权服务器，也就是 QQ
4. 资源服务器，还是 QQ

其中资源指的就是用户的 QQ 信息，而授权服务器和资源服务器在复杂的结构中往往是分开的。

# 其他的授权类型

除了上面说过授权类型之外，还有一些微小差异的授权类型，比如 implict 授权，这里不再赘述。

除此之外，还可以直接使用账户密码获得 access token，方法比较简单，一般用于官方客户端直接登录：

```
POST https://api.authorization-server.com/token
  grant_type=password&amp;
  username=USERNAME&amp;
  password=PASSWORD&amp;
  client_id=CLIENT_ID
```

当 access token 过期后，还可以使用 refresh token 刷新，获得新的有效的 access token，而不需要用户再次登录。虽然 refresh token 没有过期时间，或者过期时间远比 access token 长，但是因为使用次数少，所以也是相对比较安全的。

```
POST https://cloud.digitalocean.com/v1/oauth/token?
grant_type=refresh_token&amp;
client_id=CLIENT_ID&amp;
client_secret=CLIENT_SECRET&amp;
refresh_token=REFRESH_TOKEN
```

# 参考

1. [OAuth2 Simplified](https://aaronparecki.com/oauth-2-simplified/)
2. [Introduction to OAuth2](https://www.digitalocean.com/community/tutorials/an-introduction-to-oauth-2)
3. [Refresh token](https://medium.com/@bantic/more-oauth-2-0-surprises-the-refresh-token-1831d71f4af6)