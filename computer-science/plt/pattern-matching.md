# 函数式编程中的 Pattern Matching (模式匹配)


wp_id: 326
Status: publish
Date: 2018-04-26 09:18:00
Modified: 2020-05-16 11:36:42


以 haskell 为例，简单来说，pattern 就像是数学中的分段函数。通过使用 pattern matching，就可以对不同的参数定义不同的函数体。当调用函数的时候，可以通过对比实参和形参的模式就可以选择正确的函数体。

比较一下

<img src="https://ws3.sinaimg.cn/large/006tKfTcly1fqq6q36pkij30aq02cglo.jpg" max-width="400px" />


和对应的 haskell 代码：

```
fib 0 = 1
fib 1 = 1
fib n | n >= 2 
      = fib (n-1) + fib (n-2)
```

注意在分段函数中 "n ≥ 2" 这个条件在 haskell 中变成了一个 guard。但是另外两个条件就是简单的 pattern。Pattern 就是可以测试值和结构的条件，比如 `x:xs`, `(x, y, z)`, 或者 `x`。在一个分段函数定义中，基于 `=` 或者 `∈` 的条件会变成简单的 pattern，而其他的更广义的条件会变成 guard。如果用 guard 来重写一下上面的函数：

```
fib n | n == 0 = 1
      | n == 1 = 1
      | n >= 2 = fib (n-1) + fib (n-2)
```

# 和 switch/ifelse 语句的区别

1. 编译器可以替你检查你是否覆盖了所有情形
2. 可以直接把 pattern match 作为一个赋值语句
3. 如果你有一个不同类型复合的变量，每一个匹配结果都会有不同的类型
4. 使用 pattern matching 在某些情况下要简洁得多[4]

# REF

1. https://stackoverflow.com/questions/2225774/haskell-pattern-matching-what-is-it
2. https://www.zhihu.com/question/22344888
3. https://stackoverflow.com/questions/199918/explaining-pattern-matching-vs-switch
4. https://hongjiang.info/scala-pattern-matching-1/