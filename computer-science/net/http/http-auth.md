# HTTP 认证介绍


<!--
ID: 17bb5f25-bca2-4639-a42f-4fde2df347bf
Status: publish
Date: 2017-09-04T03:39:00
Modified: 2020-05-16T11:51:04
wp_id: 580
-->


周末给一个库添加http代理的支持，发现对http basic auth不甚了解，阅读了一下相关的文档，写篇备忘。

http 中的认证主要是 basic auth 和 digest auth 两种，其中 digest auth 比较复杂，而且也没有提升安全性，已经不建议使用了。

RFC 7235 [1] 描述了客户端（通常是浏览器）和服务器如何通过http进行身份认证的一些机制。客户端和 http代理之间也可以使用 http auth 来做验证。
  
## 验证流程

1. 当客户端访问一个页面时，如果只有验证后才能访问，或者验证后有更多内容，服务器应该发送 401 Unauthorized，提出一个chanllenge，设定 `WWW-Authenticate` header，并指定验证的 type 和 realm，具体定义下文有讲。
2. 客户端这时通常应该提示用户输入密钥，一般是浏览器弹出用户名密码对话框供用户填写，然后使用`Authorization` header发送验证的密钥。如果验证通过的话，应该正常访问（200 OK），验证通过但是没有权限的话应该返回 403 Forbidden。
3. 如果验证不通过，应该服务器返回401，客户端可以重试。

注意，如果客户端已经知道需要密钥访问，那么可以在第一个请求直接发送对应的密钥，这样就避免了 401 Unauthorized。

![MDN上的流程图](https://mdn.mozillademos.org/files/14689/HTTPAuth.png)
 

## 代理验证的不同

如果代理服务器需要验证的话，流程是类似的，有两点细节不同：

1. 代理服务器应该发送407 Proxy Authentication Required 而不是 401。使用的headers也变成了 Proxy-Authenticate 和 Proxy-Authorization 。
2. 服务器的头部 WWW-Authenticate 是 end-to-end 的，也就是代理服务器不应该篡改，应该原样传递。而代理服务器的Proxy-头部是 hop-by-hop 的，也就是不能向下传递。


## 实现细节

服务器或者代理服务器随着4XX发送的头部为

```
WWW-Authenticate: <type> realm=<realm>
or
Proxy-Authenticate: <type> realm=<realm>
```

其中 type 指定了使用的验证的类型，也就是用户名和密码加密方式的不同，IANA钦定了一批方法[2]。然鹅，一般来说常用的只有两个 Basic 和 Digest。而其中 Digest 的实现可能会要求服务器明文存储密码，于是大家又angry了[3]，这里也不推荐使用。所以这里只介绍 Basic类型。

realm 指定了验证的领域，也就是说相同realm下的用户名和密码是一样的，如果你访问的两个页面在同一个realm，那么浏览器在第二次访问就不会问你密码了。


客户端发送对应的头部和密钥来获得访问权限

```
Authorization: <type> <credentials>
or
Proxy-Authorization: <type> <credentials>
```

其中，type就是刚刚的那个 Basic 或者 Digest。credentials 按照对应的方法计算。对于Basic类型 `credentials = base64(username + ':' + password)`

一个例子，假设用户名和密码分别是：aladdin和opensesame。那么客户端应该发送的header是：`Authorization: Basic YWxhZGRpbjpvcGVuc2VzYW1l`

## 需要注意的地方

1. 因为http协议本身是无状态的，所以Auth应该是无状态的，所以每次请求都应该携带。
 
2. 如果是http协议的话，对于Basic Auth，那么密码都是明文发送的，可以使用https来避免这个问题。

3. 可以使用：https://username:password@www.example.com/ 这种形式来预先输入账号密码，但是这种形式已经不鼓励了。不过在设定一些环境变量时，比如 http_proxy，也只能用这种方法来制定用户名和密码

## 参考

1. 对应的RFC https://tools.ietf.org/html/rfc7235
2. IANA 注册的auth类型 http://www.iana.org/assignments/http-authschemes/http-authschemes.xhtml
3. 为什么不要使用digest验证  https://stackoverflow.com/questions/2384230/what-is-digest-authentication
4. MDN的文章还提供了如何让apache和nginx使用basic auth https://developer.mozilla.org/en-US/docs/Web/HTTP/Authentication