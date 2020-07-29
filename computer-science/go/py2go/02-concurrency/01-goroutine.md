# Goroutine

<!--
ID: 1922b0bb-3a96-4a1a-a47d-d99b07593ea0
Status: draft
Date: 2019-11-25T00:00:00
Modified: 2020-05-28T14:09:32
wp_id: 1136
-->

我们知道 CPython，也就是 Python 的官方实现有三种并发机制：线程、进程和协程。其中线程和进程都是系统原生的，但是很遗憾的是 CPython 中由于 GIL 的存在，线程实际上只能利用到单核的计算性能。而协程则是 Python 3 之后新增加的并发机制，所有协程在单线程中运行，但是不由系统抢占调度，而是由程序员主动使用 `await` 调度。关于这些知识就不多说了，不懂的可以查相关资料。

Golang 的并发机制有些特殊，和所有语言都不一样，并没有提供这三种中的任何一种，而是融合了三个的优点，创造了 goroutine 这种机制。Goroutine 可以说是 Golang 的精华所在了，即使到现在你也不喜欢 Golang 的语法，对于 Goroutine 的使用和实现都是绝对不要错过的，非常有借鉴意义，比如说 Rust 中的 Tokio 的 scheduler 就参考了 Golang 的 scheduler。

Go 中的任何一个函数都可以直接使用 go 关键字运行，这点相对于 threading.Thread 简单多了。

Goroutine 相对于 Python 的 coroutine 有两点优点：

1. 它是抢占的，不用主动交出。
2. 它可以运行在多个核上，而不像 Python 中只有主线程中的一个 loop 运行。

Python 的 coroutine 需要特别小心不要调用阻塞性的函数，比如 time.sleep，而要使用 asyncio.sleep，所以写起来是非常不方便。Python 必须使用 await 来显式交出控制，而 Go 中则没有这种限制。

## 等待完成

使用 WaitGroup 的 Add() Done() Wait() 三个操作可以实现任务控制，同时等待多个 goroutine 完成。

```go
package main

import (
    "fmt"
    "sync"
    "time"
)

func worker(id int, wg *sync.WaitGroup) {
    defer wg.Done()
    fmt.Printf("Worker %d starting\n", id)
    time.Sleep(time.Second)
    fmt.Printf("Worker %d done\n", id)
}

func main() {

    var wg sync.WaitGroup
    for i := 1; i <= 5; i++ {
        wg.Add(1)
        go worker(i, &wg)
    }

    wg.Wait()
}
```

另一种方式是使用 channel 控制并发，参见下一节。
