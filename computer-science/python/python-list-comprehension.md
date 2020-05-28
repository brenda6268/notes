# Python 中复合的 list comprehension


wp_id: 652
Status: publish
Date: 2017-05-30 13:17:00
Modified: 2020-05-16 12:02:34


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