# Go 语言 Map 实战


wp_id: 788
Status: publish
Date: 2019-10-22 09:46:33
Modified: 2020-05-16 10:48:14


相比 Rust 中尚未实现 IndexMut 的 Hash 类型来说，Go 中的 Map 实现度可以说是非常高了。

# 基本用法

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

# 并发性

map 不是线程安全的。