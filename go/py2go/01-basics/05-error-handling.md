# 异常处理

Go 语言中没有异常，只有错误，而且也没有 try...except 这个机制，通过返回值返回错误。个人感觉这两种方式半斤八两，都不睡很优雅，还是 rust 的 Option Type 机制更好一点。

一般来说，错误是返回值的最后一个。

panic 有点类似抛出异常，但是也不是。而 defer 有点类似于 finally。

https://blog.golang.org/error-handling-and-go
