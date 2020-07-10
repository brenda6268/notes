# TCP 连接的状态

比较重要的几个有：

1. Listen。这个是服务器在监听端口，准备服务
2. Established。连接已经建立的状态
3. CloseWait。连接关闭时，被动关闭端发送 ACK 后，发送 FIN 之前，还在发送数据的状态
4. TimeWait。主动关闭端在发送最后一个 ACK 之后会进入 TimeWait 状态。
5. Closed。关闭是默认状态

TimeWait 状态的时间是两个 MSL，是为了保证被动关闭端一定接收到了最后的 ACK：

1. 确保"主动关闭"端最后发出的 ACK 到达"被动关闭"端
2. 保证新 tcp 连接和老 tcp 连接不会干扰

## 服务器发生大量的 CLOSE_WAIT 和 TIME_WAIT 的解决方法

如何查看服务器上各个状态的链接个数呢？

```sh
netstat -ant | awk '/^tcp/ {++S[$NF]} END {for(a in S) print a, S[a]}'  

TIME_WAIT 856
CLOSE_WAIT 1
FIN_WAIT1 1
ESTABLISHED 666
SYN_RECV 2
LAST_ACK 1
```

### TIME_WAIT 过多

TIME_WAIT 是主动关闭端的状态。如果服务器上出现大量的这种状态，有两种可能：

1. 如果服务器是请求的发起端，比如说爬虫，那么可能是请求太多了
2. 如果服务器是服务端，那么可能是受到了攻击，或者客户端的问题。对于 HTTP 1.0 服务器来说，应该是服务器主动关闭连接，所以服务器有可能处在 TIME_WAIT 状态过多。但是 HTTP 1.1 实际上默认使用了 Keep-Alive, 所以不会产生太多的 TIME_WAIT.

修改下系统的参数就可以了。  

```
#表示开启重用。允许将 TIME-WAIT sockets 重新用于新的 TCP 连接，默认为 0，表示关闭
net.ipv4.tcp_tw_reuse = 1
```

### CLOSE_WAIT

CLOSE_WAIT 是被动关闭端的状态，所以是对方关闭连接之后服务器程序自己没有进一步发出 ack 信号，也就是没有响应主动关闭端的 FIN

### SYN Flood 攻击

攻击者发送大量的 SYN 包给服务器打开链接，但是不响应 ACK，导致服务器上出现大量的半打开状态的 TCP 连接，导致服务器的 SYN queue 充满，从而无法接受新连接。

启用 SYN Cookies 之后，服务器照常接受连接，但是不缓存连接，而是根据客户端信息生成一个特殊的初始序列号叫做 SYN Cookies。也就是根据客户端的 IP 和 MSS 来加密生成初始的序列号，而不要直接从 1 开始。如果是正常用户，则可以根据返回的序列号重新构建出 SYN queue。

SYN Cookies 的具体算法：

> top 5 bits: t mod 32, where t is a 32-bit time counter that increases every 64 seconds;
> next 3 bits: an encoding of an MSS selected by the server in response to the client's MSS;
> bottom 24 bits: a server-selected secret function of the client IP address and port number, the server IP address and port number, and t.

内核配置 (/etc/sysctl.conf)：

```
#表示开启 SYN Cookies。当出现 SYN 等待队列溢出时，启用 cookies 来处理，可防范少量 SYN 攻击，默认为 0，表示关闭
net.ipv4.tcp_syncookies = 1
```

## 参考

1. 文章比较老，有些不太实用了 https://blog.csdn.net/shootyou/article/details/6622226
2. https://cr.yp.to/syncookies.html
3. http://www.firefoxbug.com/index.php/archives/2795/
4. https://blog.huoding.com/2016/01/19/488
5. https://mp.weixin.qq.com/s?__biz=MzI4MjA4ODU0Ng==&mid=402163560&idx=1&sn=5269044286ce1d142cca1b5fed3efab1&3rd=MzA3MDU4NTYzMw==&scene=6#rd
6. https://mp.weixin.qq.com/s?__biz=MjM5NzUwNDA5MA==&mid=200667929&idx=1&sn=67cada895ac100115fded319b6b23a21&3rd=MzA3MDU4NTYzMw==&scene=6#rd