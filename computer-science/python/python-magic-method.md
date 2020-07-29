# Python 类中的 magic method

<!--
ID: 05496629-1245-462a-883d-23c1a8be4ceb
Status: draft
Date: 2018-06-22T08:55:00
Modified: 2020-05-16T11:12:17
wp_id: 673
-->

## string representation

define __str__ and __repr__ method, note that __str__ is meant to be read by human, while eval(repr(x)) == x should always be true

## formatting

define __format__
"hello {:param}".fromat(x) is called as x.__format__("param")

## context manager protocol

```
__enter__(self) -> object
__exit__(self, exception_type, exception_val, trace_back) -> bool
```

if __exit__ returns True, it means the exception has been handled