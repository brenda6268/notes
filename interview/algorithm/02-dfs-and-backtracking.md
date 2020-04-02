# 深度优先搜索与回溯

深度优先搜索方法是对状态空间的深度优先遍历，也就是说要做到「心中有树」。

## 解题模板

下面的 `if 不可行` 其实就是剪枝的过程。

```Python
选择列表  # 题目给定
ans = []
def backtrack( 路径 , 位置 ):
    if 满足结束条件 :
        ans.add( 路径 )
        return

    for 选择 in 选择列表 :
        if 不可行 :
            continue
        做选择 -> 新路径
        backtrack( 新路径 , 选择 )
        撤销选择 -> 路径
```

核心就是 for 循环里面的递归，在递归调用之前「做选择」，在递归调用之后「撤销选择」。给定的函数往往不一定满足回溯的函数签名，添加一个 helper 函数就好了。

## 改变函数签名与参数传递

正如上面所说的，回溯算法往往是需要定义一个 helper 函数的。

回溯最好把结果变量作为一个全局变量定义在外边，这样方便一些，不然就得一路传递下去，容易出问题。backtrack 函数接收三个参数：

1. 输入数据
2. 当前遍历位置
3. 当前路径

这里其实是更广义的 result in parameter 还是 result in return value 的问题。最好给用户用的函数是 result in return value 的，自己的内部实现可以是 result in parameter 的。另外也可以用闭包实现 result in parameter 的效果，也就是说不传递参数，直接从 closure 中读取。其实也可以用一个全局变量来做，都是类似的效果。

固定传递的参数也包括了向下传递还是向上返回。具体来说有以下几种：

1. 向下传递额外参数，如边界等，这个参数可能是随着调用在变的。 
2. 向上返回额外参数，也就是后续遍历才能够使用到返回的值。

## 例题

对于 Python 来说，一般没必要使用全局变量，可以使用内部函数访问闭包内的变量。

### LeetCode 17

这道题可以说是最最简单的一道 dfs 题目了。 

## 参考

1. https://www.dailycodingproblem.com/blog/an-introduction-to-backtracking/
2. https://labuladong.gitbook.io/algo/di-ling-zhang-bi-du-xi-lie/hui-su-suan-fa-xiang-jie-xiu-ding-ban