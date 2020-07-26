# 单元测试

wp_id: 325
Status: draft
Date: 2019-03-08 00:12:00
Modified: 2020-05-16 11:04:14

## 什么时候写单元测试

首先确定解决方案能够解决问题，然后再写测试，否则是徒劳的。

# 如何测试包含 IO 的函数

1. 使用依赖注入
2. 把 IO 操作放在单独的地方，在测试的时候 mock 这个类或者方法

IO 依赖主要包括依赖文件和外部数据库。

对于依赖文件名作为参数的函数，甚至可以认为是一个非常差的实践。有位网友总结的好：

> In general, I prefer to not accept a file name in an API. A file name doesn't give users enough control. It doesn't let you use an unusual encoding, special file permissions, or a bytes.Buffer instead of an actual file, for example. Accepting a file name adds a huge dependency to the code: the file system, along with all of its associated OS specific stuff.

> So I probably would have eliminated the file name based API and only exposed one based on io.Reader. That way, you have complete code coverage, fast tests, and far fewer edge cases to worry about.

而且根据单一职责原则，一个方法也不应该做两件事，要么做计算，要么做 IO, 而接受文件名作为参
数就隐含了既要负责打开文件，又要负责处理文件中的数据。

# 参考文献

1. https://softwareengineering.stackexchange.com/questions/151360/how-to-unit-test-with-lots-of-io
2. https://stackoverflow.com/questions/16541571/unit-testing-methods-with-file-io
3. https://matthias-endler.de/2018/go-io-testing/
4. https://dzone.com/articles/unit-testing-file-io
