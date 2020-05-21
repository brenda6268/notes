Date: 2018-05-02

# 楔子

最近读到一亩三分地上一篇讲 Facebook 架构和国内对比的文章，感觉自己真是井底之蛙。头脑中一些架构方面的概念和 Status of the Art 的理念还相去甚远，迫切想要进一步了解一些先进知识。比如说，以前觉得 git flow 这个概念还挺不错的，实践了半年，发现 develop 分支完全是多余的；以前觉得每个项目分一个仓库方便管理，现在觉得 monorepo 似乎更好一点。另外就是对“互联网时代的 C 语言” Golang 有点想了解一下。

一年前休假的时候看了几眼 Golang，感觉还不错，但是想实际写点什么的时候发现 GOPATH 这个设计真是奇葩至极。而现在我的思想已经完全倒向 Monorepo 了，那么 GOPATH 也就看起来很可爱了，Golang 看起来也就很可爱了，也就决定再翻翻 Go 语言的书吧，以后说不定会写点儿什么呢。

忘了在哪里看过一句话：人的知识像一个网络，新学到的知识只有和已有的知识关联起来才能真正记得住、记得牢，否则的话像是一个孤岛的新知识很快就会被忘记了，于是就有了本文。

需要注意的是，本文并不是一个简单的语法对比，倘若只是语法的话，直接把代码一列其实就差不多了。除去语法之外，本文还在设计理念上做了一些对比。以下为目录。（没有链接的表示还没有写，敬请期待）

# 目录

1. 语法基础
 1. 类型与变量
 2. 数据结构与控制语句
 3. 函数
 3. 面向对象
 4. 错误处理
 5. 包管理
2. 并发与网络
 1. 并发机制
 2. Http 请求
3. 常用标准库
 1. 时间解析
 2. 文件 IO
 3. 正则表达式
 4. 数学函数
 5. 定时机制

写这些文章的另一个目的就是对 Python 中相关的知识做个梳理，以便以后再学习新的语言（比如 rust, clojure）能够更有条理。

## 参考资料

1. Python slice notation. https://stackoverflow.com/questions/509211/understanding-slice-notation/50929x
2. How to get type of go. https://stackoverflow.com/questions/20170275/how-to-find-a-type-of-an-object-in-go
3. Golang online repo. https://repl.it/languages/go
4. A tour of go. https://tour.golang.org/moretypes/6
5. golang vs python. http://govspy.peterbe.com/#lists
6. https://www.353.solutions/py2go/index.html