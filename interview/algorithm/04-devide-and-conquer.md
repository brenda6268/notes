# 分治

分解 -> 解决 -> 合并

## 分治的时间复杂度

![](https://tva1.sinaimg.cn/large/00831rSTly1gd19dz03f1j308c062ac6.jpg)

通过 O(n) 的时间，把 n 的问题，变为了两个 n/2 的问题，复杂度是多少？

    T(n) = 2T(n/2) + O(n)
        = 2 * 2T(n/4) + O(n) + O(n)
        = n + nlogn

通过 O(1) 的时间，把 n 的问题，变成了两个 n/2 的问题，复杂度是多少？

    T(n) = 2T(n/2) + O(1)
    = 2 * 2T(n/4) + O(1) + O(1)
    = n + (1 + 2 + 4 +…+ n)
    ≈ n + 2n
    ≈ O(n)

## 改变函数签名与参数传递

参见回溯中的说明

## 例题

### LeetCode241

```Python
class Solution:
    def diffWaysToCompute(self, s: str) -> List[int]:
        if s.isdigit():
            return [int(s)]
        ans = []
        for i in range(len(s)):
            if s[i] in ("+", "-", "*"):
                left = self.diffWaysToCompute(s[:i])
                right = self.diffWaysToCompute(s[i+1:])
                for l in left:
                    for r in right:
                        if s[i] == "+":
                            ans.append(l+r)
                        elif s[i] == "-":
                            ans.append(l-r)
                        else:
                            ans.append(l*r)
        return ans
```

## 参考资料

1. https://mp.weixin.qq.com/s?__biz=MzUyNjQxNjYyMg==&mid=2247487045&idx=3&sn=e9f67f1fd33649c60478638c1d6cc2d9
2. https://oi-wiki.org/basic/divide-and-conquer/