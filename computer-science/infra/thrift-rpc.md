# Thrift RPC 框架


wp_id: 549
Status: publish
Date: 2017-06-23 15:45:00
Modified: 2020-05-16 11:44:07


Thrift 是一个全栈的 RPC 框架，它包含了接口定义语言（IDL）和RPC服务两部分，大概相当于 protobuf + gRPC 的功能。

# 安装

可以使用 https://github.com/yifeikong/install 中的脚本来安装

# Thrift 中的类型与 IDL

包括 `bool, byte/i8, i16, i32, i64, double, string, binary`。

- 比较蛋疼的是 thrift 不支持 uint，原因是好多语言里面没有原生无符号类型（无语。。）
- binary 类型相当于某些语言中的 bytes
- string 使用 utf-8 编码
- byte 和 i8 是同一个类型，也是有符号的


##  复合类型（struct）

struct 就像编程语言中的结构体或者类一样，用来自定义类型。注意在 Thrift 中定义类型的时候需要使用数字标记顺序，这样是为了更高效地序列化。

注意其中的 required 和 optional 字段，required 表示必选的字段，optional 的字段可以忽略。为了兼容性考虑，建议尽可能把字段声明为 optional。

```
struct Cat {
    1: required i32 number=10;  // 可以有默认值
    2: optional i64 big_number;
    3: double decimal;
    4: string name="thrifty";  // 字符串也可以有默认值
}
```

## exceptions

Thrift 中还可以定义异常，关键字是 exception，其他语法和 struct 一样。

## typedef

Thrift 支持 C/C++ 类型的 typedef

```
typedef i32 MyInteger   // 1
typedef Tweet ReTweet   // 2
```

## 枚举

```
enum Operation {
    ADD = 1;
    SUB = 2;
    MUL = 3;
    DIV = 4;
}
```

## 容器类型

Thrift 中包含了常见的容器类型 `list set map` 等。

- `list<t1>`: 一个t1类型的有序数组
- `set<t1>`: 一个t1类型的无需集合
- `map<t1,t2>`: 一个字典，key 是 t1 类型，value 是 t2 类型

## 常量

使用 const 定义常量

```
const i32 INT_CONST = 1234;    // 1
const map<string,string> MAP_CONST = {"hello": "world", "goodnight": "moon"}
```

## 注释

Thrift 支持 Python 和 C++ 类型的注释。

```
# This is a valid comment.

/*
 * This is a multi-line comment.
 * Just like in C.
 */

// C++/Java style single-line comments work just as well.
```

##  命名空间
for each thrift file, you have to add a namespace for it.

```
namespace py tutorial
namespace java tutorial
```

## include
include "other.thrift"

# 服务

服务类似于一个接口，在 Thrift 中定义，然后根据 Thrift 生成的文件，再使用具体的代码实现。

注意其中的 `oneway`, 意思是客户端不会等待响应。

```
service StringCache {
    void set(1:i32 key, 2:string value),
    string get(1:i32 key) throws (1:KeyNotFound knf),
    oneway void delete(1:i32 key)
}
```
## 生成的代码

Thrift 的整个网络架构如图：

![](https://ws4.sinaimg.cn/large/006tKfTcgy1fslz611nmfj30y40igdj2.jpg)

生成的代码位于蓝色的一层，Transport 实现了二进制数据的传输，我们可以选择 TCP 或者 HTTP 等协议传输我们的数据。也就是Processor。Protocol 层定义了如何把Thrift内部结构的数据序列化到二进制数据，或者反过来解析，可以使用 JSON、compact 等转换方法。Processor 负责从 Protocol 中读取请求，调用用户的代码，并写入响应。Server 的实现可以有很多中，比如多线程、多进程的等等。

Processor 的定义：

```
interface TProcessor {
    bool process(TProtocol in, TProtocol out) throws TException
}
```

Server 的具体工作：

- 创建一个 Transport 用于传输数据
- 为这个Transport创建输入输出的 Protocol 
- 基于上面的 Protocol 创建 Processor
- 等待客户端请求，并且把收到的请求交给 Processor 处理，一直循环下去。


# 编译

```
thrift -r --gen py file.thrift
```

编译好的文件在 gen-py 目录下

- `-r` 表示递归编译
- `--gen` 指定要生成的语言

# 一个例子


handler 对应实现 service
Server 中使用 Handler

Python的 server 和 client 


# 常见问题

YN: 线程安全性

1. thrift默认提供了thread/process 等不同的server类型, 需要考虑handler的线程安全问题
2. thrift client不是线程安全的, 在多线程程序中使用需要注意(http://grokbase.com/t/thrift/user/127yhv7wmx/is-the-thrift-client-thread-safe)
3. 看一下pyutil中是如何使用的...


何时需要一个 thrift 服务呢？而不是封装一个类或者 dal 来操作？

1. 跨语言，跨代码库的调用
2. 需要维持一个很重的资源的服务

如果只是同一个语言内，需要读写一些数据库之类的，封装成一个类就可以了

Const应该定义在哪儿？

如果是一个需要在调用过程中使用的常量，使用 thrift，如果是在数据库中存储，使用在代码中定义的常量

## Thrift vs http api

A few reasons other than speed:

1. Thrift generates the client and server code completely, including the data structures you are passing, so you don't have to deal with anything other than writing the handlers and invoking the client. and everything, including parameters and returns are automatically validated and parsed. so you are getting sanity checks on your data for free.
2. Thrift is more compact than HTTP, and can easily be extended to support things like encryption, compression, non blocking IO, etc.
3. Thrift can be set up to use HTTP and JSON pretty easily if you want it (say if your client is somewhere on the internet and needs to pass firewalls)
4. Thrift supports persistent connections and avoids the continuous TCP and HTTP handshakes that HTTP incurs.
	
Personally, I use thrift for internal LAN RPC and HTTP when I need connections from outside.


# 参考

1. https://stackoverflow.com/questions/9732381/why-thrift-why-not-http-rpcjsongzip
2. https://thrift-tutorial.readthedocs.io/en/latest/usage-example.html#a-simple-example-to-warm-up
3. http://thrift-tutorial.readthedocs.io/en/latest/index.html
4. https://diwakergupta.github.io/thrift-missing-guide/
5. http://thrift.apache.org/tutorial/py