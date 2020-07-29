# 排序

<!--
ID: d22b8518-2d42-433a-8a4e-273c7456f634
Status: draft
Date: 2020-07-29T23:37:30
Modified: 2020-07-29T23:37:30
wp_id: 1696
-->

## 选择排序

```Python
def selection_sort(l):
    for idx, i in enumerate(l):
        min = idx
        for j in range(idx, len(l)):
            if l[j] < l[min]:
                min = j
        l[min], l[i] = l[j], l[min]
```

## 堆排


## 参考资料

1. https://wiki.jikexueyuan.com/project/easy-learn-algorithm/bucket-sort.html
