# 字符串

解决两个字符串的动态规划问题，一般都是用两个指针 i,j 分别指向两个字符串的最后，然后一步步往前走，缩小问题的规模。


## 敏感词过滤算法

https://zhuanlan.zhihu.com/p/65115496

https://stomachache007.wordpress.com/2017/03/07/414/


接字符串问题常用的算法是采用滑动窗口的方法。

避免字符串O(n)比较的一个方法是使用hash。

## kmp

next 数组的定义为：当前位置的子字符串，前缀和后缀匹配的最大长度为多少。
KMP 计算 next 数组和查找字符串的过程几乎是一样的，所以关键就在于构造 next 数组。
构造 next 数组的关键就一句话：次大匹配就是（失败的）最大匹配处的子串的最大匹配，也即 `j = next[j-1]`

```Python
def kmp(t, p):
    """return all matching positions of p in t"""
    next = [0]
    j = 0  # j 表示当前自创中前缀和后缀匹配的最大长度
    # 助理这里是从 1 开始
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

## 正则表达式

正则表达式的多状态 NFA 其实就是把回溯的深度优先遍历改成了广度优先遍历从而实现了剪枝。

## 后缀数组




## 参考资料

1. https://oi-wiki.org/string/hash/
2. https://www.zhihu.com/question/21923021/answer/37475572
3. https://swtch.com/~rsc/regexp/regexp1.html