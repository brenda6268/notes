# TCP 握手常见考点

<!--
ID: 3b14e68d-27e5-4034-b206-a439a19239db
Status: publish
Date: 2017-05-29T11:47:00
Modified: 2020-05-16T12:07:42
wp_id: 419
-->

## 连接建立

![图挂了](https://tva1.sinaimg.cn/large/006tKfTcly1ftppcaaoz7j30i40bdgn0.jpg)

上面的图说的已经很好了，不再赘述。

### 为什么需要三次握手

这主要是为了防止已失效的连接请求报文段突然又传送到了服务端，服务端建立一个新的连接，因而产生错误。

所谓已失效的连接请求报文段是这样产生的。A 发送连接请求，但因连接请求报文丢失而未收到确认，于是 A 重发一次连接请求，成功后建立了连接。数据传输完毕后就释放了连接。

现在假定 A 发出的第一个请求报文段并未丢失，而是在某个网络节点长时间滞留了，以致延误到连接释放以后的某个时间才到达 B。本来这是一个早已失效的报文段。但 B 收到此失效的连接请求报文段后，就误以为 A 又发了一次新的连接请求，于是向 A 发出确认报文段，同意建立连接。假如不采用三次握手，那么只要 B 发出确认，新的连接就建立了。

由于 A 并未发出建立连接的请求，因此不会理睬 B 的确认，也不会向 B 发送数据。但 B 却以为新的运输连接已经建立了，并一直等待 A 发来数据，因此白白浪费了许多资源。

采用 TCP 三次握手的方法可以防止上述现象发生。例如在刚才的情况下，由于 A 不会向 B 的确认发出确认，连接就不会建立。

### 如果在 TCP 第三次握手中的报文段丢失了会发生什么情况？
Client 认为这个连接已经建立，如果 Client 端向 Server 写数据，Server 端将以 RST 包响应，方能感知到 Server 的错误。

## 链接释放

![图挂了](https://tva1.sinaimg.cn/large/006tKfTcly1ftppdqkfzij311g0rok0s.jpg)

需要注意的是，TCP 是全双工的协议，因此链接建立之后就没有客户端服务器的概念了，两边是对等的，都可以释放链接

MSS（最长报文长度）, 由两端的较短值决定，在以太网中的典型值为 1460, 是以太网的 MTU(1500) 减去 IP 的头部 40B 得到的。

![图挂了](https://tva1.sinaimg.cn/large/006tKfTcly1ftpt8b0upyj30f40lc765.jpg)

### 为什么需要 TIME_WAIT 状态

首先是另一个概念 MSL, 最长报文生命周期，在 BSD 系统上一般设定为 30s, 不过可以长到 2min。TIME_WAIT 状态的时间设定为 2MSL。

TIME_WAIT 是主动关闭端进入的状态，发送完最后一个 ACK 之后进入 TIME_WAIT 状态等待 2MSL 才进入 CLOSED 状态

TIME_WAIT 状态存在的两个理由：
1. 可靠地实现 TCP 全双工链接的终止；假如对方没能收到最后一个 ACK, 那么他将会重新发送 FIN, 这时候如果客户端已经关闭了显然不能再次回复 ACK 了。
2. 保证上一个相同连接的数据包已经在网络上消失；如果一个新的链接建立在了同一个端口上，那么他将可能收到上一个进程的数据包，这是我们为老连接保留了 2MSL 的 TIME_WAIT 值，那么就可以保证原有的链接都不存在网络上了。
### 如果服务端主动关闭链接，也需要等待两个 MSL，那么重启服务器怎么绑定原有端口？

主动关闭链接端相应的端口会在 2 MSL 内处于 TIME-WAIT 状态而不能用。如果是客户端，那么问题不大，客户端一般会重新使用一个新的端口。如果是在服务端，因为服务端使用的都是常用端口，不能改变，也就是需要等待两个 MSL 才能使用刚拿的端口，比如 Nginx 重启，内核会显示当前端口是 busy 的，不能使用，等待 4min 显然是不现实的。为了解决这个问题，可以强制复用端口，在创建 socket 的时候使用 SO_REUSEADDR 就可以了。不过需要注意的是，SO_REUSEADDR 仅对 TIME_WAIT 状态有用，如果 socket 在其他状态，是不能复用的。注意不是 SO_REUSEPORT。

## 其他

### 多个进程绑定同一个端口

我们知道一个同一个端口只有一个进程可以 bind 成功，那么 web 服务器是如何做到多进程呢？传统方法是在主进程使用 listen 然后在其他进程使用 accept 接受链接。不过这样会导致当有链接来的时候，所有的进程都会被唤醒，影响性能。在 3.9 内核之后，添加了 SO_REUSEPORT 属性，可以使用 SO_REUSEPORT 让每一个进程有当单独的监听队列，这样当有链接来的时候，内核只会唤醒一个进程。

### 当网络断开时，TCP 链接会断开吗？

TCP 链接有 keepalive 的功能，需要手动打开，但是一般来说没有人用。所以可以认为一般情况下，当物理网络断开时的时候，如果仅考虑 TCP 层，那么这个链接永远不会断开。不过一般来说，通过其他层面会知道这个链接断开了。比如说一般的应用层协议都会有心跳包的机制，这样就可以知道链接断开了。

![](https://img-blog.csdn.net/20150907214517068)

## 参考

1. https://serverfault.com/questions/329845/how-to-forcibly-close-a-socket-in-time-wait
2. http://www.unixguide.net/network/socketfaq/4.5.shtml
3. https://blog.csdn.net/Yaokai_AssultMaster/article/details/68951150
4. https://www.zhihu.com/question/53672815
5. https://blog.qiusuo.im/blog/2014/09/14/linux-so-reuseport/
6. https://blog.csdn.net/xy010902100449/article/details/48274635
7. https://www.nginx.com/blog/socket-sharding-nginx-release-1-9-1/