Date: 2019-11-25

# 数据结构与控制语句

## 概念


## 数组
 
Golang 中数组当然是有类型的。数组的类型由两部分表示：1. 数组中元素的类型；2. 数组的长度。用 C++ 的泛型来说，Golang 中的数组相当于 `std::array`，也就是 `template<class T, std::size_t N> struct array;`。
 
而 Python 中的所有数组都是一个类型 `list`，完全和元素的类型和数组长度无关。
 
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
```
 
理论上来说，Python 中的元素还可以使用不同类型，也就是 `a = ["hello", 1, True]` 的形式，但是以我使用 Python 七年的经验来看，实际代码中从来没有这种需要。由于 Python 中 list 还需要存储每个元素的类型信息，也就导致了运行时的更多负担，这也是 Python 比较慢的一个原因。
 
## 切片 slice
 
在 Python 中，对数组执行切片操作返回的是一个新的数组。而在 Golang 中执行切片操作返回的是一个切片对象，也就是说对于数组的一个 view（视图）。实际上，**Golang 中的 slice 和 Python 中的 list 行为更加类似**。值得注意的是，对于 numpy 来说，slice 操作返回的是一个 view，而不是新的拷贝对象。
 
Python 中没有单独的 slice 类型，也就无从谈起类型了。在 Golang 中，切片的类型是由其中的元素决定的，和长度无关。

slices are only typed by the elements the contain, not the length.

```go
s := make([]string, 3)
 
s = append(s, "e", "f")
```
 
## 字典 map
 
```go
m := make(map[string]int)
```

相比 Rust 中尚未实现 IndexMut 的 Hash 类型来说，Go 中的 Map 实现度可以说是非常高了。

### 基本用法

Map 的类型是 `map[KeyType]ValueType` 的。也就是由 Key 类型和 Value 类型同时决定的。声明一个 Map：

```go
var m map[string]int
```

不过一般很少有人这样写，还是生命并赋值比较常见，还是使用我们的 make 函数：

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

赋值

```go
m["route"] = 66
```

获取值

```go
i := m["route"]  // 如果 route 不存在，那么获取的就是对应的零值
j := m["non-exist"]
```

删除值

```go
delete(m, "route")  // 如果不存在的话，也不会抛出异常。这里和 Python 不一样
```

判断是否存在

```go
i, ok := m["route"]
```

遍历

```go
for key, value := range m {
    fmt.Println("Key:", key, "Value:", value)
}
```

### 并发性

map 不是线程安全的。
 
## range
 
```go
for k, v := range kvs {
        fmt.Printf("%s -> %s\n", k, v)
    }
 
for k := range kvs {
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

ints := []int{7, 2, 4}
    sort.Ints(ints)
    fmt.Println("Ints:   ", ints)


NewPerson constructs a new person struct with the given name
You can safely return a pointer to local variable as a local variable will survive the scope of the function.

```go
func NewPerson(name string) *person {
    p := person{name: name}
    p.age = 42
    return &p
}
```

structs 勉强可以对应python里的dataclass，也是用大括号初始化。从这点上可以看到 golang还是相当统一的。


https://blog.golang.org/go-slices-usage-and-internals