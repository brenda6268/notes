# Python 类中的 magic method


ID: 673
Status: draft
Date: 2018-06-22 08:55:00
Modified: 2020-05-16 11:12:17


# string representation

define __str__ and __repr__ method, note that __str__ is meant to be read by human, while eval(repr(x)) == x should always be true

# formatting

define __format__
"hello {:param}".fromat(x) is called as x.__format__("param")

# context manager protocol

```
__enter__(self) -&gt; object
__exit__(self, exception_type, exception_val, trace_back) -&gt; bool
```

if __exit__ returns True, it means the exception has been handled