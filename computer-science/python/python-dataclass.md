# Python 3 中的 dataclass

<!--
ID: b0778853-c0be-4003-bca6-5b46feb787f9
Status: draft
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


# 正确的写法
from dataclasses import field
@dataclass
class Request:
    headers: dict = field(default_factory=dict)
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
