# lispy 笔记


wp_id: 513
Status: publish
Date: 2017-12-10 05:44:00
Modified: 2020-05-16 11:27:42


阅读 norvig 文章[(How to Write a (Lisp) Interpreter (in Python))][1]的笔记。

作为从数学系转过来的学生，之前并没有学过编译原理，只是自己在一些文章中读过关于编译器的只言片语，借这篇文章了解一些编辑器的基本知识吧。

这篇文章主要是用 Python 实现了一个 lisp 的解释器。lisp 语言的语法非常简单，可以说lisp语言本身就是 AST 。一个解释器基本有两个部分。一部分是 parser，生成AST，另一部分是执行，运行AST。

```
code --> (parse)  --> AST --> (eval) --> result
```

也就是我们只要去实现 parse 和 eval 两个函数就好了～


## 类型定义

这里使用了几个类型，都是直接衍生自Python 的原生类型

```
Symbol = str  # 变量
Number = (int, float)
Atom = (Symbol, Number)
List = list
Exp = (Atom, List)
Env = dict
```

## parse

parse 传统意义上应该分为两部分，一部分是词法分析(Lexical Analysis)，也就是 tokenize，把代码转换成一系列的 token。另一部分是语法分析，也就是合成 AST。常用的工具有 lex，ply 等

在 Lispy 中，我们直接使用 Python 的 str.split 来实现 tokenize

```py
def tokenize(chars: str) -> list:
    return chars.replace("(", " ( ").replace(")", " ) ").split()
```

然后使用 read_from_tokens 构建一颗语法树。

```py
def read_from_tokens(tokens: list) -> Exp:
    if len(tokens) == 0:
        raise SyntaxError("unexpected EOF")
    token = tokens.pop(0)  # 从左向右依次处理
    if token == "(":
        L = []
        while token[0] != ")":
            L.append(read_from_tokens(tokens))  # 构建子树
        tokens.pop(0)  #  弹出 "("
        return L
    elif token == ")":
        raise SyntaxError("unexpected )")
    else:
        return atom(token)

def atom(token: str) -> Atom:
    try:
        return int(token)
    except ValueError:
        try:
            return float(token)
        except ValueError:
            return Symbol(token)

def parse(program: str) -> Exp:
    return read_from_tokens(tokenize(program))
```

## environment

环境大概和scope是相关的一个概念了。比如 `sqrt` 和 `max` 都是全局环境中的函数。

```py
class Env(dict):

    def __init__(self, params=(), args=(), outer=None):
        self.update(zip(params, args))
        self.outer = outer
    def find(self, var):
        return self if (var in self) else self.outer.find(var)

import math
import operator as op

def standard_env() -> Env:
    env = Env()
    env.update(vars(math))  # 引入python math 模块的方法
    env.update({
        "+": op.add, "-": op.sub, "*": op.mul, "/": op.truediv,
        ">": op.gt, "<": op.lt, ">=": op.ge, "<=": op.le, "=":op.eq,
        "abs": abs,
        "append": op.add,
        "apply": lambda proc, args: proc(*args),
        "begin": lambda *x: x[-1],
        "car": lambda x: x[0],
        "cdr": lambda x: x[1:],
        "cons": lambda: x, y: [x] + y,
        "eq?": op.is_,
        "expt": pow,
        "equal?": op.eq,
        "length": len,
        "list": lambda *x: List(x),
        "list?": lambda x: isinstance(x, List),
        "map": map,
        "max": max,
        "min": min,
        "not": op.not_,
        "null?": lambda x: x == [],
        "number?": lambda x: isinstance(x, Number),
        "print": print,
        "procedure?": callable,
        "round": round,
        "symbol?": lambda x: isinstance(x, Symbol),
    })
    return env

global_env = standard_env()
```

## eval

|表达式|语法|语义
|--|--|--|
|变量引用|symbol|写出变量名就是表示引用这个变量|
|常量|number|`10`|
|条件式|(if test conseq alt)|`(if  (> 10 20) (+ 1 1) (+ 3 3)` => 6|
|定义变量|(define symbol exp)|定义一个新的变量 `(define r 10)`|
|过程调用|(proc args...)|`(sqrt (* 2 8))` => 4|
|quotation|(quote exp)|返回表达式，而不是执行它。`(quote (+ 1 2))` => `(+ 1 2)`而不是3|
|赋值|(set! symbol exp)|注意和定义变量的区别|
|过程|(lambda (symbols...) exp)|定义一个新的过程 `(lambda (r) (* pi (* r r)))`|

```py
class Procedure:
    def __init__(self, params, body, env):
        self.params, self.body, self.env = params, body, env
    def __call__(self, *args):
        return eval(self.body, Env(self.params, args, self.env))

def eval(x: Exp, env=global_env) -> Exp:
    if isinstance(x, Symbol):      # 变量引用
        return env[x]
    elif not isinstance(x, List):  # 常量
        return x
    op, *args = x
    if op == "quote":
        return args[0]
    elif x[0] == "if":            # 条件表达式
       test, conseq, alt = args
       exp = conseq if eval(test, env) else alt
       return eval(exp, env)
    elif x[0] == "define":        # 定义变量
       _, symbol, exp = x
       env[symbol] = eval(exp, env)
    elif op == "set!":         # 变量赋值
        symbol, exp = args
        env.find(symbol)[symbol] = eval(exp, env)
    elif op == "lambda":        # 定义过程
        params, body = args
        return Procedure(params, body, env)
    else:                        # 过程调用 List
        proc = eval(x[0], env)
        args = [eval(arg, env) for arg in x[1:]]
        return proc(*args)
```

# repl

repl 的意思是 Read-Eval-Print-Loop，也就是我们常用的“解释器”。

```py
def repl(prompt="lis.py> "):
    while True:
        val = eval(parse(input(prompt)))
        if val is not None:
            print(schemestr(val))

def schemestr(exp):
    if isinstance(exp, List):
        return f"({" ".join(map(schemestr, exp))})")
    else:
        return str(exp)
```




[1]: http://norvig.com/lispy.html