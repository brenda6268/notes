# Python 3 中的 dataclass

<!--
ID: b0778853-c0be-4003-bca6-5b46feb787f9
Status: publish
Date: 2020-08-31T17:40:36
Modified: 2020-08-31T17:40:36
wp_id: 1891
-->

在 Python 中，如果要为一个类添加一些数据成员的话，需要做的事情还挺多，比如说编写 `__init__`,
`__str__` 这些函数，代码都是重复的，没啥意义。在 Python 3.7 中，终于添加了一个语法糖，叫做
`dataclass`. 下面我们就来看一下吧~

```py
# 注意！包名叫 dataclasses, 多了个 es
from dataclasses import dataclass

@dataclass
class InventoryItem:
    """Class for keeping track of an item in inventory."""
    name: str
    unit_price: float
    quantity_on_hand: int = 0

    def total_cost(self) -> float:
        return self.unit_price * self.quantity_on_hand
```

上面的代码就相当于以前的：

```py
def __init__(self, name: str, unit_price: float, quantity_on_hand: int=0):
    self.name = name
    self.unit_price = unit_price
    self.quantity_on_hand = quantity_on_hand

def __repr__(self):
    ...

def __eq__(self):
    ...

...
```

我们知道，在 Python 的默认参数中，使用 mutable（可变） 的对象是一种常见的坑，在 dataclass 中当然也存在
了，还好标准库中给我们提供了一个方法。

```py
# 会报错
@dataclass
class Request:
    headers: dict = {}

# 相当于
class Request:
    def __init__(self, headers={}):
        self.headers = headers


# 正确的写法
from dataclasses import field

@dataclass
class Request:
    headers: dict = field(default_factory=dict)
```

字典这种类型是比较容易想起来不能直接做参数的，比较坑的是对于其他的自定义对象，Python 解释器并不会提
示有问题，比如说这样：

```py
# 千万别这么做
@dataclass
class Request:
    headers: Headers = Headers()
```

这时候坑爹的事情就发生了，每次创建新的 Request 对象引用的都是同一个 Headers 对象，也就是在声明这个类
的同时产生的这个 Headers 对象！原因也很简单，就像是上面的 dict 一样，这个 Headers 并不是在 init 函数
中，所以只会产生一次。所以，需要牢记的是：**dataclass 中的所有对象默认值就相当于函数的默认参数**，永远不
要传递一个 mutable 就好了。

```py
# 上面的例子相当于
class Request:
    def __init__(self, headers=Headers()):
        self.headers = headers

# 正确的做法
@dataclass
class Request:
    headers: Headers = field(default_factory=Headers)
```

dataclasses 模块中还提供了 `asdict` 方法，这样就可以方便地转换为 json 对象啦。

```py
from dataclasses import asdict


@dataclass
class Request:
    url: str = ""
    method: str = ""

req = asdict(Request())
```


## 参考资料

1. https://docs.python.org/3/library/dataclasses.html
