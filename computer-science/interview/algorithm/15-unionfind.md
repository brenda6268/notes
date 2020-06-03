# UnionFind 算法

unionfind 算法是用于计算图中的节点连通性的算法。其中连同的意思是满足『自反』『对称』『传递』三个意思的连通。

```python
class UnionFind:
    def __init__(self, count):
        self.count = count
        self.parents = list(range(count))  # 初始化时 parent 指针指向自己

    def union(self, p, q):
        """把 p, q 两个节点连通起来"""
        p_root = self.find(p)
        q_root = self.find(q)
        if p_root == q_root:
            return
        self.parents[p_root] = q_root
        self.count -= 1

    def find(self, p):
        """找到 p 节点的根节点"""
        while self.parents[p] != p:
            p = self.parents[p]
        return p

    def is_connected(p, q):
        p_root = self.find(p)
        q_root = self.find(q)
        return p_root == q_root
```

在上面的算法中，我们发现 union 和 is_connected 主要依赖于 find 的时间复杂度。而在树极端不平衡的情况下，是可能退化到 O(n) 的，所以不优化的前提下，时间复杂度是 O(n)。

## 优化1 - 保持树平衡

```python
class UnionFind:
    def __init__(self, count):
        self.count = count
        self.parents = list(range(count))  # 初始化时 parent 指针指向自己
        self.sizes = [1] * count  # 记录每棵树的大小

    def union(self, p, q):
        """把 p, q 两个节点连通起来"""
        p_root = self.find(p)
        q_root = self.find(q)
        if p_root == q_root:
            return
        if self.sizes(p_root) > self.sizes(q_root):
            self.parents[q_root] = p_root
            self.sizes[p_root] += self.sizes[q_root]
        else:
            self.parents[p_root] = q_root
            self.sizes[q_root] += self.sizes[p_root]
        self.count -= 1
```

经过这个优化之后，时间复杂度就降到 O(logN) 了。

## 优化2 - 路径压缩

在调用 find 函数的时候，把

```python
class UnionFind:
    def find(self, p):
        """找到 p 节点的根节点"""
        while self.parents[p] != p:
            # 神奇的路径压缩
            self.parents[p] = self.parents[self.parents[p]]
            p = self.parents[p]
        return p
```

## Go 语言实现

```go
type UnionFind struct {
    count int,
    parents []int,
    sizes []int
}

func NewUnionFind(n int) (*UnionFind) {
    parents := make([]int, n)
    sizes := make([]int, n)
    for i := 0; i < n; i++ {
        parents[i] = i
        sizes[i] = 1
    }
    return &UnionFind{n, parents, sizes)
}

func (uf *UnionFind) Union (p, q int) {
    pRoot := uf.Find(p)
    qRoot := uf.Find(q)
    if pRoot == qRoot {
        return
    }
    if uf.sizes[pRoot] < uf.sizes[qRoot] {
        uf.parents[pRoot] = qRoot
        uf.sizes[qRoot] += uf.sizes[pRoot]
    } else {
        uf.parents[qRoot] = pRoot
        uf.sizes[pRoot] += uf.sizes[qRoot]
    }
    uf.count -= 1
}

func (uf *UnionFind) Find(p int) int {
    while uf.parents[p] != p {
        uf.parents[p] = uf.parents[uf.parents[p]]
        p = uf.parents[p]
    }
    return p
}

func (uf *UnionFind) IsConnected(p, q int) bool {
    pRoot := uf.Find(p)
    qRoot := uf.Find(q)
    return pRoot == qRoot
}
```

# LeetCode 题目

## LeetCode 200 岛屿的数量

这个题就很简单了，简直是 UnionFind 的直接应用。