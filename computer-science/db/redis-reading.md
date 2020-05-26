# 阅读 redis 源码


ID: 570
Status: publish
Date: 2017-06-17 02:15:00
Modified: 2020-05-16 11:43:28


* https://zhengqm.github.io/code/2015/06/20/Learn-by-hacking-redis-source-code/
* https://github.com/huangz1990/blog/blob/master/diary/2014/how-to-read-redis-source-code.rst

# 字符串

redis 内部使用Simple Data String 代表字符串。结构如下：

sds的内存分配策略：

1. 如果当前内存不能够放得下需要的字符串，长度翻倍。放得下则直接放。当超过30M时，则每次增长1M
2. 如果释放内存时，不释放空间
3. redis的字符串是二进制安全的

# 链表

redis 的 list 是使用链表实现的。

```
typedef struct listNode {
    struct listNode * prev;
    struct listNode * next;
    void * value;
} listNode;

typedef struct list {
    listNode * head;
    listNode * tail;&#039;
    unsigned long len;
    void *(*dup) (void *ptr);
    void (*free)(void *ptr);
    int (*match) (void * ptr, void * key);
} list;
```