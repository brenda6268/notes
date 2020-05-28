# Python 3 中的 Enum


wp_id: 654
Status: publish
Date: 2017-06-07 16:31:00
Modified: 2020-05-16 12:05:36


enum 模块是 Python 3 中新引入的一个用于定义枚举常量的模块。

# 基本使用

```
>>> from enum import Enum
>>> class Color(Enum):
...     RED = 1
...     GREEN = 2
...     BLUE = 3
...
>>> print(Color.RED)
Color.RED
>>> type(Color.RED)
<enum "Color">
>>> isinstance(Color.GREEN, Color)
True

# 可以遍历
>>> for color in Color:
...     print color
...
Color.RED
Color.GREEN
Color.BLUE

>>> list(Shape)
[<Shape.SQUARE: 2>, <Shape.DIAMOND: 1>, <Shape.CIRCLE: 3>]

# 可以当做字典使用
>>> Color(1)
<Color.RED: 1>
>>> Color["RED"]
<Color.RED: 1>

# 可以访问 Enum 的 name 和 value 属性
>>> red = Color.RED
>>> red.name
"RED"
>>> red.value
1
```

## 自动值

如果枚举的值无关紧要，可以使用 auto，不过一般来说还是不要使用 auto，以免后续存储的数据出问题。

```
>>> from enum import Enum, auto
>>> class Color(Enum):
...     RED = auto()
...     BLUE = auto()
...     GREEN = auto()
...
>>> list(Color)
[<Color.RED: 1>, <Color.BLUE: 2>, <Color.GREEN: 3>]
```

## 保证值是唯一的

使用 `enum.unique` 装饰器
```
>>> from enum import Enum, unique
>>> @unique
... class Mistake(Enum):
...     ONE = 1
...     TWO = 2
...     THREE = 3
...     FOUR = 3
...
Traceback (most recent call last):
...
ValueError: duplicate values found in <enum "Mistake">: FOUR -> THREE
```

## 比较

注意 `enum.Enum` 并不是 int, 所以并不能比较大小。如果你想要把 enum 当做 int 使用，可以继承 `enum.IntEnum`。
```
>>> Color.RED is Color.RED
True
>>> Color.RED is Color.BLUE
False
>>> Color.RED < Color.BLUE
Traceback (most recent call last):
  File "<stdin>", line 1, in <module>
TypeError: "<" not supported between instances of "Color" and "Color"

# 使用 IntEnum 可以比较大小
>>> class IntColor(IntEnum):
...     RED = 1
...     GREEN = 2
...     BLUE = 3
...
>>> IntColor.RED < IntColor.GREEN
True
```

# 子类

只有没定义值的类才可以被继承。

```
不可以
>>> class MoreColor(Color):
...     PINK = 17
...
Traceback (most recent call last):
...
TypeError: Cannot extend enumerations


可以
>>> class Foo(Enum):
...     def some_behavior(self):
...         pass
...
>>> class Bar(Foo):
...     HAPPY = 1
...     SAD = 2
...

```

# 利用函数来生成 enum 对象

```
>>> Color = Enum("Color", "RED GREEN BLUE")

```

# IntFlag 和 Flag

IntFlag 也会 Enum 和 int 的子类，可以设置每一个 bit 位。

```
>>> from enum import IntFlag
>>> class Perm(IntFlag):
...     R = 4
...     W = 2
...     X = 1
...
>>> Perm.R | Perm.W
<Perm.R|W: 6>
>>> Perm.R + Perm.W
6
>>> RW = Perm.R | Perm.W
>>> Perm.R in RW
True
```

还可以个给组合起来的变量命名

```
>>> class Perm(IntFlag):
...     R = 4
...     W = 2
...     X = 1
...     RWX = 7
>>> Perm.RWX
<Perm.RWX: 7>
>>> ~Perm.RWX
<Perm.-8: -8>
```
另外，如果 IntFlag 每个位都没有设定，那么恰好是 0 ，会被当做 False 看待。

# 在 django 模型中使用

如果数据库的某一个字段应该是一个枚举，那么使用 enum 再合适不过了。可以这样用：

```
class Color(IntEnum