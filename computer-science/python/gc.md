Date: 2018-07-19

一般来说，垃圾回收有两种算法：引用计数和标记删除。

## 引用计数（reference counting）

CPython 中默认使用的垃圾回收算法是 Reference Counting。也就是对每个元素标记有多少个其他元素引用了它，当引用数降到零的时候就删除。

1. 当对象增加一个引用，比如赋值给变量，属性或者传入一个方法，引用计数执行加 1 运算。
2. 当对象减少一个引用，比如变量离开作用域，属性被赋值为另一个对象引用，属性所在的对象被回收或者之前传入参数的方法返回，引用计数执行减 1 操作。
3. 当引用计数变为 0，代表该对象不被引用，可以标记成垃圾进行回收。

为了解决循环引用的问题，CPython 使用了 Cyclic GC，遍历所有的环，并且把每一个元素的引用减一，来检测每一个引用环是不是循环应用。

![](https://tva1.sinaimg.cn/large/006tKfTcly1ftg5mu2087j30we0i6gv5.jpg)

## 标记删除（Mark and Sweep）

1. 从某一个已知的还活着的对象开始，便利对象，如果经过了某个对象就认为是活着的
2. 如果没有被标记的就删除

避免了循环引用的问题

![](https://tva1.sinaimg.cn/large/006tKfTcly1ftf9x2kejlj30wo0ic11s.jpg)

实际的处理过程

![](https://tva1.sinaimg.cn/large/006tKfTcly1ftfa55k2e7j30wi0ick3k.jpg)

![](https://tva1.sinaimg.cn/large/006tKfTcly1ftfa6amfmmj30wc0iedr8.jpg)

Pluggable
Generational
Incremental

## 参考资料

1. https://www.youtube.com/watch?v=iHVs_HkjdmI
2. https://droidyue.com/blog/2015/06/05/how-garbage-collector-handles-circular-references/
3. https://www.cnblogs.com/Xjng/p/5128269.html
4. https://foofish.net/python-gc.html