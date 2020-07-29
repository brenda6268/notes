# 十五分钟了解 Monad

<!--
ID: af7ebf4c-ba74-4b0c-9197-042f6c2cbd84
Status: publish
Date: 2019-05-29T14:07:00
Modified: 2020-05-16T11:02:25
wp_id: 339
-->

# 15 分钟了解 Monad

看到函数式编程相关的资料的时候, 总是看到 Monad 这个词, 一直想了解一下, 然而查资料对
Monad 的定义往往是上来一大堆数学概念:

> Monad 是一个自函子范畴上的幺半群

鉴于本人数学基础实在太差, 一直没能理解. 其实撇开这些数学概念来说, Monad 本身是一个非常简
单的东西, 像是 Rust 中的 Option 一样, 一旦理解, 就发现再也回不去之前没有他的世界了.
Monad 并不仅局限于函数式编程语言, 也可以用其他的语言来表示.

## 例子

### 1 日志

假设我们有三个只接受一个参数的函数, `f1`, `f2`, `f3`, 分别返回 +1, +2, +3 后的数局以及一
条关于做了什么操作的信息.

```
def f1(x):
    return (x + 1, str(x) + "+1")

def f2(x):
    return (x + 2, str(x) + "+2")

def f3(x):
    return (x + 3, str(x) + "+3")
```

现在我们想要计算 x + 1 + 2 + 3, 那么我们可以把这三个函数链式调用. 而且, 我们还想获得关于
调用了那些函数的详细日志.

可以这样做:

```
log = "Ops:"

res, log1 = f1(x)
log += log1 + ";"

res, log2 = f2(res)
log += log2 + ";"

res, log3 = f3(res)
log += log3 + ";"

print(res, log)
```

这种方法简直太丑陋了, 首先我们重复编写了好多胶水代码, 而且如果我们要再添加一个函数 f4 的
话, 就得再多些两行胶水代码. 更糟糕的是, 不断改变 res 和 log 两个变量的值让我们的代码变得
非常不可读.

理想情况下, 我们希望能够这样链式调用: f3(f2(f1(x))). 不幸的是, f1 和 f2 的返回结果和 f2
和 f3 的入口参数是不一样的. 为了解决这个问题, 我们引入两个新的函数:

```
def unit(x):
    return (x, "Ops:")

def bind(t, f):
    res = f(t[0])
    return (res[0], t[1] + res[1] + ";")
```

这样的话, 我们就可以用下面的链式调用来解决了:

```
print(bind(bind(bind(unit(x), f1), f2), f3))
```

下面的图展示了当 x=0 时候的调用过程, v1, v2, v3 分别表示中间数据.

![Example 1](https://nikgrozev.com/images/blog/Monads%20in%2015%20minutes/example11.png)

unit 函数把参数 x 变成了 (int, str) 构成的 tuple. 接下来的 bind 函数调用了他的参数 f 函
数, 同时把结果累加到了形参 t 上.

这种方法避免了第一种方法的缺点, 因为所有的胶水代码都在 bind 函数中, 当我们要添加一个新的
函数的时候, 只需要接着链式调用就可以了.

```
print(bind(bind(bind(bind(unit(x), f1), f2), f3), f4))
```

### 2 中间值的列表

在这个例子中, 我们假设有三个简单的单参函数:

```
def f1(x): return x + 1

def f2(x): return x + 2

def f3(x): return x + 3
```

和前面的例子一样, 我们想要组合这些函数来计算 x+1+2+3 的值. 除此之外, 我们还想要生成中间
值得列表, 也就是: x, x+1, x+1+2, x+1+2+3.

和前面的例子不同的是, 这三个函数的输入和输出类型是匹配的, 因此我们可以直接调用
f3(f2(f1(x)). 不过这样做的话, 我们没法获得中间值.

一个可行的方法是:

```
lst = [x]

res = f1(x)
lst.append(res)

res = f2(res)
lst.append(res)

res = f3(res)
lst.append(res)

print(res, lst)
```

很显然, 这并不是一个很好的做法, 我们又写了一堆的胶水代码, 而且还得负责把中间变量聚合成一
个列表. 如果我们再添加一个新的函数 f4 的话, 又得再添加一些新的胶水代码了.

为了解决这个问题, 我们像之前一样, 引入两个辅助函数:

```
def unit(x):
    return (x, [x])

def bind(t, f):
    res = f(t[0])
    return (res, t[1] + [res])
```

现在, 我们又可以链式调用了:

```
print( bind(bind(bind(unit(x), f1), f2), f3) )
```

下面的图表展示了当 x=0 的时候, v1, v2, v3 分别代表了中间变量.

![Example 2](https://nikgrozev.com/images/blog/Monads%20in%2015%20minutes/example21.png)

### 3 Nulls/Nones

下面让我们来引入类和对象. 假设我们有一个类 Employee:

```
class Employee:
    def get_boss(self):
        """Retrun the employee"s boss"""

    def get_wage(self):
        """Compute the wage"""
```

每个 Employee 实例都有一个 boss, 也就是老板, 并且也是 Employee 类型的, 还有一个工资属性.
我们可以通过两个方法来访问他们. 每一个方法都有可能返回 None (也就是说工资不知道, 或者是
没有 boss). 在这个例子中, 我们要开发一个程序, 给定一个 Employee, 比如说 john, 返回他的老
板的工资, 如果不能确定工资的话, 或者 john 是 None, 那么我们应该返回 None.

理想情况下, 我们只要这样写就好了:

```
print(john.get_boss().get_wage())
```

然而, 因为每个方法都可能返回 None, 我们得这么写:

```
result = None

if john is not None and john.get_boss() is not None and john.get_boss().get_wage() is not None:
    result = johs.get_boss().get_wage()

print(result)
```

然而, 在这个方案中, 我们调用了好多次 get_boss 和 get_wage 方法. 如果这两个方法调用起来代
价很大的话(比如说需要查询数据库), 那么显然是不合适的. 所以方案应该是:

```
result = None
if john is not None:
    boss = john.get_boss()
    if boss is not None:
        wage = boss.get_wage()
        if wage is not None:
            result = wage
print(result)
```

这个方案显然不太好看, 三层 if 语句看起来太臃肿了. 为了解决这个问题, 我们使用和刚刚一样的
方法: 定义下面的辅助函数

```
def unit(e):
    return e

def bind(e, f):
    return None if e is None, else f(e)
```

现在我们可以直接链式调用了:

```
print(bind(bind(unit(john), Employee.get_boss), Employee.get_wage))
```

你可能已经注意到了, 我们实际上并不需要调用 unit(john), 因为他就是返回自身而已. 我们这样
做的原因是为了和之前的模式保持一致, 这样我们就能推广泛化到更通用的模式. 另外需要注意的是
, 在 Python 中, 方法也只是普通的函数, john.get_boss() 和 Employee.get_boss(john) 是完全
一样的意思.

下面的图表显示了在 john 没有 boss 的情况下的计算过程.

![Example 3](https://nikgrozev.com/images/blog/Monads%20in%2015%20minutes/example31.png)

## 泛化 - Monads

如果我们想要组合函数 f1, f2, ... fn. 如果所有的参数都和返回类型对的上, 那么我们可以直接
调用 fn(...f2(f1(x))...). 下面的图说明了隐含的计算过程. v1, v2...vn 标识了其中的中间变量
.

![Direct Composition](https://nikgrozev.com/images/blog/Monads%20in%2015%20minutes/dierct_composition1.png)

然而, 这种情况往往是不存在的. 比如说在我们之前的日志例子中, 输入类型和输出类型是不能匹配
的, 在第二个和第三个例子中, 函数是可以组合的, 但是我们想要在其中"注入"我们额外的逻辑. 在
第二个例子中, 我们想要记录中间值, 而在第三个例子中, 我们想要加入 Null/None 检测.

### 命令式解法

在上面的例子中, 我们首先使用了直观的命令式解法. 如下图所示:

![Imperative Composition](https://nikgrozev.com/images/blog/Monads%20in%2015%20minutes/imperativecomposition2.png)

在调用 f1 之前, 我们首先执行一些初始化代码. 比如, 在例子1 和例子2 中, 我们初始化了存储日
志和中间值的变量. 在之后我们调用 f1, f2...fn 等函数的时候, 我们添加了一些胶水代码. 在例
子1 和例子2 中, 胶水代码分别负责聚合日志和中间值. 在例子3 中, 胶水代码负责检查中间值是否
是空的, 也就是 Null/None.

### 引入 Monad

正如我们在上面的例子中看到的一样, 直接的方法会有一些让人不悦的副作用 -- 丑陋的胶水代码,
多次检查 Null/None 等等. 为了实现更优雅的方案, 在上面的例子中, 我们使用了一种设计模式,
包含了 unit 和 bind 两种函数. 这种设计模式就叫做 **Monad**. 本质上来说, bind 函数实现了
胶水代码, 而 unit 实现了初始化代码. 这就让我们可以在一行之内解决问题:

```
bind(bind(...bind(bind(unit(x), f1), f2)...fn-1), fn)
```

下面的图表说明了计算过程:

![Monad](https://nikgrozev.com/images/blog/Monads%20in%2015%20minutes/monad1.png)

unit(x) 产生了初始值 v1, 然后 bind(v1, f1) 生成了新的中间值 v2, 然后在被用到了 bind(v2, f2) 中,
整个过程一直持续到最终结果产生. 使用这个模式, 配合上不同的 unit 和 bind 函数, 我们可以实
现多种不同的函数组合. 标准的 Monad 库提供了几种预定义好的常用 monad(也就是 unit 和 bind
函数), 可以直接拿来用.

为了组合 bind 和 unit 函数, unit 和 bind 的返回值, 和 bind 的第一个参数必须是匹配的. 这
叫做 Monadic 类型. 在上面的 Monad 计算过程中, 所有的中间值的类型都是 Monadic.

最后, 重复调用bind显然也是丑陋的, 我们可以定义一个函数来辅助操作.

```
def pipeline(e, *fns):
    for fn in fns:
        e = bind(e, fn)
    return e
```

下面的代码:

```
bind(bind(bind(bind(unit(x), f1), f2), f3), f4)
```

就可以改成:

```
pipeline(unit(x), f1, f2, f3, f4)
```

## 结论

Monad 是函数组合的一种简单又强大的设计模式. 在声明式的语言中, 他被用来实现命令式语言中的
日志和 IO 操作. 在命令式的语言中, 他可以用来减少和隔离冗余的胶水代码. 本文只是简单地介绍
了 Monad 的一些只管解释, 还可以查看下面这些资料:

1. [Monad on Wikipedia](http://en.wikipedia.org/wiki/Monad_%28functional_programming%29)
2. [Monads in Python](http://www.valuedlessons.com/2008/01/monads-in-python-with-nice-syntax.html)
3. [List of Monad tutorials](http://www.haskell.org/haskellwiki/Monad_tutorials_timeline)


本文主要翻译自: https://nikgrozev.com/2013/12/10/monads-in-15-minutes/
