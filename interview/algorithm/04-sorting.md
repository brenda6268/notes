适合链表的排序算法：选择排序

如果需要一次按照两个键排序，必须使用稳定的排序算法。

排序算法选择准则：

1．待排序的记录数目 n 的大小；
2．记录本身数据量的大小，也就是记录中除关键字外的其他信息量的大小；
3．关键字的结构及其分布情况；
4．对排序稳定性的要求。

bloomfilter 错误率 (1-1/n)^k n 为数组大小，k 为 hash 个数

## 堆

堆可以分成两种：大根堆和小根堆。他们两个的区别是显然的，不多说了，下面的讨论以大根堆为例。

堆的两种基本操作：向上调整和向下调整。

- 向上调整指的是，在堆的尾部插入一个元素，然后再使堆满足性质的行为，也就是需要这个元素向上找到他的位置；
- 向下调整指的是，当堆顶的一个元素可能不满足性质的时候，让这个元素向下找到他的位置。

```py
# 这里我们以 0 为索引起点
def left(i): return 2 * i + 1
def right(i): return 2 * i + 2
def parent(i): return (i-1) // 2

def up(h, i):
    """向上比较简单，因为只需要考虑父元素就行了"""
    while i > 0 and h[i] > h[parent(i)]:
        h[i], h[parent(i)] = h[parent(i)], h[i]
        i = parent(i)

def down(h, i, n):
    """向下稍微复杂一些，因为需要考虑两个子节点"""
    while left(i) <= n:
        if right(i) <= n and h[right(i)] > h[left(i)]:
            j = right(i)
        else:
            j = left(i)
        if h[j] <= h[i]:
            break
        h[i], h[j] = h[j], h[i]
        i = j
```

### 构建堆

有了以上两种基本操作，构建堆也就可以按两种方式：

- 从前往后构建，也就是把每一个新加入的元素理解为从后方插入，直接向上调整就行了
- 从后往前构建，这样其实相当于把左右两个子堆合并为一个新堆，但是新堆的根节点不一定满足堆续，只需要向下调整根节点就行了

两种方法的代码分别是：

```py
def build_heap_forward(h):
    for i in range(len(h)):
        up(h, i)

def build_heap_backward(h):
    for i in range(1, len(h)):
        down(h, len(h) - i)
```

### 堆排

有了上面的代码，那么我们的堆排代码也就很简单了

```py
def heap_sort(h):
    build_heap(h)
    for i in range(len(h) - 1, 0, -1):
        h[0], h[i] = h[i], h[0]
        down(h, 0)
```

## 字符串排序

可以使用低位优先排序和高位优先排序两种方法。低位优先排序就直接排就好了，高位优先排序很自然是一种递归算法，首先排序高位，然后排序`s[1:]`。


## 参考资料

1. https://leetcode.com/problems/sort-an-array/discuss/357592/O(n-log-n)-time-O(1)-space-HeapSort