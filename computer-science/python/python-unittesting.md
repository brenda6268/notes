# Python 的单元测试


ID: 669
Status: publish
Date: 2017-12-17 20:26:00
Modified: 2020-05-16 11:28:43


# 编写测试的基本原则

每一个测试单元必须是完全独立的。每一个必须能够独立运行以及在其他的测试组中运行，不管他们的顺序如何。加载和清空数据应该使用 setUp() 和 tearDown() 方法（如果使用unittest）。

**sans-io**。也就是把逻辑和 IO 分开来，这样在测试的时候方便指定输入，以及捕获输出。

尽量让测试跑的快一点。如果一个测试在几毫秒之内跑不完的话，开发就会慢下来，以至于没有人再去跑这些测试了。如果实在有很花时间的测试，把他们单独放在一起定期执行。

如果你正在开发某样东西的过程中被打断的话，可以写一个测试，这样当你回过头来的时候还能很快想起来需要做什么。

使用有描述性的长名字。实际代码中你可能使用 `square()` 这样的名字，但是在测试用你要用 `test_square_of_number_2` 这样的名字。

测试代码的另一个用途是作为新手的介绍。让别人来看你的代码的时候，看看测试就知道他是干什么的了。

# 编写测试的思路

按照代码逻辑分支测试，把代码的每一个分支的

1. 入口参数是什么
2. 出口参数是什么
3. 副作用是什么
4. 产生的异常是什么

都测试到。


# 工具选择

Python 常用的测试工具有三种：

1. 标准库自带的 unittest
2. nose[2]
3. pytest

其中 unittest 完全是从 JUnit 移植过来的，用起来稍微有些别扭。nose 和 pytest 相比的话，网友大多推荐 pytest。详细的比较可一件参考文档。

# pytest
 
测试函数使用test_开头, pytest 默认会查找当前目录中的 `test_` 开头或者 `_test` 结尾的文件中的测试并运行。使用assert来验证语句。

## 测试某个异常抛出：

```
import pytest
def f():
    raise SystemExit(1)
 
def test_mytest():
    with pytest.raises(SystemExit):
        f()
```

## 执行顺序

如果在一个文件中定义了多个测试函数，那么 pytest 将按照函数定义的顺序执行。

## setup 和 teardown

setup 和 teardown 用来在测试开始前加载资源，并在测试结束后卸载资源。

1. 可以在文件中定义 setup_module 和 teardown_module 中
2. 可以在类中定义 setup_class 和 teardown_class 中定义加载和卸载方法。

## pytest 命令行选项

`pytest some_mod.py` 运行某个文件中的中的测试

`pytest tests/` 运行某个目录中的测试

`pytest -x` 在第一个错误的地方结束

pytest --pdb，当出现异常的时候, 打开pdb

## mock 和 patch


# unittest

```
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

# doctest


Note: only method starts with test is run by unittest module

unittest这个库没有按照PEP8来, 看着就不爽

注意docstring

需要用 unicode, 需要用u prefix

需要转义 \n

需要使用<BLANKLINE>来代表空行

# 参考文档

1. https://www.reddit.com/r/Python/comments/50nqlp/is_nose_still_relevant_how_about_unittest/
2. https://agopian.info/presentations/2015_06_djangocon_europe/?full#pythonic
3. http://docs.python-guide.org/en/latest/writing/tests/
4. https://realpython.com/python-testing/
5. https://pytest-benchmark.readthedocs.io/en/latest/
6. https://medium.com/@yeraydiazdiaz/what-the-mock-cheatsheet-mocking-in-python-6a71db997832