# 深度优先搜索与回溯

## 解题模板

深度优先搜索

```C++
int ans = 最坏情况, now;  // now为当前答案
void dfs(传入数值) {
  if (到达目的地) ans = 从当前解与已有解中选最优;
  for (遍历所有可能性)
    if (可行) {
      进行操作;
      dfs(缩小规模);
      撤回操作;
    }
}
```

上面的 if(可行) 其实就是剪枝的过程。

回溯

```Python
result = []
def backtrack(路径, 选择列表):
    if 满足结束条件:
        result.add(路径)
        return

    for 选择 in 选择列表:
        做选择
        backtrack(路径, 选择列表)
        撤销选择
```

核心就是 for 循环里面的递归，在递归调用之前「做选择」，在递归调用之后「撤销选择」。给定的函数往往不一定满足回溯的函数签名，添加一个 helper 函数就好了。、

回溯最好把结果变量作为一个全局变量定义在外边，这样方便一些，不然就得一路传递下去，容易出问题。backtrack 函数接收三个参数：

1. 输入数据
2. 当前遍历位置
3. 当前路径

## 改变函数签名与参数传递

如果在递归过程中，需要传递的参数比给定的函数包含的参数更多一些，那么定义一个额外的函数来实现这种 API 上的转换是可以的。

这里其实是更广义的 result in parameter 还是 result in return value 的问题。最好给用户用的函数是 result in return value 的，自己的内部实现可以是 result in parameter 的。另外也可以用闭包实现 result in parameter 的效果，也就是说不传递参数，直接从 closure 中读取。其实也可以用一个全局变量来做，都是类似的效果。

可以传递一个变量或者常量，或者传递一个指针用于保存结果。固定传递的参数也包括了向下传递还是向上返回。具体来说有以下几种：

1. 向下传递额外参数，如边界等
2. 向上返回额外参数，如后序遍历的额外返回结果
3. 在参数中返回值，也就是传递指针用于保存结果
4. 操作全局变量，或者 closure 中的值


## 例题

对于 Python 来说，一般没必要使用全局变量，可以使用内部函数访问闭包内的变量。

### LeetCode 17

这道题可以说是最最简单的一道 dfs 题目了。 


## 参考

1. https://www.dailycodingproblem.com/blog/an-introduction-to-backtracking/
2. https://labuladong.gitbook.io/algo/di-ling-zhang-bi-du-xi-lie/hui-su-suan-fa-xiang-jie-xiu-ding-ban