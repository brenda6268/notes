# C/C++ 中的 RAII

<!--
ID: 7523feab-e7ef-4546-87cd-9515c39ed807
Status: publish
Date: 2017-05-29T15:36:00
Modified: 2020-05-16T12:10:11
wp_id: 401
-->

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