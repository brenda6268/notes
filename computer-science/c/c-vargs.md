# C语言中的 vargs

<!--
ID: f7ee56ab-a6b2-482f-a539-9f51bcb8a04b
Status: publish
Date: 2017-05-29T15:02:00
Modified: 2020-05-16T12:09:21
wp_id: 405
-->

```
int max(int n, ...) {
    va_list arg_pointer;
    int result = INT_MIN;
    
    va_start(arg_pointer, n);
    for (int i = 0; i < n; i++) {
        int arg = va_arg(arg_pointer, int);
        if (arg > result)
            result = arg;
    }
    va_end(arg_pointer);

    return result;
}     
```

Reference
------

1. http://www.cnblogs.com/chinazhangjie/archive/2012/08/18/2645475.html

2. http://wiki.jikexueyuan.com/project/c-advance/other.html