# curio asks 源码解析

<!--
ID: 7d28f505-6ce4-4373-ae7d-979a0f518f92
Status: publish
Date: 2018-06-22T15:10:30
Modified: 2020-05-16T11:14:07
wp_id: 91
-->

asks 是 Python 的异步框架 curio 中的 一个 http 库。它基于 h11 这个库来做 http 协议的解析，然后提供了在 curio 下的 IO 操作。下面按照功能逐个介绍其中的每个部分。

## 杂项

### auth.py

该文件中主要包含了 http auth 相关函数, 支持了 Basic Auth 的 Digest Auth。值得注意的是，digest auth 作为一种既很复杂又不安全的认证方式，已经没有人用了。如果需要使用 http auth 的话，现在推荐的方式使用 https + basic auth。

### base_funcs.py

提供了一些快捷方式函数，比如 curio.get。

### cookie_utils.py

该文件主要包含了 CookieTracker， 对外的方法主要有两个 `get_additional_cookies` 用于获取域名对应的 cookie，`_store_cookies` 用于添加 cookie。

parse_cookies 函数主要用于解析 set-cookie 头部，并把解析到的 cookie 附加到 response 对象上。

### errors.py

asks 中抛出的异常的类

### http_utils.py

处理编码和压缩的两个函数。

## 请求与响应

### request_object.py

该文件中主要是定义了 RequestProcessor 类。RequestProcessor 用于生成一个 HTTP 请求。

make_request 方法。hconnection定义和使用的地方相距太远了。cookie的生成应该使用join。之后调用 _request_io 发送请求

`_request_io` 调用 首先掉用 `_send`, 然后调用 `_catch_response`

`_catch_response` 调用 `recv_event`

`_recv_event` 不断调用 `_async_lib.recv(self.sock, 10000)` 从而不断产生数据，知道读完为之

### sessions.py

session 类

request 调用 grab_connection 获取一个socket，然后把这个socket交给Request对象
grab_connection 调用 checkout_connection 获得一个socket或者，调用make_connection产生一个新的socket，注意其中有一个奇怪的 await sleep(0)，可能意思是把循环交回给event loop

make_connection 调用 `_connect` 方法，并把host和port作为属性写到socket上

session 中有两个SocketQ的类，conn_pool, checked_out_sockets 分别用来保存已连接未使用的socket和正在使用中的socket

### response_objects.py

Response 表示了一个响应。如果在发起请求的时候选择了 stream=True, response.body 会是一个 StreamBody 实例，StreamBody 用于流式处理响应。

Cookie 类表示了一个 Cookie，不知道这里为什么没有用标准库的 cookie。

## Connection Pool

如果使用代理的话

### req_structs.py

SocketQ 是一个 socket 的连接池。使用一个 deque 作为存储，实际上相当于又模拟了一个字典  `{netloc => socket}`（思考：为什么不使用OrderedDict呢？）`index` 返回指定 hostloc 对应的 index。`pull` 弹出指定 index 的 socket。`__contains__` 遍历看是否包含对应的socket。需要注意的是这个类不是线程安全的，不过对于 curio 来说，线程安全似乎无关紧要，毕竟只有一个线程。

CaseIncesitiveDict 是一个对大小写不敏感的词典，直接从 requests 里面拿过来的。

## curio 的网络通信

首先，需要引入curio.socket 而不是使用内置的socket

TCP通信，使用 `sock.bind/listen/accept` 等建立服务器，使用recv和sendall发送接收消息。
UDP通信，使用recvfrom和sendto函数通信

作为客户端使用 curio.open_connection 打开到服务器的链接，其中 ssl=True打开的是HTTPS连接诶

对于其他要使用ssl的情况，应该使用curio.ssl而不是标准库的ssl

curio.network.


ssl.wrap_socket 不支持server_hostname sslcontext.wrap_socket 支持

不要把 proxy 传递给 request 对象

## 添加 http 代理支持

asks 把繁重的 http 解析工作都用 h11 这个库巧妙的解决了，所以 asks 本身是非常轻量的一个库。很遗憾的是，在 asks 中尚未支持代理，下面我们尝试为 asks 增加 http 代理的支持 :P

在 http 代理模式中，每个请求都需要添加上 Proxy-Authorization 的 Header。而在 https 请求中，只有 Connect 的时候需要添加上 Proxy-Authorization 的 Header。

代理的 socket 池和真正的 socket 池要分开，这样设计还简单一点。