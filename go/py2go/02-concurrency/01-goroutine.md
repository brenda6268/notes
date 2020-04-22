# Goroutine

我们知道 CPython，也就是 Python 的官方实现有三种并发机制：线程、进程和协程。其中线程和进程都是系统原生的，但是很遗憾的是 CPython 中由于 GIL 的存在，线程实际上只能利用到单核的计算能来。而协程则是 Python 3 之后新增加的并发机制，所有协程在单线程中运行，但是不是由系统抢占调度，而是由程序员主动使用 await 调度。关于这些知识就不多说了，不懂的可以查相关资料。

Golang 的并发机制有些特殊，并没有提供这三种中的任何一种，而是融合了三个的优点，创造了 goroutine 这种机制。

Go 中的任何一个函数都可以直接使用 go 关键字运行，这点相对于 threading.Thread 简单多了。

Goroutine 相对于 Python 的 coroutine 有两点优点：

1. 它是抢占的，不用主动交出。
2. 它可以运行在多个核上，而不像 Python 中只有主线程中的一个 loop 运行。

Python 的 coroutine 需要特别小心不要调用阻塞性的函数，比如 time.sleep，而要使用 asyncio.sleep，所以写起来不是非常得方便。Python 必须使用 await 来显式交出控制，而 Go 中则没有这种限制。
