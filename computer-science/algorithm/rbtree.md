# 红黑树


ID: 492
Status: publish
Date: 2018-07-26 18:37:00
Modified: 2020-05-16 11:21:31


红黑树的要求：

1. 节点是红色或黑色。
2. 根是黑色。
3. 所有叶子都是黑色（叶子是NIL节点）。
4. 每个红色节点必须有两个黑色的子节点。（从每个叶子到根的所有路径上不能有两个连续的红色节点。）
5. 从任一节点到其每个叶子的所有简单路径都包含相同数目的黑色节点。

![](https://upload.wikimedia.org/wikipedia/commons/thumb/6/66/Red-black_tree_example.svg/900px-Red-black_tree_example.svg.png)


两篇不错的教程：

1. [漫画：什么是红黑树](https://juejin.im/post/5a27c6946fb9a04509096248)
2. [维基上的红黑树](https://zh.wikipedia.org/wiki/%E7%BA%A2%E9%BB%91%E6%A0%91)