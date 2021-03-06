# Python 胎教

<!--
ID: 84206c1b-575d-432f-9f12-f2f3f822858b
Status: draft
Date: 2017-05-30T11:46:00
Modified: 2020-05-16T12:01:11
wp_id: 394
-->

## 前言

女朋友怀孕了，为了让孩子在起跑线之前就能赢了，决定给宝宝来一些胎教~

女朋友大学毕业，虽然是学设计的，但是也有学过 C 语言的基础，所以这篇教程里面会涉及到一些 C 的知识。

## 第一课
------

这一课的主要内容有：变量、函数、类型。

为什么要有编程语言？

首先，我们需要一个强大的计算器，那么 Python 就是这样一个计算器，比如，可以计算加减乘除：

```
>>> 1 + 1
2
>>> 4 ** 2  # 这是求幂
16
```

数学中还有函数的概念，比如`sin`, `cos` 等等。这些在 Python 中也是存在的。

```
>>> from math import sin  # 先忽略这一句
>>> sin(3.14 / 2)  # 比如我们知道 sin(π/2) = 1
0.9999996829318346  # 可以看到这是一个非常接近 1 的数字
```

在上面这个例子里，函数的名字是 `sin`，而 3.14/2 得到的值就是我们的参数(parameter)，得到的值就是我们的返回值。

那么我们可不可以自己定义函数呢？当然是可以的。

`def` 是 define 的缩写，也就是定义一个函数，函数的名字是 hello，它有一个参数，参数的名字叫做 name。在 C 中使用大括号包裹起来，表示一块内容，比如函数的定义部分，但是往往我们还需要

```
>>> def hello(name):
...     print("hello " + name)
...
>>> hello("lxw")
hello lxw
```