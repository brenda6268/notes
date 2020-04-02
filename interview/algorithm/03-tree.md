# 树

## 思维

树的最大问题在于要**从底层叶节点开始思考**，而不是自上而下看图。递归是从基础 case 开始向上递归的。一定要画出访问的顺序图。

![访问顺序图](https://tva1.sinaimg.cn/large/00831rSTly1gd199vou2dj309j0jrgmn.jpg)

## 树的问题的特性

1. 对于任何树的问题，还是优先考虑递归，因为树本身就是一个递归性质的数据结构。
2. 树还是天然 Devide and Conquer 的，也就是说可以分层左右两个树分别处理，然后合并得到答案。

解树的问题就只有两种方法：

1. 分治：后序遍历，并通过左右子树和根节点一起解决问题。

    ![](https://tva1.sinaimg.cn/large/00831rSTly1gde9lv8bebj30fq0godh9.jpg)

2. 遍历：在遍历过程中解决问题，比如记录最大值等。

    ![](https://tva1.sinaimg.cn/large/00831rSTly1gd19anooewj308c04stad.jpg)


## 迭代解 vs 递归解

最好写递归解，比较简单。

写迭代性解首先考虑栈。函数调用过程本来就会用到栈使用栈可以模拟递归调用。使用栈还可以把需要反转的操作自动反转。比如在 zigzag 层序遍历的时候。

## 递归的出口是选 NULL 还是叶子节点?

最好选择 null

1. 有一个corner case是直接就传一个null的节点进来, 所以要选null
2. 叶子节点比较复杂, 只要判断null的return之后结果ok, 就null



## 改变函数签名与参数传递

参考回溯文档中的讲解

## 常见问题总结

### 遍历

参考这里：https://github.com/yifeikong/interview/blob/master/tree.md



# 红黑树

https://blog.csdn.net/yang_yulei/article/details/26066409

# 更多的树

https://blog.csdn.net/yang_yulei/column/info/easydatastruct

二叉树外部节点总是等于内部节点加1

# how to formulaically solve tree problems

https://www.dailycodingproblem.com/blog/how-to-formulaically-solve-tree-interview-questions/
Tree questions are very common at top tech company interviews. I had two tree questions in my Google onsite interviews and one during my Facebook onsite interviews. An awesome thing about them is that they can be formulaically solved every single time. It doesn’t involve any genius insight. Let me show you how.
Instead of being too abstract, let’s just dive right into an easy binary tree question. Then I’ll walk through how to solve it and we can go into a harder problem after:
Given the root to a binary tree, count the total number of nodes there are.
Before we move on further, feel free take a moment to think about the answer!
Solving any binary tree question involves just two steps.
First is solving the base case. This usually means solving the leaf node case (a leaf node has no left or right children) or the null case. For the above problem, we can see that a null should represent 0 nodes while a leaf node should represent 1 node.
Second is the recursive step. Assuming you knew the solution to the left subtree and the right subtree, how could you combine the two results to give you the final solution? It’s important to not get caught up on how this works and just have faith that it works. If you start tracing the recursion, you’re going to needlessly use up time and energy during the interview. Intuitively though, it works for similar reasons as why regular induction works. P(0) or the base case works which causes P(1) or the leaf node to work which causes P(2) to work and so on. For this problem, it’s easy to combine the results of the left and right subtrees. Just add the two numbers and then another 1 for the root. Here’s the code:

```py
def count(node):
    return count(node.left) + count(node.right) + 1 if node else 0
```
You certainly won’t get a question this easy but the process is the same for trickier problems. Here’s another problem:
Given the root to a binary tree, return the deepest node.
Base case for this question actually can’t be null, because it’s not a real result that can be combined (null is not a node). Here we should use the leaf node as the base case and return itself.
The recursive step for this problem is a little bit different because we can’t actually use the results of the left and right subtrees directly. So we need to ask, what other information do we need to solve this question? It turns out if we tagged with each subresult node their depths, we could get the final solution by picking the higher depth leaf and then incrementing it:

这里需要注意的是基础情况是叶节点，而不是 nil.

```py
def deepest(node):    
    if node and not node.left and not node.right:
        return (node, 1) # Leaf and its depth    
    if not node.left: # Then the deepest node is on the right subtree        
        return increment_depth(deepest(node.right))    
    elif not node.right: # Then the deepest node is on the left subtree        
        return increment_depth(deepest(node.left))    

    return increment_depth(
        max(deepest(node.left), deepest(node.right),
        key=lambda x: x[1])) # Pick higher depth tuple and then increment its depth

def increment_depth(node_depth_tuple):
    node, depth = node_depth_tuple    
    return (node, depth + 1)
```

## 参考资料

1. https://stomachache007.wordpress.com/2017/03/12/%E4%B9%9D%E7%AB%A0%E7%AE%97%E6%B3%95%E7%AC%94%E8%AE%B0-3-binary-tree-divide-conquer/