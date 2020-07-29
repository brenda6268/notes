# 动态规划

<!--
ID: fcadc092-8d02-4776-82e4-cb5d1ced4067
Status: draft
Date: 2019-11-05T00:00:00
Modified: 2020-07-29T23:37:30
wp_id: 1686
-->

动态规划的本质就是**递归**，但是实现起来往往是迭代的。总体来说，动态规划就是一般就是回溯解法加上使用一个记忆化数组来保存状态，然后转换成迭代形式。

初学者常犯的一个错误就是认为动态规划是通过填表来解决问题的，实际上不是的，重点在于**如何聪明地回溯**。动态规划中所谓的状态转移方程，其实就是找到回溯递归条件。填表是结果而不是原因。

## 解题步骤

1. 首先用自然语言递归地定义你的问题；
2. 自底向上构建答案；
    1. 确定你的子问题
    2. 选择一个记忆化的数据结构，一般是（多维）数组
    3. 确定每一步迭代的依赖，最好用箭头画一下
    4. 考虑迭代方式，首先考虑基础情况
3. 最后可以分析时间复杂度。

![](./04-dynamic-programming_images/dependencies.png)

### 不要尝试使用贪心算法！

每当你开始写——甚至是想到——贪心算法 (greeDY) 的时候，你的潜意识都是在告诉你用动态规划（DYnamic programming）。

即使可以使用贪心算法的题目，也可以先用回溯或者动归解，然后优化成贪心算法。首先解出来，然后再优化！

## 使用场景

动态规划适合把时间复杂度为指数型回溯暴力解法的问题转化为多项式的复杂度，即 O(2^n) 或 O(n!) 转化为 O(n^2)。如果已经有多项式时间复杂度的解法，那么就没必要再用动态规划了。

DP 问题大概有以下几类：

1. 坐标型问题
    棋盘类的问题，直接在棋盘上走就行了。更简单的一维的 jump game，其实模拟就行了。
2. 序列型
    1. 循环一遍或者两遍整个数组。每个位置都是以当前位置为结尾的子序列的答案。
    2. 如果是子串的话，一般是 O(n) 的，如果是子序列，可能是 O(n^2) 的。
    3. 可能需要添加一个额外的元素在头部，`dp[0]` 不代表任意元素。
3. 匹配型 
    使用两个序列作为不同维度构成 DP 矩阵，填充完**矩阵**就得出结果了。比如编辑距离
4. 背包类，本质上就是回溯的另一种解法
    1. 用值作为 DP 维度
    2. 填充矩阵就得出结果
    3. 可以使用滚动数组优化。

## 动态规划问题的步骤

找到回溯解法，然后推导出动态规划解法。每次查 dp 表实际上就相当于回溯中的一次递归调用。

```py
for 状态 1 in 状态 1 的所有取值 :
    for 状态 2 in 状态 2 的所有取值 :
        for ...
            dp[状态 1][状态 2][...] = 择优（选择 1，选择 2...)
```

其实实际做起来也很简单，DP 数组中存的一定是题目的答案，那么其实也就是如何通过 n-1 的答案来解决 n 的答案。

初始化的时候可能需要多一个 `dp[0][i]` 或者 `dp[i][0]` 作为基础条件。动态规划中需要几个变量，几层循环，那么就是需要几层的 DP 数组。从算法实现上来说，这时候有两种处理方法：

1. 预先填充 `dp[0][i]` 和 `dp[i][0]` 这些值；
2. 计算的时候分情况，对于边界值特殊处理。

### 举例：二维 DP

一般来说，二维 DP 对于长度为 m 和 n 的序列，需要生成 (m+1)*(n+1) 大小的二维矩阵。

正向遍历：

```C++
int[][] dp = new int[m][n];
for (int i = 0; i < m; i++)
    for (int j = 0; j < n; j++)
        // 计算 dp[i][j]
```

反向遍历：

```C++
for (int i = m - 1; i >= 0; i--)
    for (int j = n - 1; j >= 0; j--)
        // 计算 dp[i][j]
```

斜着遍历：

```C++
// 斜着遍历数组
for (int l = 2; l <= n; l++) {
    for (int i = 0; i <= n - l; i++) {
        int j = l + i - 1;
        // 计算 dp[i][j]
    }
}
```

综上：

1. 遍历的过程中，所需的状态必须是已经计算出来的。
2. 遍历的终点必须是存储结果的那个位置。

所以，遍历方式由 base case 所在的位置和最终结果的存储位置来定。

## 例题

### LeetCode 300 最长递增子序列

这是一个典型的序列型 dp 问题。 dp 中记录的是包含当前元素的最长递增子序列。

```Python
class Solution:
    def lengthOfLIS(self, nums: List[int]) -> int:
        if not nums:
            return 0
        if len(nums) == 1:
            return 1
        dp = [1] * len(nums)  # 这里的 1 是关键。
        for i in range(len(nums)):
            for j in range(i):
                if nums[j] < nums[i]:
                    dp[i] = max(dp[i], dp[j] + 1)
        return max(*dp)
```

### LeetCode 1143 最长公共子序列

```Python
def longestCommonSubsequence(str1, str2) -> int:
    m, n = len(str1), len(str2)
    # 构建 DP table 和 base case
    dp = [[0] * (n + 1) for _ in range(m + 1)]
    # 进行状态转移
    for i in range(1, m + 1):
        for j in range(1, n + 1):
            if str1[i - 1] == str2[j - 1]:
                # 找到一个 lcs 中的字符
                dp[i][j] = 1 + dp[i-1][j-1]
            else:
                dp[i][j] = max(dp[i-1][j], dp[i][j-1])
        
    return dp[-1][-1]
```

### LeetCode 32 最长有效括号

## 题外话：实际工作中的动态规划

大家工作中经常遇到的例子：

在软件开发中，大家经常会遇到一些系统配置的问题，配置不对，系统就会报错，这个时候一般都会去 Google 或者是查阅相关的文档，花了一定的时间将配置修改好。
过了一段时间，去到另一个系统，遇到类似的问题，这个时候已经记不清之前修改过的配置文件长什么样，这个时候有两种方案，一种方案还是去 Google 或者查阅文档，另一种方案是借鉴之前修改过的配置，第一种做法其实是万金油，因为你遇到的任何问题其实都可以去 Google，去查阅相关文件找答案，但是这会花费一定的时间，相比之下，第二种方案肯定会更加地节约时间，但是这个方案是有条件的，条件如下：

- 之前的问题和当前的问题有着关联性，换句话说，之前问题得到的答案可以帮助解决当前问题
- 需要记录之前问题的答案

当然在这个例子中，可以看到的是，上面这两个条件均满足，大可去到之前配置过的文件中，将配置拷贝过来，然后做些细微的调整即可解决当前问题，节约了大量的时间。

## 参考

1. https://zhuanlan.zhihu.com/p/91582909
2. https://jacobchang.cn/solve-dp-problems.html
3. https://labuladong.gitbook.io/algo/dong-tai-gui-hua-xi-lie/bian-ji-ju-li
4. https://mp.weixin.qq.com/s/erJPc8Xx9BBXY1ZiEXVvKg
5. https://labuladong.gitbook.io/algo/di-ling-zhang-bi-du-xi-lie/zui-you-zi-jie-gou
6. https://stomachache007.wordpress.com/2017/04/09/%e4%b9%9d%e7%ab%a0%e7%ae%97%e6%b3%95%e7%ac%94%e8%ae%b0-9-%e5%8a%a8%e6%80%81%e8%a7%84%e5%88%92-dynamic-programming/
7. https://stomachache007.wordpress.com/2017/10/31/%e4%b9%9d%e7%ab%a0%e7%ae%97%e6%b3%95%e9%ab%98%e7%ba%a7%e7%8f%ad%e7%ac%94%e8%ae%b05-%e5%8a%a8%e6%80%81%e8%a7%84%e5%88%92%ef%bc%88%e4%b8%8a%ef%bc%89/
8. https://stomachache007.wordpress.com/2017/11/06/%e4%b9%9d%e7%ab%a0%e7%ae%97%e6%b3%95%e9%ab%98%e7%ba%a7%e7%8f%ad%e7%ac%94%e8%ae%b05-%e5%8a%a8%e6%80%81%e8%a7%84%e5%88%92%ef%bc%88%e4%b8%8b%ef%bc%89/
9. https://oi-wiki.org/basic/divide-and-conquer/