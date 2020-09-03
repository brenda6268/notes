# 使用 pytest 进行测试

<!--
ID: 7c5358d4-c36a-453f-b5ce-5ff22d156e9c
Status: publish
Date: 2017-12-17T20:26:00
Modified: 2020-05-16T11:28:43
wp_id: 669
-->

## 编写优质测试的前提

天字第一条：首先要明确最小单元，以及单元的功能点都有哪些。如果在写代码之前都没有明确功能有哪些，或者编写功能已经跑偏了，那么测试究竟测些什么呢？

第二点：首先确定解决方案能够解决问题，然后再写测试，否则是徒劳的。

## 编写测试的基本原则

- 每一个测试单元必须是完全独立的。每一个必须能够独立运行以及在其他的测试组中运行，不管他们的顺序如何。加载和清空数据应该使用 setup() 和 teardown() 方法
- **sans-io**。也就是把逻辑和 IO 分开来，这样在测试的时候方便指定输入，以及捕获输出。
- 尽量让测试跑的快一点。如果一个测试在几毫秒之内跑不完的话，开发就会慢下来，以至于没有人再去跑这些测试了。如果实在有很花时间的测试，把他们单独放在一起定期执行。
- 如果你正在开发某样东西的过程中被打断的话，可以写一个测试，这样当你回过头来的时候还能很快想起来需要做什么。
- 使用有描述性的长名字。实际代码中你可能使用 `square()` 这样的名字，但是在测试用你要用 `test_square_of_number_2` 这样的名字。
- 测试代码的另一个用途是作为新手的介绍。让别人来看你的代码的时候，看看测试就知道他是干什么的了。

### 如何测试包含 IO 的函数

1. 使用依赖注入
2. 把 IO 操作放在单独的地方，在测试的时候 mock 这个类或者方法
3. 搭建一个测试用的数据库等服务器

IO 依赖主要包括依赖文件和外部数据库。对于依赖文件名作为参数的函数，甚至可以认为是一个非常差的实践。而且根据单一职责原则，一个方法也不应该做两件事，要么做计算，要么做 IO, 而接受文件名作为参数就隐含了既要负责打开文件，又要负责处理文件中的数据。但是不用文件名的话，有时候对于用户来说又不是很方便。

虽然使用 mock 的方式可能会提高速度或者更方便一些，但是这样的话又和实际生产环境的差异可能过大，而且 mock 库也不是那么好找的。

## 编写测试的思路

从软件可靠性的角度，测试当然是越完备越好，但是不是每一个软件都是核弹控制器，还是要根据实际情况折中一下。

### 追求功能测试

只需要按照功能点，把正常和常见的异常情况测试一下就好了。重点还是要先明确功能点有哪些。

### 追求 100% 覆盖度

按照代码逻辑分支测试，把代码的每一个分支的

1. 入口参数是什么
2. 出口参数是什么
3. 副作用是什么
4. 产生的异常是什么

都测试到。

## 工具选择

Python 常用的测试工具有三种：

1. 标准库自带的 unittest
2. nose[2]
3. pytest

其中 unittest 完全是从 JUnit 移植过来的，用起来稍微有些别扭。nose 和 pytest 相比的话，网友大多推荐 pytest。详细的比较可一件参考文档。

## pytest

和传统的 unittest 中复杂的 assertEqual 等语句不同的是，pytest 中只需要简单地写 assert 语句就行了。

### 命令行选项

`pytest some_mod.py` 运行某个文件中的中的测试

`pytest tests/` 运行某个目录中的测试

`pytest -x` 在第一个错误的地方结束

`pytest --pdb`，当出现异常的时候，打开 pdb
 
测试函数使用 test_开头，pytest 默认会查找当前目录中的 `test_` 开头或者 `_test` 结尾的文件中的测试并运行。使用 assert 来验证语句。

### 测试某个异常抛出：

```py
import pytest
def f():
    raise SystemExit(1)
 
def test_mytest():
    with pytest.raises(SystemExit):
        f()
```

### 执行顺序

如果在一个文件中定义了多个测试函数，那么 pytest 将按照函数定义的顺序执行。

### setup 和 teardown

setup 和 teardown 用来在测试开始前加载资源，并在测试结束后卸载资源。

1. 可以在文件中定义 `setup_module` 和 `teardown_module` 中
2. 可以在类中定义 `setup_class` 和 `teardown_class` 中定义加载和卸载方法。

### mock 和 patch

## Python 中的其他测试工具

### unittest

```py
import unittest

def fun(x):
    return x + 1

class MyTest(unittest.TestCase):
    def setUp(self):
        # bootstrapping
    def tearDown(self):
        #clean up
    def test(self):
        self.assertEqual(fun(3), 4)
```

Unittest 中的 assert 方法：

方法 | 含义
----|----
assertEqual(a, b)|a == b
assertNotEqual(a, b)|a != b
assertTrue(x)|bool(x) is True
assertFalse(x)|bool(x) is False
assertIs(a, b)|a is b
assertIsNot(a, b)|a is not b
assertIsNone(x)|x is None
assertIsNotNone(x)|x is not None
assertIn(a, b)|a in b
assertNotIn(a, b)|a not in b
assertIsInstance(a, b)|isinstance(a, b)
assertNotIsInstance(a, b)|not isinstance(a, b)

save it as fun_test.py and run it by:

```
python -m unittest fun_test
```

Note: only method starts with test is run by unittest module

unittest 这个库没有按照 PEP8 来，看着就不爽

### doctest

需要转义 `\n`

需要使用`<BLANKLINE>`来代表空行

## 参考文档

1. https://www.reddit.com/r/Python/comments/50nqlp/is_nose_still_relevant_how_about_unittest/
2. https://agopian.info/presentations/2015_06_djangocon_europe/?full#pythonic
3. http://docs.python-guide.org/en/latest/writing/tests/
4. https://realpython.com/python-testing/
5. https://pytest-benchmark.readthedocs.io/en/latest/
6. https://medium.com/@yeraydiazdiaz/what-the-mock-cheatsheet-mocking-in-python-6a71db997832
7. https://softwareengineering.stackexchange.com/questions/151360/how-to-unit-test-with-lots-of-io
8. https://stackoverflow.com/questions/16541571/unit-testing-methods-with-file-io
9. https://matthias-endler.de/2018/go-io-testing/
10. https://dzone.com/articles/unit-testing-file-io
