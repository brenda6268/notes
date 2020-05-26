# lispy 笔记


ID: 513
Status: publish
Date: 2017-12-10 05:44:00
Modified: 2020-05-16 11:27:42


阅读 norvig 文章[(How to Write a (Lisp) Interpreter (in Python))][1]的笔记。

作为从数学系转过来的学生，之前并没有学过编译原理，只是自己在一些文章中读过关于编译器的只言片语，借这篇文章了解一些编辑器的基本知识吧。

这篇文章主要是用 Python 实现了一个 lisp 的解释器。lisp 语言的语法非常简单，可以说lisp语言本身就是 AST 。一个解释器基本有两个部分。一部分是 parser，生成AST，另一部分是执行，运行AST。

```
code --&gt; (parse)  --&gt; AST --&gt; (eval) --&gt; result
```

也就是我们只要去实现 parse 和 eval 两个函数就好了～


# 类型定义

这里使用了几个类型，都是直接衍生自Python 的原生类型

```
Symbol = str  # 变量
Number = (int, float)
Atom = (Symbol, Number)
List = list
Exp = (Atom, List)
Env = dict
```

# parse

parse 传统意义上应该分为两部分，一部分是词法分析(Lexical Analysis)，也就是 tokenize，把代码转换成一系列的 token。另一部分是语法分析，也就是合成 AST。常用的工具有 lex，ply 等

在 Lispy 中，我们直接使用 Python 的 str.split 来实现 tokenize

```
def tokenize(chars: str) -&gt; list:
    return chars.replace(&#039;(&#039;, &#039; ( &#039;).replace(&#039;)&#039;, &#039; ) &#039;).split()
```

然后使用 read_from_tokens 构建一颗语法树。

```
def read_from_tokens(tokens: list) -&gt; Exp:
    if len(tokens) == 0:
        raise SyntaxError(&#039;unexpected EOF&#039;)
    token = tokens.pop(0)  # 从左向右依次处理
    if token == &#039;(&#039;:
        L = []
        while token[0] != &#039;)&#039;:
            L.append(read_from_tokens(tokens))  # 构建子树
        tokens.pop(0)  #  弹出 &#039;(&#039;
        return L
    elif token == &#039;)&#039;:
        raise SyntaxError(&#039;unexpected )&#039;)
    else:
        return atom(token)

def atom(token: str) -&gt; Atom:
    try:
        return int(token)
    except ValueError:
        try:
            return float(token)
        except ValueError:
            return Symbol(token)

def parse(program: str) -&gt; Exp:
    return read_from_tokens(tokenize(program))
```

# environment

环境大概和scope是相关的一个概念了。比如 `sqrt` 和 `max` 都是全局环境中的函数。

```
class Env(dict):

    def __init__(self, params=(), args=(), outer=None):
        self.update(zip(params, args))
        self.outer = outer
    def find(self, var):
        return self if (var in self) else self.outer.find(var)




import math
import operator as op

def standard_env() -&gt; Env:
    env = Env()
    env.update(vars(math))  # 引入python math 模块的方法
    env.update({
        &#039;+&#039;: op.add, &#039;-&#039;: op.sub, &#039;*&#039;: op.mul, &#039;/&#039;: op.truediv,
        &#039;&gt;&#039;: op.gt, &#039;&lt;&#039;: op.lt, &#039;&gt;=&#039;: op.ge, &#039;&lt;=&#039;: op.le, &#039;=&#039;:op.eq,
        &#039;abs&#039;: abs,
        &#039;append&#039;: op.add,
        &#039;apply&#039;: lambda proc, args: proc(*args),
        &#039;begin&#039;: lambda *x: x[-1],
        &#039;car&#039;: lambda x: x[0],
        &#039;cdr&#039;: lambda x: x[1:],
        &#039;cons&#039;: lambda: x, y: [x] + y,
        &#039;eq?&#039;: op.is_,
        &#039;expt&#039;: pow,
        &#039;equal?&#039;: op.eq,
        &#039;length&#039;: len,
        &#039;list&#039;: lambda *x: List(x),
        &#039;list?&#039;: lambda x: isinstance(x, List),
        &#039;map&#039;: map,
        &#039;max&#039;: max,
        &#039;min&#039;: min,
        &#039;not&#039;: op.not_,
        &#039;null?&#039;: lambda x: x == [],
        &#039;number?&#039;: lambda x: isinstance(x, Number),
        &#039;print&#039;: print,
        &#039;procedure?&#039;: callable,
        &#039;round&#039;: round,
        &#039;symbol?&#039;: lambda x: isinstance(x, Symbol),
    })
    return env

global_env = standard_env()
```

# eval

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

```
class Procedure:
    def __init__(self, params, body, env):
        self.params, self.body, self.env = params, body, env
    def __call__(self, *args):
        return eval(self.body, Env(self.params, args, self.env))

def eval(x: Exp, env=global_env) -&gt; Exp:
    if isinstance(x, Symbol):      # 变量引用
        return env[x]
    elif not isinstance(x, List):  # 常量
        return x
    op, *args = x
    if op == &#039;quote&#039;:
        return args[0]
    elif x[0] == &#039;if&#039;:            # 条件表达式
       test, conseq, alt = args
       exp = conseq if eval(test, env) else alt
       return eval(exp, env)
    elif x[0] == &#039;define&#039;:        # 定义变量
       _, symbol, exp = x
       env[symbol] = eval(exp, env)
    elif op == &#039;set!&#039;:         # 变量赋值
        symbol, exp = args
        env.find(symbol)[symbol] = eval(exp, env)
    elif op == &#039;lambda&#039;:        # 定义过程
        params, body = args
        return Procedure(params, body, env)
    else:                        # 过程调用 List
        proc = eval(x[0], env)
        args = [eval(arg, env) for arg in x[1:]]
        return proc(*args)
```

# repl

repl 的意思是 Read-Eval-Print-Loop，也就是我们常用的“解释器”。

```
def repl(prompt=&#039;lis.py&gt; &#039;):
    while True:
        val = eval(parse(input(prompt)))
        if val is not None:
            print(schemestr(val))

def schemestr(exp):
    if isinstance(exp, List):
        return f&#039;({&quot; &quot;.join(map(schemestr, exp))})&#039;)
    else:
        return str(exp)
```




[1]: http://norvig.com/lispy.html