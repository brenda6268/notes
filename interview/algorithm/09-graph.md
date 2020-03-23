## 图的表示

表示图的三种方法

1. 边的列表 O(E)

```
 [ [0,1], [0,6], [0,8], [1,4], [1,6], [1,9], [2,4], [2,6], [3,4], [3,5], [3,8], [4,5], [4,9], [7,8], [7,9] ]
```

2. 临接矩阵 O(V^2) 

![](https://tva1.sinaimg.cn/large/00831rSTly1gd19mghnxgj306s06tmxf.jpg)

[ [0, 1, 0, 0, 0, 0, 1, 0, 1, 0],
  [1, 0, 0, 0, 1, 0, 1, 0, 0, 1],
  [0, 0, 0, 0, 1, 0, 1, 0, 0, 0],
  [0, 0, 0, 0, 1, 1, 0, 0, 1, 0],
  [0, 1, 1, 1, 0, 1, 0, 0, 0, 1],
  [0, 0, 0, 1, 1, 0, 0, 0, 0, 0],
  [1, 1, 1, 0, 0, 0, 0, 0, 0, 0],
  [0, 0, 0, 0, 0, 0, 0, 0, 1, 1],
  [1, 0, 0, 1, 0, 0, 0, 1, 0, 0],
  [0, 1, 0, 0, 1, 0, 0, 1, 0, 0] ]


3. 临接表 

![](https://tva1.sinaimg.cn/large/00831rSTly1gd19mx7i20j305806ct8y.jpg)

[ [1, 6, 8],
  [0, 4, 6, 9],
  [4, 6],
  [4, 5, 8],
  [1, 2, 3, 5, 9],
  [3, 4],
  [0, 1, 2],
  [8, 9],
  [0, 3, 7],
  [1, 4, 7] ]

https://www.khanacademy.org/computing/computer-science/algorithms/graph-representation/a/representing-graphs

寻路算法

Dijkstra

A*

四个基础算法

https://www.cnblogs.com/aiyelinglong/archive/2012/03/26/2418707.html

    

# 参考资料

1. [Union-Find 并查集算法详解](https://mp.weixin.qq.com/s?__biz=MzAxODQxMDM0Mw==&mid=2247484751&idx=1&sn=a873c1f51d601bac17f5078c408cc3f6)
	
