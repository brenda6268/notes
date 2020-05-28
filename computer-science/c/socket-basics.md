# 基础 socket 编程


wp_id: 406
Status: publish
Date: 2017-05-30 03:28:00
Modified: 2020-05-16 11:58:28


创建与使用 socket, 一个 echo server 和 client

socket 客户端的四个步骤: 

1. 使用 socket 函数创建连接
2. 使用 connect 连接到服务器
3. 使用 send 和 recv 接收和发送消息
4. 使用 close 关闭连接

第一步 创建一个 TCP socket
int sock = socket(AF_INET, SOCK_STREAM, IPPROTO_TCP);
返回的 sock 可以看做一个 handle, 本质上是一个文件描述符( file descriptor) , 小于0表示错误

表示 socket 地址的结构 sockaddr_in, 其中 in 表示 internet, 不是input

```
struct sockaddr_in {
	__uint8_t	sin_len;
	sa_family_t	sin_family;
	in_port_t	sin_port;
	struct in_addr    sin_addr;
	char		sin_zero[8];
};
```

其中 sin_family和 sin_port和 sin_addr.s_addr 字段必须填写

使用 inet_pton把 IP 字符串转化为32位整形
端口号需要使用 htons 转化

下一步就是连接了, 注意 connect 和好多函数都要求把参数从 sockaddr_in 转化到 sockaddr, 然后再跟一个参数表示实际的数据结构的长度. 这是因为 C 不支持多态.

第三步就是发送和接收数据, 我们使用 send 函数发送, send成功的话会返回发送成功的数据的长度, 可能和指定的数据不等, 因此需要判断是否发送成功. recv 也可能返回任意长度的数据, 因此需要在一个循环里接受. send 和 recv 都是阻塞的

```
int send(int socket, const void* buffer, size_t length, int flags);
int recv(int socket, const void* buffer, size_t length, int flags);
```

最后关闭连接

需要特别注意的是, 永远不要把来自其他主机的消息使用 pritnf 等不安全的函数打印出来

socket 服务器的四个流程

1. 使用 socket 函数创建链接
2. 使用 bind 函数绑定端口号
3. 使用 listen打开监听模式
4. 使用 accept 接收新的客户, 并为之服务
    a.  accept 会为每个客户创建新的 socket
    b. 通过这个 socket 与客户端之间 send/recv
    c. 关闭该 socket
5. 关闭监听的 socket

第一步,创建 socket, 和客户端完全一样
注意, 服务端的地址有所不同, 为了接受任何一个客户, 我们需要监听服务器的所有 IP (服务器可能有多个网卡, 也就有多个 IP).

第二步, 使用 bind 绑定到对应的 ip 和端口号, listen 把 socket 设定为监听状态. 注意 listen 还有一个参数代表

第三步, 使用 accept 开始阻塞地等待客户端. 注意 accept 实际上有两个返回值,一个通过函数返回的形式返回一个客户端的 socket, 还有一个通过指针的形式返回一个 sockaddr_in

第四步,接下来, 把每一个获得的 client socket 都对应地处理

关闭主 socket

最后需要注意的是, 

1. 用到的一些转化函数

inet_pton/inetntop htons, ntohs, htonl, ntohl

2. socket  为地址定义了通用的数据结构 sockaddr, 也就是 sockaddr_in 等结构应该看作是 sockaddr 的子类. 在 connect 和 bind 等函数中的参数都是 sockaddr* 以及实际数据类型的 size.

# 使用 UDP socket

相比来说, UDP 就非常简单了, 相对于 TCP 在 IP 层之上提供个各种服务, UDP 只添加了两项, 端口号和校验, 而且只是简单地把校验出错的包丢掉.