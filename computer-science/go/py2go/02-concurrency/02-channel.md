Date: 2019-11-25

# Channel

Python 中线程之间或者进程之间可以通过使用对应的 queue/multiprocessing.Queue 来通信。而在 Golang 中类似的机制叫做 channel。语法是：`make(chan T)`

发送消息：`go func() { messages <- "ping" }()`

接收消息：`msg := <-messages`

接受会 block 住，直到收到一条消息位置，有点像 queue.get

## 方向性

chan 还是有方向性的：

1. `chan<- string` 只能发送
2. `<-chan string` 只能接收

默认情况下，go channel 是 unbuffered，也就是说没有缓冲，也就是容量为 0. 那么必须有函数接受，才能发送出去。这点和 Python 是完全相反的，Python 中 queue 是默认容量不限制的，也就是 put 只受内存大小的限制。

在 make 的时候添加一个数字可以实现 buffered channel

```go
messages := make(chan string, 2)
```

这样在发送消息的时候，如果 channel 没有满，就会直接返回而不会阻塞了。

## 同步

可以使用 chan 作为协程之间同步的简单机制。在主函数中等待另一个 goroutine 结束时候发送信号。

## select

select 作为一个系统调用是可以用来从多个监听的 socket 中读取信息。Golang 中提供了一个 select 关键字，可以用于从多个 channel 中读取信息。同 select 系统调用一样，select 关键字也会一直 block 到读到的第一个消息为止。

```go
select {
case msg1 := <-c1:
    fmt.Println("received", msg1)
case msg2 := <-c2:
    fmt.Println("received", msg2)
}
```

## 超时机制

我们知道在 Python 的 queue.get 中可以指定 timeout，在 Golang 中可以使用 select 机制实现超时。

```go
select {
case res := <-c1:
    fmt.Println(res)
case <-time.After(1 * time.Second):
    fmt.Println("timeout 1")
}
```

## 非阻塞性 select

只需要提供一个 default 语句就可以实现非阻塞性的 select

```go
select {
case msg := <-messages:
    fmt.Println("received message", msg)
default:
    fmt.Println("no message received")
}
```

## 遍历一个 channel

只要 close 一个 channel 就会退出啦。而且每个遍历这个 channel 的 goroutine 都能收到这个信号，在 Python 中要实现这一点就比较 tricky 了，可能需要一个特殊的哨兵变量。

## 使用 Channel 控制并发

除了使用 WaitGroup 之外可以使用 channel 来等待 Goroutine 执行完毕。

```go

func main() {
    done := make(chan struct{})
    defer close(done)
    go func() {
        work()
        done <- struct{}{}
    }
    <- done
}
```
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

