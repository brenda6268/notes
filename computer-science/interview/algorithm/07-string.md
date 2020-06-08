# 字符串

解决两个字符串的动态规划问题，一般都是用两个指针 i,j 分别指向两个字符串的最后，然后一步步往前走，缩小问题的规模。

解字符串问题常用的算法是采用滑动窗口的方法。

避免字符串 O(n) 比较的一个方法是使用 hash。

## 后缀数组技巧

## kmp

1. next 数组的定义为：当前位置的子字符串，前缀和后缀匹配的最大长度为多少。
2. KMP 计算 next 数组和查找字符串的过程几乎是一样的，所以关键就在于构造 next 数组。
3. 构造 next 数组的关键就一句话：次大匹配就是（失败的）最大匹配处的子串的最大匹配，也即 `j = next[j-1]`

```Python
def kmp(t, p):
    """return all matching positions of p in t"""
    next = [0]
    j = 0  # j 表示当前自创中前缀和后缀匹配的最大长度
    # 注意这里是从 1 开始
    for i in range(1, len(p)):
        while j > 0 and p[i] != p[j]:
            j = next[j - 1]  # 关键之处
        if p[i] == p[j]: # 相等时，最大匹配自然要 +1
            j += 1
        next.append(j)
    ans = []
    j = 0
    for i in range(len(t)):
        while j > 0 and t[i] != p[j]:
            j = next[j - 1]  # 关键之处
        if t[i] == p[j]:
            j += 1
        if j == len(p):
            ans.append(i - (j - 1))
            # 这里是匹配成功了，但是要接着找下一个，所以按失败处理
            j = next[j - 1]
    return ans

def test():
    p1 = "aa"
    t1 = "aaaaaaaa"

    assert(kmp(t1, p1) == [0, 1, 2, 3, 4, 5, 6])

    p2 = "abc"
    t2 = "abdabeabfabc"

    assert(kmp(t2, p2) == [9])

    p3 = "aab"
    t3 = "aaabaacbaab"

    assert(kmp(t3, p3) == [1, 8])

    print("all test pass")

if __name__ == "__main__":
    test()
```

### 自动机

Trie 是一个自动机，KMP 是一个自动机，AC 自动机是 Trie 上运行 KMP 得到的自动机。Trie 和 KMP 都可以用于单模匹配，AC 自动机可以用于多模匹配。AC 自动机是确定性有限状态自动机 (DFA)。

正则表达式构建出来的却是一个非确定性有限状态自动机（NFA），非确定指的是跳转的时候可能有多个分支。要实现非指数时间解，也就是不用回溯，其实就是把回溯的深度优先遍历改成了广度优先遍历从而实现了剪枝。

## 哈夫曼树

https://juejin.im/post/5d1c7df2e51d45775c73dd49

## 参考资料

1. https://oi-wiki.org/string/hash/
2. https://www.zhihu.com/question/21923021/answer/37475572
3. https://swtch.com/~rsc/regexp/regexp1.html
4. https://stackoverflow.com/questions/31429865/trie-for-unicode-character-set
5. https://oi-wiki.org/string/sa/
6. https://oi.men.ci/suffix-array-notes/
7. https://blog.csdn.net/u013421629/article/details/83178970
8. https://oi-wiki.org/string/ac-automaton/
9. http://nark.cc/p/?p=1453
10. https://lingeros-tot.github.io/2019/03/05/Warming-Up-%E8%87%AA%E5%8A%A8%E6%9C%BA%E6%A8%A1%E5%9E%8B/
11. http://jakeboxer.com/blog/2009/12/13/the-knuth-morris-pratt-algorithm-in-my-own-words/