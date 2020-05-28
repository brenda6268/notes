# C/C++ 中的 RAII


wp_id: 401
Status: publish
Date: 2017-05-29 15:36:00
Modified: 2020-05-16 12:10:11


# RAII 的好处

* 异常安全
* 保证匹配
* 防止内存泄露

# RAII in C

This is inherent implementation dependent, since the Standard doesn't include such a possibility. For GCC, the cleanup attribute runs a function when a variable goes out of scope:

```c
#include <stdio.h>

void scoped(int * pvariable) {
    printf("variable (%d) goes out of scope\n", *pvariable);
}
int main(void) {
    printf("before scope\n");
    {
        int watched __attribute__((cleanup (scoped)));
        watched = 42;
    }
    printf("after scope\n");
}
```

Prints:
```
before scope
variable (42) goes out of scope
after scope
```