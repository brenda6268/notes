# 阅读 redis 源码

<!--
ID: 6d03e9a4-8dfd-4569-8fdf-833d949ba57b
Status: publish
Date: 2017-06-17T02:15:00
Modified: 2020-05-16T11:43:28
wp_id: 570
-->

# 字符串

redis 内部使用 Simple Data String 代表字符串。结构如下：

sds 的内存分配策略：

1. 如果当前内存不能够放得下需要的字符串，长度翻倍。放得下则直接放。当超过 30M 时，则每次增长 1M
2. 如果释放内存时，不释放空间
3. redis 的字符串是二进制安全的

# 链表

redis 的 list 是使用链表实现的。

```c
typedef struct listNode {
    struct listNode * prev;
    struct listNode * next;
    void * value;
} listNode;

typedef struct list {
    listNode * head;
    listNode * tail;"
    unsigned long len;
    void *(*dup) (void *ptr);
    void (*free)(void *ptr);
    int (*match) (void * ptr, void * key);
} list;
```

* https://zhengqm.github.io/code/2015/06/20/Learn-by-hacking-redis-source-code/
* https://github.com/huangz1990/blog/blob/master/diary/2014/how-to-read-redis-source-code.rst
