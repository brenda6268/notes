# 复合类型与控制语句

Date: 2019-11-25

Go 中内置的复合类型主要有三种：Array, Slice 和 Map。分别对应了其他语言中的定长数组、变长数组（切片）和字典。

像是 C 语言一样，Go 中也有定长数组，`var a [3]int`。在 Go 中经常作为变长数组使用的是 Slice。Slice 指的是一个数组的一个切片。在 Go 语言中，默认的函数调用都是值传递的，但是 Slice 做参数的时候传递的是一个 Slice Header，也就相当于按照引用传递。Map 类型是引用类型，也就是函数调用的时候是按照引用传递的。nil map 可以像空 map 一样使用，但是**插入的时候会 panic**，因为没有给他分配内存，所以 map 类型一般使用 make 初始化。

向 nil 的 slice 中直接存入元素是不合法的，向 nil 的 map 中直接存入元素也是不合法的。所以最好使用 make 来声明 slice 和 map。

```go
m := make(map[string]int)
```

## 定长数组

数组的类型是 `[x]type`，数组的长度和成员的类型都是数组类型的一部分。比如 `[1]int` 和 `[2]int` 是不同的类型。和 Python 对比的话，有点类似于成员可变的固定类型的 tuple。
 
而 Python 中的所有数组都是一个类型 `list`，完全和元素的类型和数组长度无关。

用 C++ 的泛型来说，Golang 中的数组相当于 `std::array`，也就是 `template<class T, std::size_t N> struct array;`。
 
```python
>>> nums = [2, 3, 4]
>>> type(nums)
list
```
 
```go
// 在 Golang 中必须声明数组的长度，否则创建的是 slice，下面会讲到。
nums := [3]int{2, 3, 4}
fmt.Println(reflect.TypeOf(nums))
// [3]int

var a [3]int = [3]int{1, 2, 3}
b := [3]int{1, 2, 3}
c := [...]int{1,2,3}  // 使用 ... 来表示自动推倒长度
d := [...]{99: -1}
```
 
理论上来说，Python 中的元素还可以使用不同类型，也就是 `a = ["hello", 1, True]` 的形式，但是以我使用 Python 七年的经验来看，实际代码中从来没有这种需要。由于 Python 中 list 还需要存储每个元素的类型信息，也就导致了运行时的更多负担，这也是 Python 比较慢的一个原因。

如果数组的元素是可以比较的 (comparable)，那么数组也是也以比较的，也就是可以用来做 map 的 key。默认情况下，数组是按照**值传递**的，这一点和 C 语言默认传递指针不一样，这也是为什么说类似于 Python 中的 tuple。

## 切片——变长数组

与好多脚本语言一样，Go 也支持切片操作：`a[i:j]`。不过和其他语言不一样的是，Go 的切片操作符产生了新的类型——切片，而不是子数组。在 Python 中，切片操作实际上是对数组的一个浅拷贝，这一点和 Golang 是完全相反的。Golang 中切片是**对源数组的部分元素的一个引用**，或者说一个 view，他们指向的是同一个内存单元。有意思的是，对于 numpy 来说，slice 操作返回的是一个 view，而不是新的拷贝对象。

实际上，在 Python 中用到 list 的场景一般对应到 Golang 中是 slice。
 
Python 中没有单独的 slice 类型，也就无从谈起类型了。在 Golang 中，切片的类型是由其中的元素决定的，和长度无关。

```go
s := make([]string, 3)
 
s = append(s, "e", "f")
```

切片可以当做一个变长数组使用。实际上，一般我们不会每次都构造一个数组，然后获取切片，而是直接使用切片字面量。

```go
a = []int{1, 2, 3}
```

和数组字面量很像，区别是没有指定长度。和数组不同的一点是，切片是不能比较的，不管他内部的元素是什么。这一点也好理解，Python 的 list 也是不能比较的，tuple 就可以。

Slice 底层引用了数组，但是并不会自动扩容，因此想往其中添加元素需要注意不能越界，要提前扩充容量。可以使用 make 函数提前指定大小，或者使用 append 函数动态扩展切片大小。

```go
make([]int, len)
make([]int, len, cap)

var x []int
x = append(x, 1)
```

记得一定要使用 append 函数，而不要直接在 slice 的结尾通过下标添加字符，这样可能会 panic

## Map

Go 语言也原生支持字典。

```go
a := make(map[string]int)
a := map[string]int {
    "alice": 12,
    "bob": 12,
}
```

Go 语言和其他语言不同的是，尝试**访问不存在的键也不会报错**，而是会返回对应类型的零值，不过可以采用两个参数来验证是否存在这个键。

```go
a["foo"] = 1
v := a["foo"]
v, ok := a["foo"]  // 左值不同竟然会影响操作，真是魔幻啊。虽然可以用泛型理解，但是 Golang 中既没有 tuple 也没有泛型啊。

if v, ok := a["foo"]; ok {
    fmt.Print(v)
}
```

相比 Rust 中尚未实现 IndexMut 的 Hash 类型来说，Go 中的 Map 实现度可以说是非常高了。

### 基本用法

Map 的类型是 `map[KeyType]ValueType` 的。也就是由 Key 类型和 Value 类型同时决定的。声明一个 Map：

```go
var m map[string]int
```

不过一般很少有人这样写，还是声明并赋值比较常见，还是使用我们的 make 函数：

```go
m = make(map[string]int)
```

```go
commits := map[string]int{
    "rsc": 3711,
    "r":   2138,
    "gri": 1908,
    "adg": 912,
}
```

基本上除了 slice，map 和 function 以外，都可以做 map 的键。

删除值

```go
delete(m, "route")  // 如果不存在的话，也不会抛出异常。这里和 Python 不一样
```

map 不是线程安全的，或者说 not goroutine-safe。

## 结构 (Struct)

Golang 中还可以自定义数据结构，类似于 C 中常用的 `typedef struct{}` 的风格。

```go
type A struct {
    foo int
    bar int
}
```

Golang 中也有指针的概念，不过没有 `->` 这个关键字，即使是需要引用，也统一使用 `.` 操作，golang 会做自动解引用。如果一个 struct 中的所有字段都是可以比较的，整个 struct 就也是可以比较的。

## 控制语句

go 还从 C 中 继承了 `if (p = fopen("xxx", "w")) != NULL` 这种在把赋值语句写在 if 中的写法，不过好在 Go 语言中可以写做两句。

```go
if err := r.ParseForm(); err != nil {
    //...
}
```

另外 switch 语句默认就会 break 了，而不是 fall through 了。

### 循环

循环语句很有意思，Golang 直接把 while 关键字扔掉了，只用 for 本身就够了

```go
for {
// ...
}
```

就相当于其他语言中的 `while(true)` 了。

不管是 Python 中的 for...in... 还是 JavaScript 中的 for...of... 语句，迭代数组和字典的时候多少感到一些不一致。在 Golang 中，还是比较统一的，每次迭代都会返回两个值：key，value。

迭代 slice

```go
words := []string{"a", "b"}
for i, word := range words {
    fmt.Printf("%d -> %s", i, word)
}
```

迭代 map

```go
words := map[string]string {
    "a": "a",
    "b": "b",
}

for k, v := range words {
    fmt.Printf("%s -> %s", k, v)
}
```
 
注意到我们使用了 range 语句
 
```go
for k, v := range myMap {
    fmt.Printf("%s -> %s\n", k, v)
}
 
for k := range myMap {
    fmt.Println("key:", k)
}
 
for i, c := range "go" {
    fmt.Println(i, c)
}
 
func sum(nums ...int) {
    fmt.Print(nums, " ")
    total := 0
    for _, num := range nums {
        total += num
    }
    fmt.Println(total)
}
 
func sum(nums ...int) {
    fmt.Print(nums, " ")
    total := 0
    for _, num := range nums {
        total += num
    }
    fmt.Println(total)
}
```

## 排序

```go
ints := []int{7, 2, 4}
sort.Ints(ints)
fmt.Println("Ints:   ", ints)
```

## 参考

https://blog.golang.org/go-slices-usage-and-internals