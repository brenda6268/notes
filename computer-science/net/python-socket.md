# Python 中的基础网络编程和SSL


ID: 415
Status: draft
Date: 2018-06-22 09:30:00
Modified: 2020-05-16 11:13:21


socket 模块提供了 C 中 socket 相关函数的封装。

socket.create_connection 高阶的socket函数，用于打开一个链接

socket.dup() duplicate the socket


## ssl 模块

提供了`ssl.SSLSocket`, 这个类是`socket.socket`的一个子类。但是通过这个socket发送和接收自动使用了SSL加密解密

提供了`ssl.SSLContext`类，这个类提供了设定SSL的参数的上下文。使用 `ssl.create_default_context` 可以创建默认的context

两个比较重要的函数

`ssl.wrap_socket(sock, **kwargs)` 会创建一个默认的context，然后使用，返回一个SSLSocket


一键生成证书支持: 

http://www.cnblogs.com/gordon0918/p/5409286.html