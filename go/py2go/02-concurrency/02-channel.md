## 并发通信机制

Python 中线程之间或者进程之间可以通过使用对应的 queue/multiprocessing.Queue来通信。而在 Golang 中类似的机制叫做 channel。语法是：make(chan val-type)

发送消息：go func() { messages <- "ping" }()

接收消息：msg := <-messages

接受会 block 住，直到收到一条消息位置，有点像 queue.get

## 方向性

chan 还是有方向性的：

1. chan<- string 只能发送
2. <-chan string 只能接收

默认情况下，go channel 是 unbuffered，也就是说没有缓冲，也就是容量为0. 那么必须有函数接受，才能发送出去. 这点和 Python 是完全相反的，Python 中 queue 是默认容量不限制的，也就是 put 只受内存大小的限制。

在 make 的时候添加一个数字可以实现 buffered channel

messages := make(chan string, 2)

这样在发送消息的时候，如果channel 没有满，就会直接返回而不会阻塞了。

## 同步

可以使用 chan 作为协程之间同步的简单机制。在主函数中等待另一个 goroutine 结束时候发送信号。

## select

select 作为一个系统调用是可以用来从多个监听的 socket 中读取信息。golang 中提供了一个 select 关键字，可以用于从多个 channel 中读取信息。同 select 系统调用一样，select 关键字也会一直 block 到独到的第一个消息为止。

```go
select {
case msg1 := <-c1:
    fmt.Println("received", msg1)
case msg2 := <-c2:
    fmt.Println("received", msg2)
}
```

## 超时机制

我们知道在 Python 的 queue.get 中可以指定 timeout，在 golang 中可以使用 select 机制

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

只要 close 一个 channel 就会退出啦。而且每个遍历这个 channel 的 goroutine 都能收到这个信号，在 Python 中要实现这一点就比较 tricky 了。

## 等待完成

有点类似 queue.join。waitGroup