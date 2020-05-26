# Python 3 中的 Enum


ID: 654
Status: publish
Date: 2017-06-07 16:31:00
Modified: 2020-05-16 12:05:36


enum 模块是 Python 3 中新引入的一个用于定义枚举常量的模块。

# 基本使用

```
&gt;&gt;&gt; from enum import Enum
&gt;&gt;&gt; class Color(Enum):
...     RED = 1
...     GREEN = 2
...     BLUE = 3
...
&gt;&gt;&gt; print(Color.RED)
Color.RED
&gt;&gt;&gt; type(Color.RED)
&lt;enum &#039;Color&#039;&gt;
&gt;&gt;&gt; isinstance(Color.GREEN, Color)
True

# 可以遍历
&gt;&gt;&gt; for color in Color:
...     print color
...
Color.RED
Color.GREEN
Color.BLUE

&gt;&gt;&gt; list(Shape)
[&lt;Shape.SQUARE: 2&gt;, &lt;Shape.DIAMOND: 1&gt;, &lt;Shape.CIRCLE: 3&gt;]

# 可以当做字典使用
&gt;&gt;&gt; Color(1)
&lt;Color.RED: 1&gt;
&gt;&gt;&gt; Color[&#039;RED&#039;]
&lt;Color.RED: 1&gt;

# 可以访问 Enum 的 name 和 value 属性
&gt;&gt;&gt; red = Color.RED
&gt;&gt;&gt; red.name
&#039;RED&#039;
&gt;&gt;&gt; red.value
1
```

## 自动值

如果枚举的值无关紧要，可以使用 auto，不过一般来说还是不要使用 auto，以免后续存储的数据出问题。

```
&gt;&gt;&gt; from enum import Enum, auto
&gt;&gt;&gt; class Color(Enum):
...     RED = auto()
...     BLUE = auto()
...     GREEN = auto()
...
&gt;&gt;&gt; list(Color)
[&lt;Color.RED: 1&gt;, &lt;Color.BLUE: 2&gt;, &lt;Color.GREEN: 3&gt;]
```

## 保证值是唯一的

使用 `enum.unique` 装饰器
```
&gt;&gt;&gt; from enum import Enum, unique
&gt;&gt;&gt; @unique
... class Mistake(Enum):
...     ONE = 1
...     TWO = 2
...     THREE = 3
...     FOUR = 3
...
Traceback (most recent call last):
...
ValueError: duplicate values found in &lt;enum &#039;Mistake&#039;&gt;: FOUR -&gt; THREE
```

## 比较

注意 `enum.Enum` 并不是 int, 所以并不能比较大小。如果你想要把 enum 当做 int 使用，可以继承 `enum.IntEnum`。
```
&gt;&gt;&gt; Color.RED is Color.RED
True
&gt;&gt;&gt; Color.RED is Color.BLUE
False
&gt;&gt;&gt; Color.RED &lt; Color.BLUE
Traceback (most recent call last):
  File &quot;&lt;stdin&gt;&quot;, line 1, in &lt;module&gt;
TypeError: &#039;&lt;&#039; not supported between instances of &#039;Color&#039; and &#039;Color&#039;

# 使用 IntEnum 可以比较大小
&gt;&gt;&gt; class IntColor(IntEnum):
...     RED = 1
...     GREEN = 2
...     BLUE = 3
...
&gt;&gt;&gt; IntColor.RED &lt; IntColor.GREEN
True
```

# 子类

只有没定义值的类才可以被继承。

```
不可以
&gt;&gt;&gt; class MoreColor(Color):
...     PINK = 17
...
Traceback (most recent call last):
...
TypeError: Cannot extend enumerations


可以
&gt;&gt;&gt; class Foo(Enum):
...     def some_behavior(self):
...         pass
...
&gt;&gt;&gt; class Bar(Foo):
...     HAPPY = 1
...     SAD = 2
...

```

# 利用函数来生成 enum 对象

```
&gt;&gt;&gt; Color = Enum(&#039;Color&#039;, &#039;RED GREEN BLUE&#039;)

```

# IntFlag 和 Flag

IntFlag 也会 Enum 和 int 的子类，可以设置每一个 bit 位。

```
&gt;&gt;&gt; from enum import IntFlag
&gt;&gt;&gt; class Perm(IntFlag):
...     R = 4
...     W = 2
...     X = 1
...
&gt;&gt;&gt; Perm.R | Perm.W
&lt;Perm.R|W: 6&gt;
&gt;&gt;&gt; Perm.R + Perm.W
6
&gt;&gt;&gt; RW = Perm.R | Perm.W
&gt;&gt;&gt; Perm.R in RW
True
```

还可以个给组合起来的变量命名

```
&gt;&gt;&gt; class Perm(IntFlag):
...     R = 4
...     W = 2
...     X = 1
...     RWX = 7
&gt;&gt;&gt; Perm.RWX
&lt;Perm.RWX: 7&gt;
&gt;&gt;&gt; ~Perm.RWX
&lt;Perm.-8: -8&gt;
```
另外，如果 IntFlag 每个位都没有设定，那么恰好是 0 ，会被当做 False 看待。

# 在 django 模型中使用

如果数据库的某一个字段应该是一个枚举，那么使用 enum 再合适不过了。可以这样用：

```
class Color(IntEnum