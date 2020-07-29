# 指针类题目与窗口

<!--
ID: 211bd155-7d52-4ca0-a6a6-0a82e0308f39
Status: draft
Date: 2020-07-29T23:37:30
Modified: 2020-07-29T23:37:30
wp_id: 1678
-->

## 链表的指针题目

一般使用 dummy head 的话，循环条件是 while p.next, 而不使用的话，则是 while p.

### 递归反转列表

```Java
int reverseList(ListNode node) {
    if (node == null || node.next == null) {
        return node;
    }
    ListNode head = reverseList(node.next);
    node.next.next = node;
    node.next = null;
    return head;
}
```

都比较简单，主要是细节的使用。

- LeetCode 24
- LeetCode 25
- LeetCode 206

## 参考资料

1. https://mp.weixin.qq.com/s/YFe9Z35CE4QWPDmPNitd4w