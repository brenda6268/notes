# 区间问题

合并、排序区间也是一个常见的问题。

## 例题

## LeetCode 56

## LeetCode 57 合并区间

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

## LeetCode 矩形重叠问题

## 最少机器数量

有一批任务，每个都需要在不同的时间执行，每个任务都需要独占一台机器，求最少需要多少台机器。

输入：[1, 2], [4, 5], [2, 5]

输出需要多少台机器。