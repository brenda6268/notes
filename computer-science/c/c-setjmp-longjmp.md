# C 语言中的 setjmp/longjmp

<!--
ID: 4fea806e-7019-4d12-83cf-2b0887a31f84
Status: publish
Date: 2017-05-29T01:09:00
Modified: 2020-05-16T12:07:22
wp_id: 408
-->

首先吐槽一下这个缩写，好好地 jump 单词才四个字母不用，非要缩写成 jmp 三个字母，每次都打错，蛋疼

在 C 中，goto 语句是不能跨越函数的，而执行这类跳转功能的是 `setjmp` 和 `longjmp` 宏。这两个宏对于处理发生在深层嵌套函数调用中的出错情况是非常有用的。

此即为：非局部跳转。非局部指的是，这不是由普通 C 语言 goto 语句在一个函数内实施的跳转，而是在栈上跳过若干调用帧，返回到当前函数调用路径的某个函数中。

    #include <setjmp.h>
    int  setjmp (jmp_buf env) ;  /*设置调转点*/
    void longjmp (jmp_buf env,  int val) ;  /*跳转*/

`setjmp` 参数 env 的类型是一个特殊类型 `jmp_buf`。这一数据类型是某种形式的数组，其中存放 在调用 `longjmp` 时能用来恢复栈状态的所有信息。因为需在另一个函数中引用 env 变量，所以应该将 env 变量定义为全局变量。

`longjmp` 参数 val，它将成为从 setjmp 处返回的值。

    #include <stdio.h>
    #include <setjmp.h>
    static jmp_buf buf;
    void second(void){
        printf("second\n");
        longjmp(buf,1);
        // 跳回 setjmp 的调用处使得 setjmp 返回值为 1
    }
    void first(void) {
        second();
        printf("first\n");
        // 不可能执行到此行
    }
    int main(){
        if (!setjmp(buf)) {
            // 进入此行前，setjmp 返回 0
            first();
        } else {
            // 当 longjmp 跳转回，setjmp 返回 1，因此进入此行
            printf("main\n");
        }
        return 0;
    }

直接调用 setjmp 时，返回值为 0，这一般用于初始化（设置跳转点时）。以后再调用 longjmp 宏时用 env 变量进行跳转。程序会自动跳转到 setjmp 宏的返回语句处，此时 setjmp 的返回值为非 0，由 longjmp 的第二个参数指定。
一般地，宏 `setjmp` 和 `longjmp` 是成对使用的，这样程序流程可以从一个深层嵌套的函数中返回。
