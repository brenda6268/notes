# 图

## 图的表示

表示图的三种方法

1. 边的列表 O(E)

```Python
[[0,1], [0,6], [0,8], [1,4], [1,6], [1,9], [2,4], [2,6], [3,4], [3,5], [3,8], [4,5], [4,9], [7,8], [7,9]]
```

2. 临接矩阵 O(V^2) 

```Python
[[0, 1, 0, 0, 0, 0, 1, 0, 1, 0],
[1, 0, 0, 0, 1, 0, 1, 0, 0, 1],
[0, 0, 0, 0, 1, 0, 1, 0, 0, 0],
[0, 0, 0, 0, 1, 1, 0, 0, 1, 0],
[0, 1, 1, 1, 0, 1, 0, 0, 0, 1],
[0, 0, 0, 1, 1, 0, 0, 0, 0, 0],
[1, 1, 1, 0, 0, 0, 0, 0, 0, 0],
[0, 0, 0, 0, 0, 0, 0, 0, 1, 1],
[1, 0, 0, 1, 0, 0, 0, 1, 0, 0],
[0, 1, 0, 0, 1, 0, 0, 1, 0, 0]]
```

3. 临接表

```Python
[[1, 6, 8],
[0, 4, 6, 9],
[4, 6],
[4, 5, 8],
[1, 2, 3, 5, 9],
[3, 4],
[0, 1, 2],
[8, 9],
[0, 3, 7],
[1, 4, 7]]
```

鉴于现实世界中，图一般是稀疏的，我们可以认为邻接表是图的标准表示形式。有些算法可能需要使用邻接矩阵比较方便，下面是一种转换方法：

```Python
def adj2mat(g):
    """
    >>> g = {1: {2: 3, 3: 8, 5: -4},
    ...      2: {4: 1, 5: 7},
    ...      3: {2: 4},
    ...      4: {1: 2, 3: -5},
    ...      5: {4: 6}}
    >>> adj2mat(g) # doctest: +NORMALIZE_WHITESPACE
    {1: {1: 0, 2: 3, 3: 8, 4: inf, 5: -4},
     2: {1: inf, 2: 0, 3: inf, 4: 1, 5: 7},
     3: {1: inf, 2: 4, 3: 0, 4: inf, 5: inf},
     4: {1: 2, 2: inf, 3: -5, 4: 0, 5: inf},
     5: {1: inf, 2: inf, 3: inf, 4: 6, 5: 0}}
    """
    m = {}
    for i in g:
        m[i] = {}
        for j in g:
            if j in g[i]:
                m[i][j] = g[i][j]
            else:
                if i == j:
                    m[i][j] = 0
                else:
                    m[i][j] = float("inf")
    return m
```

## 四个基础算法

深度优先和广度优先遍历和树的遍历完全一样，只需要多一个 visited set 用于保存访问过的节点就可以了。

如何生成路径呢？只要在访问的时候使用一个数组记录一下父节点就行了，参见《算法》第四章

### Floyd-Warshall 多源最短路径算法

如果要让任意两点（例如从顶点 a 点到顶点 b）之间的路程变短，只能引入第三个点（顶点 k），并通过这个顶点 k 中转即 a->k->b，才可能缩短原来从顶点 a 点到顶点 b 的路程。当然也不止一个点，可能是很多个点，也就是说每个顶点都有可能使得另外两个顶点之间的路程变短。

- Floyd-Warshall 求的是任意两点之间的最短距离
- 不能处理负边
- 复杂度 O(N^3)
- 使用了动态规划的思想

```Python
def floyd_warshall(g):
    for k in g:
        for i in g:
            for j in g:
                g[i][j] = min(g[i][j], g[i][k] + g[k][j])
    return g
```

### Dijkstra 单源最短路径算法

首先选取当前节点中距离它最近的点，显然到这个点的最小距离就是这个边了。

```Python

def dijkstra(g, s):
    visited = set([s])
    dist = {}
    for i in g:
        dist[i] = g[s][i]

    for i in g:
        # 寻找当前未访问过的最近节点，也可以用一个堆
        mincost = float("inf")
        for j in g:
            if j not in visited and dist[j] < mincost:
                mincost = dist[j]
                k = j
        visited.add(k)

        # 根据该节点更新路径
        for j in g:
            if j not in visited:
                dist[j] = min(dist[j], dist[k] + g[k][j])
    return dist
```

最小生成树都是贪心算法，感觉没什么可说的。。

### Prim 最小生成树

def prim(g)







### A*

## BFS

什么时候需要用广度优先搜索？距离问题、连通问题、求最短路径

图的广度优先搜索需要有一个 visited set，记录哪些节点已经走过了。

如何求最长路径呢？

    

## 参考资料

1. [Union-Find 并查集算法详解](https://mp.weixin.qq.com/s?__biz=MzAxODQxMDM0Mw==&mid=2247484751&idx=1&sn=a873c1f51d601bac17f5078c408cc3f6)
2. https://www.khanacademy.org/computing/computer-science/algorithms/graph-representation/a/representing-graphs
3. https://gist.github.com/Ceasar/2474603
4. https://wiki.jikexueyuan.com/project/easy-learn-algorithm/dijkstra.html
5. https://www.cnblogs.com/aiyelinglong/archive/2012/03/26/2418707.html