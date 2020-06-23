# 贪心算法

天字第一条：永远**不要首先尝试贪心算法**，并尝试证明它是对的。而要使用动态规划推出一个算法，然后可以尝试简化到贪心算法。

尤其是在面试中，基本不会出现贪心算法，太 tricky 了。如果一个面试官问了一个题目，并且他只会用贪心算法解，那么这个面试官水平也一般，这样的公司不去也罢。

相比动态规划来说，贪心算法一般来说：

1. 要求条件更严格，也就是贪心选择条件；
2. 时间复杂度往往更低，能达到线性时间复杂度。

贪心选择性质：每一步都选择局部最优解，而局部最优解恰好是全局最优解。贪婪一般需要**预排序**，证明贪婪成立可以采用数学归纳法，或者证明不会有更好的方法

## 区间问题

合并、排序区间也是一个常见的问题。

### 例题

### LeetCode 56

### LeetCode 57 合并区间

这道题关键之处在于合并后，把剩余的区间直接加上来，这样就不用考虑不少特殊情况了。

```Python
class Solution:
    def insert(self, intervals, newInterval):
        ans = []
        start, end = newInterval
        remainder = 0
        for x, y in intervals:
            if start <= y:
                if end < x:
                    break  # 找到了结尾了
                start = min(start, x)
                end = max(end, y)
            else:
                ans.append([x, y])
            remainder += 1
        ans.append([start, end])
        ans += intervals[remainder:]
        return ans
```
#### 会议室 II

### LeetCode 矩形重叠问题

## 参考资料

1. [面试不会考贪心算法](https://mp.weixin.qq.com/s?__biz=MzU2OTUyNzk1NQ==&mid=2247491012&idx=1&sn=67846abd4e55d0b9b00aa98311ddc456)