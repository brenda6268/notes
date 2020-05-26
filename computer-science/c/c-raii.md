# C/C++ 中的 RAII


ID: 401
Status: publish
Date: 2017-05-29 15:36:00
Modified: 2020-05-16 12:10:11


# RAII 的好处

* 异常安全
* 保证匹配
* 防止内存泄露

# RAII in C

This is inherent implementation dependent, since the Standard doesn't include such a possibility. For GCC, the cleanup attribute runs a function when a variable goes out of scope:

```
#include &lt;stdio.h&gt;
void scoped(int * pvariable) {
    printf(&quot;variable (%d) goes out of scope\n&quot;, *pvariable);
}
int main(void) {
    printf(&quot;before scope\n&quot;);
    {
        int watched __attribute__((cleanup (scoped)));
        watched = 42;
    }
    printf(&quot;after scope\n&quot;);
}
```

Prints:
```
before scope
variable (42) goes out of scope
after scope
```