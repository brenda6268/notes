Date: 2019-11-25

# 异常处理

Go 语言中没有异常，只有错误，而且也没有 `try...catch` 这个机制，只能通过返回值返回错误。个人感觉这两种方式半斤八两，都不是很优雅，还是 rust 的 Option Type 机制更好一点。

一般来说，错误是返回值的最后一个，这是一种很强的约定。

panic 有点类似抛出异常，但是也不是。而 defer 有点类似于 finally。

defer 实际上就相当于 C++ 中的 RAII，和 Python 中的 with 语句。

defer 实在函数结束时执行，而不是在块退出时实行，这块有点诡异。


## 参考

1. https://blog.golang.org/error-handling-and-go
