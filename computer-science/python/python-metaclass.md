# Python metaclass 的原理和应用


wp_id: 831
Status: publish
Date: 2019-12-02 18:03:33
Modified: 2020-05-16 10:46:52


元编程(meta programming)是一项很神奇的能力，可以通过代码在**运行时**动态生成代码。元类(meta classes)是 Python 提供的一种元编程的能力。在 Python 中，类也是一种对象，那么类这种对象就是元类的实例，所以我们可以在运行时通过实例化元类动态生成类。

## 使用 type “函数”

首先我们来了解一下 type，type 可以作为函数使用，用来获得对象的类型：

```python
>>> class Foo:
...     pass
>>> obj = Foo()
>>> obj.__class__
<class "__main__.Foo">
>>> type(obj)
<class "__main__.Foo">
>>> obj.__class__ is type(obj)
True
```

实际上 type 并不是一个函数，而是一个类，我们可以使用 type(type) 来确定一下：

```python
>>> type(type)
<class "type">
```

type 实际上不只是类，而是一个“元类”。我们接下来要可以看到，所有的元类都需要继承自 type。type 是所以类的元类，所以在上面的例子中 x 是 Foo 的实例，Foo 是 type 的实例，type 又是他自己的实例。

![file](https://yifei.me/wp-content/uploads/2019/12/image-1575282914707.png)

## 使用 type 动态创建类

如果传递给 type 的参数是三个的时候，type 的语义就不再是返回给定参数的类，而是实例化生成一个新的类。

```python
type(name: str, bases: tuple, namespace: dict)
```

第一个参数是新生成的类的名字；第二个参数是新生成的类的基类列表；第三个参数是要个这个类绑定的属性的列表，比如说这个类的一些方法。实际上 class Foo 这种语法只是使用 type 生成类的语法糖而已。

最简单的一个例子，比如我们要创建 Foo[0..9] 这些类，可以这样做：

```python
classes = []
for i in range(10):
    cls = type("Foo%s" % i, tuple(), {})
    classes.append(cls)

# 就像使用普通类一样初始化 Foo0

foo0  = clssses[0]()
```

如果要实现类的方法，一定要记得同样是要使用 self 变量的。在 Python 中 self 只是一个约定俗称的变量，而不是关键字。

```python
def __init__(self, name):
    self.name = name

def print_name(self):
    print(self.name)

Duck = type("Duck", tuple(), {"__init__": __init__, "print_name": print_name})

duck = Duck("Donald")

duck.print_name()
# Donald
```

## 创建自己的元类

首先我们来回顾一下 Python 中类的初始化过程：

```python
foo = Foo()
```

当这条语句运行的时候，Python  会依次调用 `__new__` 和 `__init__` 方法。其中 `__new__` 方法在 `__init__` 之前调用，并返回已经创建好的新对象，而 `__init__` 函数是没有返回结果的。一般情况下，我们都会覆盖 `__init__` 方法来对新创建的对象做一些初始化操作。


现在回归到元类上，**进入烧脑部分**。前面我们说过元类的实例化就是类，所以大致相当于：

```python
Foo = MetaFoo(name, bases, attrs)  # MetaFoo 默认情况下是 type
foo = Foo()
```

默认情况下，所有类的元类是 type，也就是在这个类是通过 type 来创建的，这和前面说的通过 type 来动态创建类也是一致的。

那么怎样定义一个 MetaFoo 呢？只需要继承自 type 就行了。因为元类的实例化就是类的创建过程，所以在元类中，我们可以修改 `__new__` 来在 `__init__` 之前对新创建的类做一些操作。

```python
>>> class MetaFoo(type):
...     def __new__(cls, name, bases, namespace):
...         x = super().__new__(cls, name, bases, namespace)  # super实际上就是 type
...         x.bar = 100  # 为这个类增加一个属性
...         return x
...

>>> Foo = MetaFoo("Foo", tuple(), {})  # MetaFoo 在这里就相当于 type 了，可以动态创建类
>>> Foo.bar
100
>>> foo = Foo()
>>> foo.bar
100
```

在这里我们创建了 MetaFoo 这个元类，他会给新创建的类增加一个叫做 bar 的属性。

在实际的代码中，我们一般还是不会直接动态生成类的，还是调用 `class Foo` 语法来生成类比较常见一点，这时候可以指定 metaclass 参数就好了。可以通过 Foo(metaclass=MetaFoo) 这种方式来指定元类。

```python
class Foo(metaclass=MetaFoo):
    pass
```

这种定义和上面的元类用法效果完全是一致的。

## 一个现实世界的元类例子

在 django.models 或者 peewee 等 ORM 中，我们一般使用类的成员变量来定义字段，这里就用到了元类。

```python
class Field:
    pass

class IntegerField(Field):
    pass

class CharField(Field):
    pass

class MetaModel(type):
    def __new__(meta, name, bases, attrs):
        # 这里最神奇的是：用户定义的类中的 bases 和 attrs 都会作为参数传递进来
        fields = {}
        for key, value in attrs.items():
            if isinstance(value, Field):
                value.name = "%s.%s" % (name, key)
                fields[key] = value
        for base in bases:
            if hasattr(base, "_fields"):
                fields.update(base._fields)
        attrs["_fields"] = fields
        return type.__new__(meta, name, bases, attrs)

class Model(metaclass=MetaModel):
    pass
```

这样用户使用的时候就可以这样定义：

```python
>>> class A(Model):
...     foo = IntegerField()
...
>>> class B(A):
...     bar = CharField()
...
>>> B._fields
{"foo": Integer("A.foo"), "bar": String("B.bar")}
```

程序在执行的时候就可以直接访问 `X._fields`，而不用每次都通过反射遍历一次，从而提高效率以及做一些验证。

不过，其实这个完全可以通过装饰器来实现：

```python
def model(cls):
    fields = {}
    for key, value in vars(cls).items():
        if isinstance(value, Field):
            value.name = "%s.%s" % (cls.__name__, key)
            fields[key] = value
    for base in cls.__bases__:
        if hasattr(base, "_fields"):
            fields.update(base._fields)
    cls._fields = fields
    return cls

@model
class A():
    foo = IntegerField()

class B(A):
    bar = CharField()
```

但是用装饰器的话，就失去了一些类型继承的语义信息。

## 总结与思考

Python 中的元编程还是一种很强大的特性，但是也比较复杂，有时候很难以理解。实际上，过分的动态特性也导致了 Python 的解释器和静态分析、自动补全等很难优化，因为有好多信息必须到运行时才能知道。

实际上近些年新开发的语言越来越多地加入了静态类型的特性，比如 swift, rust, go 等。就连 Python 本身也增加了 type hinting 的功能，很遗憾的是，这个功能不是强制性的，所以也很难用来提升性能。

元类这块应该是我在 Python 语言方面了解的最后一大块知识了。接下来除了写业务代码不会再深究 Python 了，研究 Golang 去了~

Au revoir, Python!

## 参考

1. https://realpython.com/python-metaclasses/
2. https://stackoverflow.com/questions/392160/what-are-some-concrete-use-cases-for-metaclasses
3. https://blog.ionelmc.ro/2015/02/09/understanding-python-metaclasses/
4. https://stackoverflow.com/questions/2608708/what-is-the-difference-between-type-and-type-new-in-python



