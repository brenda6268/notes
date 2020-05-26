# Linux 中的 epoll 和 nginx 中的应用


ID: 417
Status: publish
Date: 2018-04-04 05:15:00
Modified: 2020-05-16 11:32:22


# epoll 的优势

select 和 poll 每次获取可读写的描述符都需要遍历所有的文件描述符，它们的时间复杂度都是 O(n)，而 epoll 是基于回调的，每个 socket 上有事件发生都会调用回调函数放到 epoll 的就序列表中，因此 epoll_wait 只需要简单地读取这个列表，所以epoll的时间复杂度是 O(1) 的。

添加监控的socket只需要使用 epoll_ctl 添加一次，而获取消息 epoll 使用 mmap 加速内核与用户态的消息传递，不需要每次都把 socket 在内核态和用户态之间考来考取。

## epoll 的工作模式

epoll 中有两个模式，水平触发（LT）和边缘触发（ET）。其中水平触发如果不做任何操作，就会一直触发，而边缘触发只会触发一次。就好比电工电子里面的两种触发模式。默认模式是 LT

Level Triggered (LT) 水平触发

1. socket接收缓冲区不为空 有数据可读 读事件一直触发
2. socket发送缓冲区不满 可以继续写入数据 写事件一直触发

符合思维习惯，epoll_wait返回的事件就是socket的状态

Edge Triggered (ET) 边沿触发

1. socket的接收缓冲区状态变化时触发读事件，即空的接收缓冲区刚接收到数据时触发读事件
2. socket的发送缓冲区状态变化时触发写事件，即满的缓冲区刚空出空间时触发读事件

仅在状态变化时触发事件

ET模式在很大程度上减少了epoll事件被重复触发的次数，因此效率要比LT模式高。epoll工作在ET模式的时候，必须使用非阻塞套接口，以避免由于一个文件句柄的阻塞读/阻塞写操作把处理多个文件描述符的任务饿死(在while循环中调用read、write、accept，若是阻塞套接字，当资源不够时，进程会被阻塞，则其他准备就绪的文件描述符得不到处理，如果是非阻塞套接字，当资源不够时，上述系统调用返回-1，同时将errno设置为EAGAIN)

LT模式下开发基于epoll的应用要简单些，不太容易出错。而在ET模式下事件发生时，如果没有彻底地将缓冲区数据处理完，则会导致缓冲区中的用户请求得不到响应。

ET处理EPOLLOUT（socket 可写事件）方便高效些，LT不容易遗漏事件、不易产生bug。如果server的响应通常较小，一次性可以写完，不需要监听EPOLLOUT，那么适合使用LT，例如redis等、或者大多数的网络库。而nginx作为高性能的通用服务器，网络流量可以跑满达到1G，这种情况下很容易触发EPOLLOUT，则使用ET。关于某些场景下ET模式比LT模式效率更好，

## nginx 中的使用

nginx 使用的是边缘触发模式

epoll 常用于构建事件驱动的非阻塞异步的事件循环，但是需要注意，本身 epoll_wait 这个操作是同步的。elect/poll/epoll的意义在于同时等待多个socket上的活动。select/poll/epoll永远都是阻塞的，跟socket是否阻塞无关。当然一般来说 epoll 管理的 socket 要设置成非阻塞的。

nginx会一直（阻塞）等待epoll返回事件通知或者epoll_wait超时，一旦有事件触发，nginx就会调用关联的（read/write）handler处理事件。开发者必须保证每一个事件handler都不得包含任何阻塞调用。否则，nginx worker的主线程将会因为一个事件阻塞，导致队列里面可能还有一大堆事件不能及时处理，这会严重影响nginx的效率。所以 nginx 的 socket不能设置为阻塞的，如果socket是阻塞的，那么一个socket的IO事件就会阻塞后续所有的事件处理，CPU就会空转，等在那里没事干了。而在socket非阻塞调用期间，nginx可以继续处理其他的事件。


# epoll 的使用

epoll 总共有三个系统调用：epoll_create, epoll_ctl, epoll_wait。其中 epoll_create 在内核中创建一个 eventpoll 结构体，epoll_ctl 增加或者删除 socket 到 epoll 中，epoll_wait 等待事件发生。


创建 epoll 文件描述符
```
int epoll_create(int size);  // size 参数会被忽略
```

添加 socket 到 epoll 对象中

```
int epoll_ctl(int epfd, int op, int fd, struct epoll_event *event);
```

1. epfd 是 epoll_create 创建的
2. op 是这三种常量，表示操作。
  1. EPOLL_CTL_ADD：注册新的fd到epfd中；
  2. EPOLL_CTL_MOD：修改已经注册的fd的监听事件；
  3. EPOLL_CTL_DEL：从epfd中删除一个fd；
3. fd，需要更改的 socket
4. events 是一些参数

监听事件

```
int epoll_wait(int epfd, struct epoll_event * events, int maxevents, int timeout);
```
一般如果网络主循环是单独的线程的话，可以用-1来等(即阻塞调用epoll_wait)，这样可以保证一些效率，如果是和主逻辑在同一个线程的话，则可以用0（立即返回）来保证主循环的效率。

参考：

1. https://blog.csdn.net/dongfuye/article/details/50880251
2. https://www.zhihu.com/question/63193746
3. epoll 详解：https://www.cnblogs.com/ljygoodgoodstudydaydayup/p/3916760.html
4. https://www.zhihu.com/question/22576054