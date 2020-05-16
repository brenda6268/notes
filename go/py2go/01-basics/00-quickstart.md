# Go 语言初体验

## 安装与配置

安装 go 很简单，在 mac 上直接使用 `brew install go` 就可以了。注意的是需要设定 `GOPATH` 这个环境变量，如果不设定，默认就到了 `~/go` 这个目录。GOPATH 中也可以设置多个目录，默认安装包会安装到第一个路径。

```sh
export GOPATH=$HOME/lib:$HOME/go
```

通过这样的设置，我们使用 go get 的时候就会默认把包安装到 `/lib` 中，而我们自己的代码可以放在 `/go` 目录下。

## 语法风格

Golang 的整个语法还是极其简单的，基本是 C 和 Python 的混合体。Golang 详尽地规定了代码的风格，所以就不用为了大括号究竟是放在哪儿而开始圣战了。Golang 对程序员的约束很强，不容易犯错。

Go 语言是一门有 gc 的语言，所以所有变量的生命周期并不是严格限定于作用域的，由编译器来决定使用栈上还是堆上的空间。

Go 的类型总体来说，和 Python 的 duck type 有点像，而和 Java 严格的继承则是完全背道而驰的。

Golang 虽然有大括号，但是大括号的位置也是指定的。

## 有几个不爽的地方

1. nil 字典不能直接赋值，但是 nil slice 可以 append，应该增加一个类似 add 的函数给字典
2. interface 的 nil 始终没有搞明白。empty slice(a[0:0]) 和 nil 也不一样
3. defer 执行的地方是函数的结尾，而不是块的结尾。

## 参考

1. https://stackoverflow.com/questions/18058164/is-a-go-goroutine-a-coroutine
