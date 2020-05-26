# Go 语言初体验


ID: 729
Status: publish
Date: 2018-05-02 02:54:00
Modified: 2020-05-16 11:38:23


# 安装与配置

安装 go 很简单，在 mac 上直接使用 `brew install go` 就可以了。注意的是需要设定GOPATH这个环境变量，如果不设定。默认就到了 `~/go` 这个目录。GOPATH 中也可以设置多个目录，默认安装包会安装到第一个路径。不过现在

```
export GOPATH=$HOME/lib:$HOME/go
```

# 语法和风格

Golang 的整个语法还是极其简单的，基本是 C 和 Python 的混合体。Go 语言详尽地规定了代码的风格，所以就不用为了大括号究竟是放在哪儿而开始圣战了。Go 语言对程序员的约束很强，不容易犯错。

Go 语言官方提供了一个工具 goimports 用来管理 import 语句，还不错。

import进来的包必须使用，声明的变量也必须使用。import 语句必须在 package 语句后面。虽然有大括号，但是大括号的位置也是指定的。

# 类型

Go 语言有四种类型：基础类型、聚合类型、引用类型和接口类型。

```go
var i int  // 声明一个变量
i = 42  // 赋值
```

或者直接使用简写：

```go
i := 42  // 声明并赋值
```

几乎所有的值提供了默认都会初始化到对应的零值，即使没有初始化，不少函数处理 nil 的时候也是按照零值处理，这样避免了好多无谓的异常抛出。在go中也不会遇到len(None)这种问题，即使`len(nil)`也会返回0。

## 基础类型

整型包括了: int, int8/16/32/64, uint, uint8/16/32/64 几种类型。另外 byte 是 uint8 的别名，rune 是 int32 的别名。

比如定义了 size 函数，虽然返回的合法值都是 uint范围内的，但是可能使用 -1 等表示非法值。所以除非要使用比特位操作，尽量使用 int，而不是 uint。

浮点型也包括了：float32 和 float64 两种类型，注意没有单独的 float/double 类型。其中 math.MaxFloat32 和 math.MaxFloat64 表示最大值。默认的浮点数是 float64。

Go 中还包含了复数类型：complex64 和 complex128，不过就像 Python 中的复数类型一样，从来没用过。

## 字符串

值得一提的是 Go 中的字符串，实际上是一个 byte 的只读数组，如果使用索引访问的话，是按照 byte 为单位来访问的。但是在打印和 range 的时候会直接按照 utf-8 解码输出。如果需要按照 rune（Go 语言对 unicode code point 的称呼）来遍历，需要使用 `unicode/utf8` 这个包中的函数。

即使字符串不是 utf-8的，或者不管怎样用错了编码，至少不会panic，而python中时不时就会抛出UnicodeDecodeError 。

不用思考蛋疼的 Unicode 问题，不过虽然 Go 的 string 是 utf-8 的，但是使用下标访问的是字节，而使用 for range 访问的又是 rune。

Go 中的字符串，实际上是一个 byte 的只读数组，如果使用索引访问的话，是按照 byte 为单位来访问的。但是在打印和 range 的时候会直接按照 utf-8 解码输出。如果需要按照 rune（Go 语言对 unicode code point 的称呼）来访问，需要使用 unicode/utf8 这个包中的函数。


## 复合类型

Go 中内置的复合类型主要有三种：Array, Slice 和 Map。分别对应了其他语言中的定长数组、边长数组（切片）和字典。

像是 C 语言一样，Go 中也有定长数组，`var a [3]int`。

在 Go 中经常作为变长数组使用的是 Slice。Slice 指的是一个数组的一个切片。在 Go 语言中，默认的函数调用都是值传递的，但是 Slice 做参数的时候传递的是一个 Slice Header，也就相当于按照引用传递。

Map 类型是引用类型，也就是函数调用的时候是按照引用传递的。nil map 可以像空map一样使用，但是插入的时候会 panic，因为没有给他分配内存，所以 map 类型一般使用 make 初始化。

```
m := make(map[string]int)
```

### 数组

数组的类型是 `[x]type`，比如 `[1]int` 和 `[2]int` 是不同的类型

```go
var a [3]int = [3]int{1, 2, 3}
b := [3]int{1, 2, 3}
c := [...]int{1,2,3}
d := [...]{99: -1}
```

如果数组的元素是可以比较的(comparable)，那么数组也是也以比较的，也就是可以用来做 map 的 key。

默认情况下，数组是按照值传递的，这一点和 C 语言默认传递指针不一样。

向 nil 的 slice 中直接存入元素是不合法的，向 nil 的 map 中直接存入元素也是不合法的。所以最好使用 make 来声明map。

### 切片——变长数组

像是好多动态语言一样，Go 也支持切片操作：`a[i:j]`。不过和其他语言不一样的是，Go 的切片操作符产生了新的类型：切片，而不是数组。切片是对源数组的部分元素的一个引用。他们指向的是同一个内存单元。

切片可以当做一个变长数组使用，实际上我们不会每次都构造一个数组，然后获取切片，而是直接使用切片字面量。

```go
a = []int{1, 2, 3}
```

和数组字面量很像，区别是没有指定长度。

和数组不同的一点是，切片是不能比较的，不管他内部的元素是什么。

Slice 底层引用了数组，但是并不会自动扩容，因此想往其中添加元素需要注意不能越界，提前扩充容量。可以使用 make 函数提前指定大小，或者使用 append 函数动态扩展切片大小。

```go
make([]T, len)
make([]T, len, cap)


var x []int
x = append(x, 1)
```


### Map

Go 语言也原生支持字典。

```go
a := make(map[string]int)
a := map[string]int {
    &quot;alice&quot;: 12,
    &quot;bob&quot;: 12,
}
```

Go 语言和其他语言不同的是，尝试访问不存在的键也不会报错，而是会返回对应类型的零值，不过可以采用两个参数来验证是否存在这个键

```go
v := a[&quot;foo&quot;]
v, ok := a[&quot;foo&quot;]

if v, ok : a[&quot;foo&quot;]; ok {
    fmt.Print(v)
}
```

## 控制语句

go 还从 C 中 继承了 `if (p = fopen("xxx", "w")) != NULL` 这种在把赋值语句写在if中的写法，不过好在 Go 语言中可以写做两句。

```
if err := r.ParseForm(); err != nil {
      //...
}
```

另外 switch 语句默认就会 break 了，而不是 fall through 了。

循环语句很有意思，Go 语言直接把 while 关键字扔掉了，只用 for 本身就够了

```
for {
// ...
}
```

就相当于其他语言中的 while(true) 了。

不管是 Python 中的 for...in... 还是 JavaScript 中的 for...of... 语句，迭代数组和字典的时候多少感到一些不一致。在 Go 语言中，还是比较统一的，每次迭代都会返回两个值：key， value。

迭代 slice
```
words := []string{&quot;a&quot;, &quot;b&quot;}
for i, word := range words {
    fmt.Printf(&quot;%d -&gt; %s&quot;, i, word)
}
```

迭代 map
```
words := make(map[string]string)
words[&quot;a&quot;] = &quot;a&quot;
words[&quot;b&quot;] = &quot;b&quot;
for k, v := range words {
    fmt.Printf(&quot;%s -&gt; %s&quot;, k, v)
}
```

# goroutine

goroutine 相对于 Python 的 coroutine 的好处就在于它是抢占的，不用主动交出。

Python 的 coroutine 需要特别小心不要调用阻塞性的函数，比如 time.sleep，而要使用asyncio.sleep，所以写起来不是非常得方便。Python必须使用 await 来显式交出控制，而 Go 中则没有这种限制。

## Timers and tickers

Timers 定义在你在未来的某个时间想要去做一次某件事。而 Tickers 则是定期执行某一个动作。这两个有点像是 js 里面的 setTimeout 和 setInterval 两个函数。

defer 实际上就相当于 C++ 中的RAII，和Python中的 with 语句

Go 的类型总体来说，和 Python 的 duck type 有点像，而和 Java 严格的继承则是完全背道而驰的。

发生赋值时候会不会检查类型呢？

interface{}

# io

一般读取统一从 io.Reader 类型中读取

记得一定要使用append函数，而不要直接在slice的结尾通过下标添加字符，这样可能会panic

函数应该接受 interface 作为参数，并使用 struct 作为返回值。

目前为止有几个不爽的地方

1. nil 字典不能直接赋值，但是 nil slice 可以 append
2. interface 的 nil 始终没有搞明白。empty slice(a[0:0]) 和 nil 也不一样
3. 没有一个统一的包管理工具，刚刚花一下午时间学习了 dep，号称是官方的试验，结果又看到一篇文章说 vgo 要取代 dep，WTF
4. defer 执行的地方是函数的结尾，而不是块的结尾

# 数据类型

```go
s := &quot;世界&quot;

len(s)  // -&gt; 6，utf-8 编码的中文一般是3个字节。
utf8.RuneCountInString(s)  // -&gt; 2

// 使用 range 遍历
for r := range s {
    fmt.Printf(&quot;%s&quot;, r)
}

// 使用 DecodeRuneInString
for i := 0; i &lt; len(s) {
    r, size := utf8.DecodeRuneInString(s[i:])
    fmt.Printf(&quot;%d\t%c\n&quot;, i, r)
}

// 全部转换成 rune
r := []rune(s)
fmt.Printf(&quot;%x\n&quot;, r)
```

即使字符串不是 utf-8的，或者不管怎样用错了编码，至少不会 panic，而是把不能解析的字符替换成 \uFFFD。而python中时不时就会抛出UnicodeDecodeError，非常蛋疼。

Go 语言中的字符串函数并没有作为 string 类型的方法，而是单独放在了 `strings` 包中，比如 `strings.Split`，`strings.Join` 函数。因为 `[]byte` 类型和 string 类型也比较类似，因此 `strings` 包中提供的方法，在 `bytes` 包中也可以找到类似的。

## 复合类型


### Struct

定义一个 struct 如下：

```go
type A struct {
    foo int
    bar int
}
```

Go 中也有指针的概念，不过没有 `->` 这个关键字，统一使用 `.` 操作。如果一个 struct 中的所有字段都是可以比较的，整个 struct 就也是可以比较的。

####  Struct 嵌入

Go 语言支持一种特殊的骚操作，叫做 struct 嵌入。这样一个 struct 就可以直接调用被嵌入的 struct 的属性和方法，听起来有点像继承，而且的确实现了继承的功能，但的确不是继承，而是复合。

Go 语言是一门有 gc 的语言，所以所有变量的生命周期并不是严格限定于作用域的，由编译器来决定使用栈上还是堆上的空间。

在 Go 语言中没有 private 和 public 这些关键字。如果变量名字是大写字母开头的，那么就是导出的，如果是小写字母开头的，那么就是包内私有的变量。


参考：

https://stackoverflow.com/questions/18058164/is-a-go-goroutine-a-coroutine