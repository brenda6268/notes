# 面试常见的几种算法模式

<!--
ID: b981e5c9-8f29-408a-8e7e-785e4ca42dcc
Status: draft
Date: 2019-11-09T00:00:00
Modified: 2020-06-02T13:37:07
wp_id: 1517
-->

## 滑动窗口

## 双指针

1. 常见于链表中，比如反转链表。
2. 以及字符串中，查找回文子串

常用于有序数组或者链表中

## 快慢指针

用于查找是否有环等

## 区间问题

## 环装排序


## 1 DFS

深度优先搜索是遍历图和树的最基本算法。很多问题，虽然不是 graph 或者 tree 的问题，但是可以转换成类似的问题，然后使用 DFS 算法，5 道面试题里至少有一道。

## 2 BFS

和 DFS 相比，两者最大的区别是遍历数据的顺序。

DFS 使用的是 Stack, 先将所有孩子加入 stack 中，从栈顶开始，取出一个 node 将其所有孩子加入栈中，重复着个过程。
BFS 使用的是 Queue, 先将所有孩子加入 queue 中，从队首开始，取出一个 node 将其所有孩子加入队列中。

## 两个堆

一个最大堆，一个最小堆，用于查找中位值

## 子集

## Top K 元素

使用堆就对了

## K 路合并

## 拓扑排序

需要解决 DAG 的问题

## 3 使用 Stack

感觉经常会和 DFS 组合在一起，经典题目多见于括号匹配相关的问题，如 valid parentheses. 最后的终止条件往往是看栈是否是空的。

## 4 散列

可以被认为是一种缓存中间结果，用于 DP 过程中的存储。但是好多情况下，也可以用 array 代替。

例题：find the longest zero path within a matrix.

## 8 递归

工程中不常用，但在面试中会经常考。与树有关的题经常会用到。关于递归需要注意的是，每次递归实际上是应用了一个隐式的栈。编写迭代版的算法实际上就是把这个隐式的栈显示地写出来。

## 10 二分搜索

如果一个题给你一串排好序的数字，然后又要求你用 `O(log(n))` 求解出来，那这题大概率是用二分查找做。

## 其他人的补充

1. DFS 和 BFS 都是遍历算法，一般来说是可以互相转换的，BFS 更多用在找最少或者最短的路径上，BFS 能保证遇到的第一个结果就是最终要返回的结果，这周 Leetcode 周赛第四题就是典型的 BFS。BFS 也分为用 Queue 和 Priority Queue，Merge k sorted List 某种意义上来说就是一道用 pq 的 BFS。

2. DFS 和 backtrack 经常组合在一起，一般来说就是尝试所有可能的组合，permutation 就是最典型的 DFS+Backtrack。在需要穷举所有可能的题目中，DFS + Backtrack 比 BFS 优势在于递归的路径在同一时间只有一条，但是 BFS 需要保存前面所有的路径（这里表述的不是清楚，经常写这类题的同学应该知道这点），还有 DFS+MEMO 是最容易想到的优化，一般能优化到和 DP 同阶，比如斐波那契就能优化到 O(n)，但是系数会比常规的 dp 大，斐波那契的更准确的界应该是 2n，因为对于每个点，都有 n+1 和 n+2 会访问到这个点的结果。

3. 翻转链表应该是最基础的数据结构的题了，有完全反转，两两反转，k 个反转，除了递归写，还有迭代也要会，链表是特殊的树，树是特殊的图。

4. 排序算法常见的 quick sort，merge sort 就不说了，bucket sort，counting sort 这些 O(n) 的排序方法有时候能起奇效。

5. 一般面试里面可能需要自己构建的数据结构有 Union find, Trie, Binary Heap, Segement tree. Suffix tree 倒是暂时还没遇到过，可能还是我刷的题不够多吧。还有看面经有让写红黑树的，不知道这是被黑了还是常规操作。

6. 说到 suffix tree, 字符串匹配问题有好几种 O(n) 的算法，除了大名鼎鼎的 KMP 之外还有 Karp–Rabin, z algorithm, 我只能写后两个，有没有大佬介绍下面试的时候只需要写一个 O(n) 的算法就行了还是有时候还是会指定写 KMP 的？

7. Binary Search 其实更重要的是理解思想，就是通过一次比较能去掉一半的可能结果，所以可能对 array 的长度来二分，也有可能对取值范围来二分。Binary Search 有三种写法，`left<right-1`，`left<right` 和 `left<=right`。界越松越不容易错，但是需要额外的比较，代码会比较长。

## 参考

1. https://www.1point3acres.com/bbs/thread-554991-1-1.html
2. https://www.youtube.com/watch?v=r1MXwyiGi_U
3. 这个还需要总结，比较全。https://hackernoon.com/14-patterns-to-ace-any-coding-interview-question-c5bb3357f6ed