# 字符串和 bytes 操作


<!--
ID: 24a37b62-8ea8-4033-aed7-03f07854fdaf
Status: publish
Date: 2018-07-15T05:00:00
Modified: 2020-05-16T11:19:14
wp_id: 730
-->


Go 语言中的字符串并没有很多原生方法，需要使用 `strings` 和 `bytes` 模块来操作。strings 模块
假定字符串是 utf-8 编码的。

## 字符串操作的函数

函数签名                                             | 说明
-----------------------------------------------------|---------
`func Compare(a, b string) int`                      | 按照字典序比较两个字符串的大小
`func Contains(s, substr string) bool`               | 是否包含字符串
`func ContainsAny(s, chars string) bool`             | 是否包含字符串中的任意一个字符
`func Count(s, substr string) int`                   | 计算子串出现的次数
`func EqualFold(s, t string) bool`                   | 是否在 Unicode Case Fold 意义下等价
`func Fields...(s string) []string`                  | 返回按照 unicode.IsSpace 中的字符分隔出来的 slice
`func HasPrefix(s, prefix string) bool`              | 匹配前缀
`func HasSuffix(s, suffix string) bool`              | 匹配后缀
`func Index...(s, substr string) int`                | 子串在字符串中的位置，没找到返回 -1
`func Join(a []string, sep string) string`           | 连接字符串
`func LastIndex...(s, substr string) int`            | 反向查找
`func Map(mapping func(rune) rune, s string) string` | 对每一个 rune 应用mapping函数，如果 mapping 返回负值就忽略掉这个字符
`func Repeat(s string, count int) string`            | 把源字符串重复 n 次
`func Replace(s, old, new string, n int) string`     | 替换源字符串中的值
`func Split...(s, sep string) []string`              | 按照 sep 作为分隔符，把字符串分开
`func Title(s string) string`                        | 转换成 Title Case
`func ToLower...(s string) string`                   | 转换成小写
`func ToUpper...(s string) string`                   | 转换成大写
`func Trim...(s string, cutset string) string`       | 删掉两边的字符

## 字符串相关 struct

strings.Builder 用来拼接字符串，类似于 Java 中的 StringBuilder。strings.Builder
包含了 Write 方法，也就是说实现了 io.Writer 的接口，因此可以直接向其中写入内容。

```
var b strings.Builder
for i := 3; i >= 1; i-- {
    fmt.Fprintf(&amp;b, "%d...", i)
}
b.WriteString("ignition")
fmt.Println(b.String())

3...2...1...ignition
```

函数签名                                               | 说明
--------                                               | ---------
`func (b *Builder) Grow(n int)`                        | 预分配内存，避免多次分配
`func (b *Builder) Len() int`                          | 长度
`func (b *Builder) Reset()`                            | 重置回 0
`func (b *Builder) String() string`                    | 转换成字符串
`func (b *Builder) Write(p []byte) (int, error)`       | 写入 bytes
`func (b *Builder) WriteString(s string) (int, error)` | 写入 string

strings.Reader 实现了 io.Reader、io.ReaderAt, io.Seeker, io.WriterTo, io.ByteScanner, and io.RuneScanner 等一系列的接口。主要用来把字符串转换成一个满足对应接口的类型。传递个接受对应 interface 的函数。

函数签名                           | 说明
--------                           | ---------
`func NewReader(s string) *Reader` | 从指定字符串构建一个 Reader


## strconv

strconv 包包含了把一些字符串转换相关的函数。

函数签名                                                              | 说明
----------------------------------------------------------------------|--------
`func ParseBool(str string) (bool, error)`                            | 从字符串中读取 bool
`func ParseFloat(s string, bitSize int) (float64, error)`             | 从字符串中读取浮点数
`func ParseInt(s string, base int, bitSize int) (i int64, err error)` | 从字符串中读取整形
`func QuoteRuneToASCII(r rune) string`                                | 把unicode字符转换成`\uxxxx`的形式
`func Unquote(s string) (string, error)`                              | 从各种编码解析出unicode字符
`func Atoi(s string) (int, error)`                                    | 字符串转变成 Int，注意不是Int64
`func Itoa(i int) string`                                             | 数字转变成字符串

## bytes 的操作

在 Go 语言中，字符串实际上是一种只读的 byte slice，一些适用于 string 的操作也适用于 byte slice。因此 Go 语言还实现了一个包，用来以类似的方式操作 byte slice

`bytes` 包中的函数基本都是和 `strings` 包中对应的，除了把参数 string 换成了 `[]byte` 之外。

`bytes.Buffer` 和 `bytes.Reader` 有点类似于 `strings.Builder` 和 `strings.Reader` 这两个类型，实现了一大堆io的接口，也是利用 bytes 进行 IO 的

比如说，从 io.Reader 中读取 string，可以利用 Buffer.ReadFrom

```
buf := new(bytes.Buffer)
buf.ReadFrom(yourReader)
s := buf.String()
```

函数签名                                                      | 说明
--------------------------------------------------------------| ---------
`func NewBuffer(buf []byte) *Buffer`                          | 从指定 bytes 构建一个 Buffer
`func NewBufferString(s string) *Buffer`                      | 从指定 string 构建一个 Buffer
`func (b *Buffer) Read(p []byte) (n int, err error)`          | 这个方法实现了 io.Reader
`func (b *Buffer) ReadFrom(r io.Reader) (n int64, err error)` | 从一个 io.Reader 中读取内容到自己的 buffer 中
`func (b *Buffer) UnreadByte() error`                         | 回退一个byte
`func (b *Buffer) Write...(p []byte) (n int, err error)`      | 写入到自己的 buffer 中
`func (b *Buffer) WriteTo(w io.Writer) (n int64, err error)`  | 把自己的 buffer 写入到另一个 writer 中

有趣的是，ReadFrom 和 Write 函数两个看起来意思是相反的。实际上都是读取并写入自己的 buffer 中。在 Go 语言中，ReadFrom 和 WriteTo 两个方法才是相反的


# bufio

顾名思义，bufio 就是 buffered io 的缩写，也就是有缓存的 io。bufio 包主要提供了三个类型，`Reader`, `Writer` 和 `Scanner`。这三个类型都接受 `io.Reader/Writer` 作为参数，同时又实现了这两个接口。

# bufio.Reader

Reader 是比较底层的实现

函数签名                                                       | 说明
-------------------------------------------------------------- | ---------
`func NewReader...(rd io.Reader) *Reader`                      | 返回一个增加了缓存的 io.Reader
`func (b *Reader) Buffered() int `                             | 返回缓存的大小
`func (b *Reader) Discard(n int) (discarded int, err error)`   | 抛弃 n 个字节
`func (b *Reader) Peek(n int) ([]byte, error)`                 | 返回 n 个字节，但是不会读取
`func (b *Reader) Read...(p []byte) (n int, err error)`        | 读取

# bufio.Scanner

Scanner 有点类似于 scanf，通过设置不同的 SplitFunc，得到不同的 token。

bufio 中内置了几个 SplitFunc，ScanBytes, ScanLines, ScanRunes, ScanWords用来分别扫描得到 字节、行、Rune、单词。

Scannner 适合对普通文件的分隔，如果需要过多的底层控制，应该使用 bufio.Reader

> Programs that need more control over error handling or large tokens, or must run sequential scans on a reader, should use bufio.Reader instead.

Scanner 的默认 buffer 大小是 `bufio.MaxScannerTokenSize = 64K`如果文件过大，可能会出现 `bufio.Scanner: token too long` 的报错。可以换用更大的 buffer 或者使用 Reader

```
scanner := bufio.NewScanner(file)
buf := make([]byte, 0, 64*1024)
scanner.Buffer(buf, 1024*1024)
for scanner.Scan() {
    // do your stuff
}
```

Scanner 的使用模式

```
scanner := bufio.NewScanner(os.Stdin)
for scanner.Scan() {
    fmt.Println(scanner.Text()) // Println will add back the final "\n"
}
if err := scanner.Err(); err != nil {
    fmt.Fprintln(os.Stderr, "reading standard input:", err)
}
```

函数签名                                        | 说明
---------                                       | -----
`func NewScanner(r io.Reader) *Scanner`         | 生成一个新的
`func (s *Scanner) Buffer(buf []byte, max int)` | 指定 Scanner 的新Buffer
`func (s *Scanner) Bytes() []byte`              | 以 bytes 形式返回当前扫描到的 token
`func (s *Scanner) Scan() bool`                 | 扫描下一个并返回是否结束
`func (s *Scanner) Split(split SplitFunc)`      | 指定分隔函数，这个函数名字起得太简短了
`func (s *Scanner) Text() string`               | 以 string 形式返回当前扫描到的 token

# 文件 IO

`io.Reader` 和 `io.Writer`。这两个是两个特别重要的 interface。一般来说凡是可以抽象为输入的 IO 操作都会使用 io.Reader。凡是可以抽象为输出的 IO 操作都会使用 io.Writer。

# io/ioutil

对于配置文件等等比较小的常规文件，一般来说我们可以使用 io/ioutil 包中的辅助函数操作就好了，比较快捷方便。


函数签名                                                               | 说明
--------                                                               | ---------
`func NopCloser(r io.Reader) io.ReadCloser`                            | 把 io.Reader 包装成一个 io.ReadWriter
`func ReadAll(r io.Reader) ([]byte, error)`                            | 读取所有字符，成功的话 err == nil
`func ReadDir(dirname string) ([]os.FileInfo, error) `                 | 读取当前目录的所有文件
`func ReadFile(filename string) ([]byte, error)`                       | 读取文件的所有内容
`func TempDir(dir, prefix string) (name string, err error)`            | 创建临时目录
`func TempFile(dir, prefix string) (f *os.File, err error)`            | 创建临时文件
`func WriteFile(filename string, data []byte, perm os.FileMode) error` | 写入文件

对于比较大的文件，直接使用 `ioutil.ReadFile` 读到内存里显然是不现实的，这时候应该使用 `os` 模块中的函数。

## 文件操作

其他语言中一般统一通过 open(filename, rw) 这个函数来打开文件，而 golang 中有所
不同，一般来说是通过 os.Open(filename) 打开文件用于读取，使用 os.Create(filename) 
打开文件用于写入。