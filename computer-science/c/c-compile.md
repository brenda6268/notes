# C的编译、调试与静态检查


wp_id: 402
Status: publish
Date: 2017-07-27 01:14:00
Modified: 2020-05-16 11:46:30


# 使用Clang/gcc 常用的选项

```
-std=c11	 设定标准为 c11
-Wall	显示所有警告
-O2	二级优化, 通常够用了
-march=native	释放本地CPU所有指令
-g	如果需要使用 gdb 调试的话

-Dmarco=value	 定义宏
-Umarco	undef 宏
-Ipath	 添加到 include
-llibrary	链接到 liblibbrary.a 文件
-Lpath	 添加到链接 

-c	只编译而不链接
-S	生成汇编代码, 但是不生成机器代码
-E	 只预处理

-fopenmp	 打开 OpenMP 支持
-pthread	 添加 pthread 支持
-Werror	 把所有 warning 显示为 error
```

# 如何生成静态库, 动态库

see:

1. http://www.adp-gmbh.ch/cpp/gcc/create_lib.html
2. http://stackoverflow.com/questions/2734719/how-to-compile-a-static-library-in-linux

## 静态库

静态库的创建原理是把不同的目标文件打包在一起, 所以分两步

1. gcc -c -o mean.o mean.c
2. ar rcs libmean.a mean.o
生成的库的名字多了 lib 和. a

使用 `gcc -static main.c -L. -lmean -o a.out`

## 动态库

动态库需要生成 PIC(地址无关代码),

-Wl	 后面的命令会传递给链接器 

```
gcc -c -fPIC calc_mean.c -o calc_mean.o # 大写的-fPIC 比- fpic 更通用, 虽然在 x86平台上没有区别
gcc -shared -Wl,-soname,libmean.so.1 -o libmean.so.1.0.1  calc_mean.o
```

使用 `gcc main.c -o a.out -L. -lmean`

```
LD_LIBRARY_PATH=.
./dynamically_linked
```

## 最常用的指令

cc -Wall -std=c11 source.c -o executable
g++ -Wall -std=c++11 source.cc -o executable


# tips

处理二进制数据时尽量使用uint8_t，而不要使用char

函数的参数类型（接口）尽量使用 `void*`
不要这么做:

```
void processAddBytesOverflow(uint8_t *bytes, uint32_t len) {
    for (uint32_t i = 0; i < len; i++) {
        bytes[0] += bytes[i];
    }
}
```
这么做:
```
void processAddBytesOverflow(void *input, uint32_t len) {
    uint8_t *bytes = input;
for (uint32_t i = 0; i < len; i++) {
        bytes[0] += bytes[i];
    }
}
```

来自 <https://matt.sh/howto-c> 

提交仓库前，统一格式，而不应该在编写过程中注意

不要使用malloc，总是使用calloc，因为清零的性能损失太小了，但是却经常忘记. 这一点存疑

尽量保证在编写内存获取代码的时候就写好释放代码

## 内存泄漏的排查

核心思想，malloc/free不配对

```
windows，使用<crtdbg.h>
#define _CRTDBG_MAP_MALLOC
#include <crtdbg.h>

_CrtDumpMemoryLeaks();
```
linux，使用mtrace实现动态检查
使用valgrind实现静态检查
valgrind --leak-check=full ./a.out
注意查看definitely lost和possible lost

## 调试的工具

- valgrind 排查内存问题
- strace/ltrace 查看系统调用和库调用
- pmap 查看内存使用情况

## 测试

## rr

mozilla's rr is a promising tool to replace gdb. it can replay the recored execution of a program, so you can replay it until you find out the bug.

http://rr-project.org/