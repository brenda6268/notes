# Go 语言处理大文件


<!--
ID: bee96623-9d10-446b-a0a2-cc3e4dbc84b0
Status: publish
Date: 2018-06-18T11:51:20
Modified: 2020-05-16T11:08:50
wp_id: 747
-->


日常开发中，总有一些文件或者数据过于大而无法放到内存中。在 Python 中，我们可以构造生成器，从而在迭代过程中动态生成元素。而在 Go 语言中没有也不鼓励使用迭代器这种模式，但是观察标准库和一些常见的库，可以看到一些常用的模式。

# 使用 slice

把所有数据放到一个 slice 中

# 使用闭包（closure）

```go
package main
import "fmt"
func main() {
    iter := NewEven()
    fmt.Println(iter())
    fmt.Println(iter())
    fmt.Println(iter())
    gen = nil // release for garbage collection
}
func NewEven() func() int {
    n := 0
    // closure captures variable n
    return func() int {
        n += 2
        return n
    }
}
```

# 使用有状态的自定义类型的方法

如果不想使用 closure 来保存状态的话，可以使用一个类型来表示。

```go
package main
import "fmt"
func main() {
    gen := even(0)
    fmt.Println(gen.next())
    fmt.Println(gen.next())
    fmt.Println(gen.next())
}
type even int
func (e *even) next() int {
    *e += 2
    return int(*e)
}
```


不过一般来说复杂一点的对象都会使用 Next() 和 Value() 两个方法，方便在 for 循环中使用，其中 Next() 函数返回是否

```go
package main

import "fmt"

type Range struct {
    start int
    stop int
    step int
    current int
}

func (r *Range) Next() bool {
    return r.current < r.stop
}

func (r *Range) Value() int {
    c := r.current
    r.current += r.step
    return c
}

func main() {
    r := Range{0, 100, 10}
    for r.Next() {
        fmt.Printf("value is %d", r.Value()
    }
}
```

## channel

```go
package main

import "fmt"

func Range(start int, stop int, step int) <-chan int {
    ch := make(chan int)
    go func() {
        for i := start; i < stop; i+= step {
		    ch <- i
        }
        close(ch) // Remember to close or the loop never ends!
    }()
    return ch
}

func main() {
    for i := range Range(0, 100, 10) {
        fmt.Printf("value is %d", i)
    }
}
```

# 性能

一般来说，使用 channel 和 closure 的性能不好，而使用有状态的类型性能更好一点。

https://stackoverflow.com/questions/14000534/what-is-most-idiomatic-way-to-create-an-iterator-in-go



