# 栈和队列

<!--
ID: 4347c221-3f1b-4339-9d7e-0d96a0e109cb
Status: draft
Date: 2020-07-29T23:37:30
Modified: 2020-07-29T23:37:30
wp_id: 1680
-->

栈本身是一种特别简单的数据结构，这里就不多说了，主要记录一些以前不会的题目。

## 单调栈

单调栈就是满足单调性的栈。比如递增的栈，如果新的元素比栈顶的元素小的话，就要一直弹出，直到找到满足条件的栈顶，然后再入栈。

## 单调队列

单调队列使用两个队列组成。其中一个是普通的队列，另一个是维护大小顺序的队列。这里的队列不是严格的队列，而是可以从尾部弹出的双端队列。

```py
from collections import deque

class MonoQueue:
    def __init__(self):
        self.q = deque()  # 实际储存数据
        self.m = deque()  # 维护单调关系，队首元素总是最大值

    def push(self, x):
        self.q.append(x)
        while len(self.m) > 0 and self.m[-1] < x:
            self.m.pop()
        self.m.append(x)

    def pop(self):
        x = self.q.popleft()
        if self.m[0] == x:
            self.m.popleft()
        return x

    def __len__(self):
        return len(self.q)

    def top(self):
        return self.m[0]
```

## 例题

### 单调队列的题目

- LC84. Largest Rectangle in Histogram
- LC239. Sliding Window Maximum
- LC739. Daily Temperatures
- LC862. Shortest Subarray with Sum at Least K
- LC901. Online Stock Span
- LC907. Sum of Subarray Minimums

### POJ3250 Bad Hair Day

有 N 头牛从左到右排成一排，每头牛有一个高度 h[i]，设左数第 i 头牛与「它右边第一头高度 >= h[i]」的牛之间有 c[i] 头牛，试求 sum(c[i])。

这道题使用单调栈做。

```py
def sum_distance(H):
    ans = 0
    stack = []
    for h in H:
        # 单调递减的栈
        while stack and stack[-1] < h:
            stack.pop()
        ans += len(stack)
        stack.append(h)
    return ans
```

## 参考资料

1. https://oi-wiki.org/ds/monotonous-stack/
2. https://www.hankcs.com/program/algorithm/poj-3250-bad-hair-day.html
3. https://oi-wiki.org/ds/monotonous-queue/
4. https://oi.men.ci/monotone-queue-notes/