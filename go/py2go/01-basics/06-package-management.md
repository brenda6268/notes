package 名字可以和目录不一样，但是最好和目录名一样。一个目录中可以放多个 package，但是最好放一个

import "foo/bar" 代表从 $GOPATH/src/foo/bar 中导入包，一般来说这个包的名字叫做 package bar.

如果使用了 go mod，那么就是从会从单独的缓存来做了。

Python 是 package 里面有 module。go 是 module 里有 package。服了

一个文件夹中只能放一个 package，package name 最好和文件夹名字一致


Golang 官方提供了一个工具 goimports 用来管理 import 语句，还不错。import 进来的包必须使用，声明的变量也必须使用。import 语句必须在 package 语句后面。虽然有大括号，但是大括号的位置也是指定的。

## 参考

1. https://stackoverflow.com/a/43580332/1061155
2. https://stackoverflow.com/a/19240125/1061155