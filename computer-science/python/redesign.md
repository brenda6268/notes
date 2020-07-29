# 无标题

<!--
ID: 9da41cdc-f925-45d5-beb7-03493debc3f6
Status: draft
Date: 2020-05-28T14:09:32
Modified: 2020-05-28T14:09:32
wp_id: 1228
-->

想要改变的地方

没有区分变量声明和初始化

let foo = "bar"

区分开了 new和 init
classmethod和staticmethod
for else
没有 for 循环
没有 do while
列表不是强类型的
类型不是强制的
没有函数字面量
没有三元表达式
generator 没有单独的语法。

JIT
Strong type
typelist anylist typedict anydict
decorator


let add = def(a, b): return a + b

[1, 3, 2].sort(key=fn(a, b): a - b)
[1, 2, 3].reduce(fn(a, b): a + b)
[1, 2, 3].map(fn(a): a * 2)


https://github.com/lark-parser/lark
https://github.com/michaeljones/packed/blob/master/packed.py
https://github.com/dabeaz/ply
https://fdik.org/pyPEG/
