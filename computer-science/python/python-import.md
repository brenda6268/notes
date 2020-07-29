# Python 的 import 系统与 importlib

<!--
ID: 0279ae11-19f7-4c3d-aefe-88523e04adfa
Status: publish
Date: 2017-08-05T01:01:00
Modified: 2020-05-16T11:47:30
wp_id: 629
-->

首先

`__init__.py` is first called before the actual import


if you have  the following code:

```
foobar/
    __init__.py
    baz.py
```

runing import foobar will not make foobar.baz available
you have to add from . import baz to `__init__.py`


add `__all__` to `__init.__.py` to control which to be imported by import *

## relative import

```py
from . import grok
from ..B import bar
relavtive import only works when using -m option
python -m mypackage.A.spam
```

by calling import foo, `foo/__init__.py` will be called

## 常见的问题

implicit import

需要注意的是 python2 中支持隐式的从当前文件import当前目录的文件。 这个功能在python3 中已经被去掉了。

## Q&A

如何处理循环引用的问题？

把一些import语句放到真正需要他们的地方， 比如某个函数里面

# importlib

之所以想研究importlib，是因为leader提到了Thrift应该把源文件提交到仓库中，而不是把编译后的文件提交到仓库中，而python运行是没有预编译机制的，那么就需要一套机制来在runtime动态的编译加载thrift文件。第一个想法当然是写一个import_thrift函数，大概是这样的：

```py
def import_thrfit(package, *names):
    _compile_thrift(package)  # compile *.thrift files
    if not objects:
        import module_name
    else:
        from module_name import *names
```      
        
但是，显然直接使用import语句是不可以的，因为import是一个语句，后边跟的不能是变量。这时候就需要import背后的库importlib的帮助了。再者，当多次调用这个函数的时候，我们希望有缓存，而不是每次编译一次

## 介绍importlib
importlib实现了两个功能，1. 提供了import的实现，2. 提供了import_module函数，这样我们就可以实现自己的import系统。本文中我们主要关注第二点。

### importlib.import_module

importlib.import_module(name, package=None) 如果name是相对包名，name将从package中相对导入这个包，比如`..mod`，package是`package.subpkg`，将会导入package.mod这个包。如果name是绝对包名，那就直接导入。需要注意的是在上述例子中，返回的是package.mod这个名字而不是单独的mod名称。

有了这个函数我们就可以实现 import_thrift 了