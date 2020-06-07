# 序列化协议的选择 json vs msgpack vs thrift vs protobuf


wp_id: 594
Status: publish
Date: 2018-07-14 19:45:00
Modified: 2020-05-16 11:17:14


当我们的程序需要保存一些对象到硬盘上供下次运行时使用，或者需要和其他程序交换数据
的时候，需要把对象用某种方式编程二进制字符串然后保存到硬盘上或者发送出去，这种方
法我们一般称作序列化。序列化有很多不同的方法, 一般考虑三个方面：

1. 速度，序列化和反序列化的速度越快越好
2. 体积，序列化之后的文件体积越小越好
3. 跨语言，序列化能够支持的语言越多越好

下面考察几种序列化的方法

1. 语言内置的序列化。比如 Python 的 pickle，显然这种协议只能在一种语言内部使用，
   而且对于Python来说，甚至不同版本的 pickle 协议都是不兼容的。
2. json / xml。这两个都可以把对象序列化成人类可读的字符串的形式，但是序列化后之
   后体积都变大不少，而且性能也不好，适合于简单的场景。另外一点就是 json 不能定
   义 schema（接口规范），*在大型项目中 schema 是必须的*。
3. msgpack 序列化之后的体积也比较紧致，但是同样不能定义 schema。
3. 专门的序列化库。比如 protobuf/thrift。这些库都支持多个语言，需要预先定义
   schema, 并且把对象序列化成二进制的模式，性能也都不错，所以我们重点关注一下。

考虑到需要定义接口规范，所以我们只考虑 thrift 和 protobuf 两种

Thrift 的缺点：

- 不支持 uint64。
- 查过一些文档之后，发现 thrift 的性能差于 pb。

所以先淘汰了 thrift。我们选择 protobuf

## 编译步骤放在哪里？

protobuf 和 thrift 两个的用法都是先定义 IDL（接口）文件，然后由编译器编译生成对应的语言
的代码。对于 C++ 这样的编译语言来说问题不大，我们可以把 IDL 编译的过程放到
makefile 里面去，但是对于 Python 这种没有编译的动态语言就尴尬了。具体来说，IDL
文件是需要提交到代码仓库的，但是生成的 Python 代码需不需要呢?

1. 不提交，在运行之前多一个编译步骤，不过可以把编译这一步写到 dockerfile 里面
2. 提交，这样会造成提交的代码冗余，相当于把二进制文件提交到了仓库

所以我还是倾向于只向代码库中提交 `*.proto` 或者 `*.thrift` 源文件，而不提交编译过后的文件。

# Protobuf

## 基本语法

protobuf 现在有两个主流版本，显然 proto2 要被逐渐废弃，本文使用的是 proto3。

```
syntax = "proto3";
package foo.bar;
import "myproject/other_protos.proto";

message SearchRequest {
  string query = 1;
  int32 page_number = 2;
  int32 result_per_page = 3;
  enum Corpus {
    UNIVERSAL = 0;
    WEB = 1;
    IMAGES = 2;
    LOCAL = 3;
    NEWS = 4;
    PRODUCTS = 5;
    VIDEO = 6;
  }
  Corpus corpus = 4;
}

message SearchResponse {
  repeated Result result = 1;
}

message Result {
  string url = 1;
  string title = 2;
  repeated string snippets = 3;
}
```

上面的结构和 C 语言的 struct 定义很像。

1. message 关键字用于声明一个结构，后面加结构的名字
2. protobuf 3 不支持默认值。
3. 类型。protobuf 中定义的标量类型有 double/float/int32(64)/uint32(64)/bool/string/bytes.
   其中 bytes 用来表示任意的二进制字符串
4. 序号，每个字段后面的数字表示的是序号。protobuf 用这个序号来进行高效编码，需要
   注意的是，如果要增添字段不能复用已有的序号。
6. 枚举。可以使用 enum 关键字定义枚举。枚举可以定义在 message 的外面或者里面
7. 在一个文件中可以定义多个 message。像是 enum 一样，message 也可以嵌套在另一个
   message中。比如可以把上面的 Result 嵌套在 SearchResponse 中。不过这时候再引用
   Result，需要使用 SearchResponse.Result
8. message 中可以使用另一个 message 作为类型。
9. 使用 import 语句来引入其他的 proto 文件。这样就可以直接使用引入
10. package 语句用来声明定义的 message 所处的命名空间（namespace)

## 编译

### 在 Python 中使用

ParseFromString: 从字符串中解析protobuf对象. 虽然这个方法名字中包含了string，但是实际上使用的是 bytes。

```
r = SearchResponse()
r.ParseFromString(data)
```

SerializeToString: 序列化成字符串。同样使用 bytes。

```
data = r.SerializeToString()
```

属性可以直接访问和设置，如果属性名或者类型出错会抛出异常。

repeated 类型的基础类型属性可以像一个数组一样访问，map 类型可以像字典一样访问。但是赋值必须通过 append 和 extend 赋值，而不能直接赋值.

repeated 类型的 message 类型不能使用 append，而必须使用 add 或者 extend 方法。这样可以确保 message 类型被拷贝进去。


# REF

1. https://tech.meituan.com/serialization_vs_deserialization.html
2. https://my.oschina.net/fir01/blog/468123
3. http://colobu.com/2015/01/07/Protobuf-language-guide/
4. https://developers.google.com/protocol-buffers/docs/pythontutorial
5. [在 Python 中使用 ProtoBuf](https://blog.csdn.net/losophy/article/details/17006573)
6. https://developers.google.com/protocol-buffers/docs/reference/python-generated