# Python 中复合的 list comprehension

<!--
ID: 584befd3-96a8-4214-83e9-1eca2b810d4e
Status: publish
Date: 2017-05-30T13:17:00
Modified: 2020-05-16T12:02:34
wp_id: 652
-->

Python 中的 list comprehension 可以复合

```py
[x for li in lists for x in li if x]
```

就相当于

```py
[x
    for li in lists
        for x in li
             if x]
```