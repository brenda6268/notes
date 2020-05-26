# Python 中的静态类型（type hint）


ID: 657
Status: draft
Date: 2018-06-03 18:33:00
Modified: 2020-05-16 11:39:42


Python 本身是一个动态类型的语言，也就是说类型不是在编译时（compile-time）来确定的，而是在运行时（run-time）才能够确定的。举个栗子（基于Python3.5+）：

```
def greeting(name):
    return &#039;Hello &#039; + name
```

这个函数里面，参数的类型是可变的，我们期望地是传递一个 str 类型的数据，或者是 bytes 类型。然而实际上这个函数可以传递任何的类型，如果传递的参数不支持`len`操作，那么就抛出异常了。尤其是在代码重构的时候，你根本不知道哪些地方对这个函数做了什么调用，正所谓“动态类型一时爽，代码重构火葬场”。

```
In [2]: greeting(1)
---------------------------------------------------------------------------
TypeError                                 Traceback (most recent call last)
&lt;ipython-input-2-70f534de3be9&gt; in &lt;module&gt;()
----&gt; 1 greeting(1)

&lt;ipython-input-1-311aff60a9bd&gt; in greeting(name)
      1 def greeting(name: str) -&gt; str:
----&gt; 2     return &#039;Hello &#039; + name

TypeError: must be str, not int
```

为了解决这个问题，Python3 引入了 type hint，也就是类型提示，来帮助mypy工具在程序运行之前进行动态监测，我们可以使用下面的语法来把类型信息添加到函数中：

```
from typing import Union

def greeting(name: str) -&gt; str:
    return &#039;Hello &#039; + name


greeting(1)
```

可以看到我们给参数和返回值都添加了类型提示，然后使用 mypy 工具检测。

```
-&gt; % mypy test.py
test.py:7: error: Argument 1 to &quot;greeting&quot; has incompatible type &quot;int&quot;; expected &quot;str&quot;
```

可以看到直接给出了类型错误，mypy 期望是 bytes 或者 str 类型的数据，而我们调用的时候使用了 int。


# typing 模块

Any, Union, Tuple, Callable, TypeVar, and Generic

关于详细的 type hint 的语法可以参考 [typing 文档](https://docs.python.org/3/library/typing.html) 和 [Type Hint Cheatsheet](http://mypy.readthedocs.io/en/latest/cheat_sheet_py3.html)