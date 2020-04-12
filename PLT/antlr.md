## install

```
brew install antlr
```

生成 Python 文件

antlr -Dlanguage=Python3 syntax.g4


lexer 规则都是大写，而 parser 规则都是小写。一般来说先定义 parser 规则，再定义 lexer 规则。lexer 规则是按照从上到下的定义顺序解析的

Listener 和 Vistor 的区别也很简单，Listener 是边沿触发，进入和退出都会触发一次，而 Visitor 则是水平触发，变化时只触发一次。

## 参考资料

https://github.com/AlanHohn/antlr4-python/blob/master/arithmetic/arithmetic.py