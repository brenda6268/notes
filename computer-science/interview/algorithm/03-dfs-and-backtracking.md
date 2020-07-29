# 深度优先搜索与回溯

<!--
ID: 064e9fc3-19b9-4246-b2c0-dca786bb4e74
Status: draft
Date: 2020-01-31T00:00:00
Modified: 2020-07-29T23:37:30
wp_id: 1677
-->

回溯（backtrack）是一种系统性地搜索问题解答的方法。为了实现回溯，首先需要为问题定义一个解空间（solution space），这个空间必须至少包含问题的一个解（可能是最优的）。深度优先搜索方法本质上是对解空间的深度优先遍历，也就是说要做到「心中有树」。

回溯问题往往使用同一套代码可以解决一个问题的好几个变种。所以我们解决问题的时候应该首先尝试解决最基础的形式：判定是否有解或者有几个解，然后再去具体求解路径。

本质上来说，回溯就是一种暴力解法。

## 解题模板

核心就是 for 循环里面的递归，在递归调用之前「做选择」，在递归调用之后「撤销选择」。下面的 `if 不可行` 其实就是剪枝的过程。给定的函数往往不一定满足回溯的函数签名，添加一个 helper 函数就好了。track 就是路径的意思，所以回溯（backtrack）本身就是路径退回的意思。

需要注意的是，剪枝虽然能够提高程序运行速度，但是对于时间复杂度往往没有改善。回溯算法的时间复杂度往往是 `O(2^n)`

```Python
选择列表  # 题目给定
ans = []
def backtrack( track , pos ):
    """
    track: 当前路径
    pos: 当前位置，或者是剩下的未访问元素
    """
    if 满足结束条件 :  # base case
        ans.add( track )
        return

    # 通过考虑 pos，可以让选择列表小一点
    for 选择 in 选择列表 [pos] :
        if 不可行 :
            continue
        做选择  # track -> new_track
        backtrack( new_track , 选择 )
        撤销选择  # new_track -> track
```

我们可以看到回溯的空间复杂度实际上就是路径的最大长度。ans 参数完全可以写到 backtrack 函数中一直传递，但是本来 backtrack 函数的参数就够多了，我还是建议把他作为一个全局变量或者闭包外的变量，这样清晰一些。

另外值得注意的一点是，我们传递了 pos 这个变量，实际上从这里很容易转变成动态规划了。实际上这里的 pos 就是动态规划中遍历数组的索引。

## 改变函数签名与参数传递

正如上面所说的，回溯算法往往是需要定义一个 helper 函数的。

回溯最好把结果变量作为一个全局变量和输入变量都定义在外边，这样方便一些，不然就得一路传递下去，容易出问题。backtrack 函数接收两个参数：

1. 当前路径
2. 当前遍历位置

这里其实是更广义的 result in parameter 还是 result in return value 的问题。最好给用户用的函数是 result in return value 的，自己的内部实现可以是 result in parameter 的。另外也可以用闭包实现 result in parameter 的效果，也就是说不传递参数，直接从 closure 中读取。其实也可以用一个全局变量来做，都是类似的效果。

---存疑---
固定传递的参数也包括了向下传递还是向上返回。具体来说有以下几种：

1. 向下传递额外参数，如边界等，这个参数可能是随着调用在变的。 
2. 向上返回额外参数，也就是后续遍历才能够使用到返回的值。
---存疑结束---

## 例题

对于 Python 来说，一般没必要使用全局变量，可以使用内部函数访问闭包内的变量。

### LeetCode 17

这道题可以说是最最简单的一道 dfs 题目了。 

## 参考

1. https://www.dailycodingproblem.com/blog/an-introduction-to-backtracking/
2. https://labuladong.gitbook.io/algo/di-ling-zhang-bi-du-xi-lie/hui-su-suan-fa-xiang-jie-xiu-ding-ban
3. https://www.cnblogs.com/hustcat/archive/2008/04/09/1144645.html
4. https://www.1point3acres.com/bbs/thread-583166-1-1.html
5. https://zhuanlan.zhihu.com/p/92782083