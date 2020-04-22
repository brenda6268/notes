# 函数

```go
func add(a int, b int) int {
    return a + b
}
```

Golang 的函数也可以返回多个值，但是和 Python 不一样的是，这个是一个语法特性，没有使用 tuple 这种机制。

```go
func vals() (int, int) {
    return 3, 7
}

a, b := vals()
```

interface{}

函数应该接受 interface 作为参数，并使用 struct 作为返回值。

## 参考

1. https://gobyexample.com/multiple-return-values