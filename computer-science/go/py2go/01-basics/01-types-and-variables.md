# 类型与变量

<!--
ID: 866fba1f-205c-4218-bdea-46e3866fc6a3
Status: draft
Date: 2019-11-25T00:00:00
Modified: 2020-05-28T14:09:32
wp_id: 1132
-->

Python 是一个动态强类型的语言，而 Golang 则是一门静态强类型的语言。

## 声明与赋值

在 Python 中是不区分变量声明和赋值的，创建变量只有赋值一种方式。

```py
a = 1
a: int = 1  # 加上 type hint
```

而在 Golang 中，两者是可以分开的。其实大多数语言都是这样的。

```go
var i int  // 声明一个变量
i = 42  // 赋值
```

或者直接使用简写：

```go
i := 42  // 声明并赋值
```

## 作用域

我们知道，在 Python 中只有「函数」一种作用域，而且由于只有赋值一种声明变量的方式，所以有时候需要 nonlocal 或者 global 才能访问函数外的变量，否则就变成声明新变量了，而且还要考虑变量是 mutable 还是 immutable 的。比如下面的例子：

```py
count = 0

def incr():
    global count
    count += 1
```

在 Golang 中，作用域是块级别的，也就是一个大括号就开启一个作用域。而且因为 Golang 的定义和赋值是可以分开的，所以也就不存在使用 global 这种关键字的场景。

## 数据类型

Golang 有四种类型：基础类型、聚合类型、引用类型和接口类型。这里先介绍基础类型。

Python 中的 None, True, False 分别对应 nil, true, false.

几乎所有的值提供了默认都会初始化到对应的零值，即使没有初始化，不少函数处理 nil 的时候也是按照零值处理，这样避免了好多无谓的异常抛出。在 go 中也不会遇到 len(None) 这种问题，即使`len(nil)`也会返回 0。

## 数字类型

整型包括了：int, int8/16/32/64, uint, uint8/16/32/64 几种类型。另外 byte 是 uint8 的别名，rune 是 int32 的别名。

浮点型也包括了：float32 和 float64 两种类型，注意没有单独的 float/double 类型。其中 math.MaxFloat32 和 math.MaxFloat64 表示最大值。默认的浮点数是 float64。

Go 中还包含了复数类型：complex64 和 complex128，不过就像 Python 中的复数类型一样，从来没用过。

在使用整形变量时，还是尽量使用 int，没事儿别用 uint。比如定义了 size 函数，虽然返回的合法值都是 uint 范围内的，但是可能使用 -1 等表示非法值。所以除非要使用比特位操作，尽量使用 int，而不是 uint。

## 字符串

Golang 中的字符串实际上是 utf-8 的 bytes 数组，而不是 unicode code point 的数组。如果使用索引访问的话，是按照 byte 为单位来访问的。但是在打印和 range 的时候会直接按照 utf-8 解码输出。如果需要按照 rune（Go 语言对 unicode code point 的称呼）来遍历，需要使用 `unicode/utf8` 这个包中的函数。

```go
s := "世界"

len(s)  // -> 6，utf-8 编码的中文一般是 3 个字节。
utf8.RuneCountInString(s)  // -> 2

// 使用 range 遍历就会按照实际的 Unicode 遍历，而不是按照 byte
for r := range s {
    fmt.Printf("%s", r)
}

// 使用 DecodeRuneInString
for i := 0; i < len(s) {
    r, size := utf8.DecodeRuneInString(s[i:])
    fmt.Printf("%d\t%c\n", i, r)
    i += size
}

// 全部转换成 rune
r := []rune(s)
fmt.Printf("%x\n", r)
```

即使字符串不是 utf-8 的，或者不管怎样用错了编码，至少不会报错，而是把不能解析的字符替换成 \uFFFD。而 Python 中时不时就会抛出 UnicodeDecodeError，非常蛋疼。

Go 语言中的字符串函数并没有作为 string 类型的方法，而是单独放在了 `strings` 包中，比如 `strings.Split`，`strings.Join` 函数。因为 `[]byte` 类型和 string 类型也比较类似，因此 `strings` 包中提供的方法，在 `bytes` 包中也可以找到类似的。

## 指针



## 参考

1. https://medium.com/golangspec/scopes-in-go-a6042bb4298c