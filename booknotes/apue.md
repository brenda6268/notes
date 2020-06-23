# APUE 阅读笔记

wp_id: 357
Status: publish
Date: 2018-06-22 04:50:00
Modified: 2020-05-16 11:09:43

使用 sysconf 来动态地在运行时获取 INT_MAX 等常量地值

# IO

## 不带缓冲的 IO

read write open close lseek 函数

## stdio

标准 IO 库是围绕 stream 来的，而 read/write 等系统函数则是面向文件描述符。

### 缓冲

缓冲分为三种，全缓冲、行缓冲、不缓冲。标准错误是不带缓冲的，标准输入输出等终端设备是行缓冲的，其他是全缓冲的。可以使用 setvbuf  函数更改缓冲类型。使用 fflush 函数强制写入。

### 文件操作

使用 fopen/freopen/fdopen 来打开文件，使用 fclose 关闭文件。使用 fseek 和 ftell 来定位文件。

### 字符 IO

使用 getc/fgetc 读取单个文件，使用 putc/fputc 写入单个字符。注意其中 getc 可以实现为宏，而 fgetc 往往实现为函数，这样方便传递指针，两个的功能是完全一样的。
另外还有函数 ungetc 用于回退一个字符到读取的文件中。ungetc 和 putc 的区别在于，一个是回退文件到读模式的文件中，一个是写入到写模式的文件中。

### 行 IO
千万不要使用 gets 和 puts 函数！可能造成缓冲区溢出攻击。
fgets 会读入 n-1 个字符（包括换行），同时把最后一个字符置为 null。fputs 把一个字符串写出到流中，不包括结尾的 null，也不会额外输出换行。

### 二进制 IO

使用 fread 和 fwrite 函数来实现直接从文件中读取一个结构等数据类型。

### 格式化 IO

printf/dprintf/fprintf/snprintf 函数，注意不要使用 sprintf 函数，可能造成缓冲区溢出攻击。
还有 v 开头的函数组用来使用单个参数代替 vargs。使用 scanf/fscanf/sscanf 读取数据

## 临时文件

使用 tmpname/tmpfile 创建临时文件。使用 mkdtemp 和 mkstemp 创建临时目录。不过尽量使用 tmpfile 和 mkstemp，以避免文件被占用。

## 内存文件

使用 fmemopen 来在内存中创建一个临时文件。但是这样创建的文件会自动写入 null，不适合于二进制文件。

可以使用另外两个函数用于创建内存文件，open_memstream 和 open_wmemstream。这两个函数创建的流只能是写打开，但是可以通过直接访问缓冲区来读取文件内容。非常适用于创建临时文件，提升性能。

# 文件与目录

## 概述

来自头文件 sys/stat.h 调用 stat 函数返回 struct stat 结构。
使用 S_ISXXX(st.st_mode) 宏来判断文件类型，是否是常规文件、目录等。
st_mode 中还包含了 rwx 等权限，使用 S_IRUSR, S_IRGRP 等宏测试。

## suid 和 sgid

在 st_mode 中分别有两位代表了 st_uid 和 st_gid，分别表示当执行此文件时，将进程的有效用户 ID 设置为文件所有者的用户 ID，可以使用 S_ISUID, S_ISGID 测试。另外可以使用 access 函数测试文件的实际用户 ID

举个例子，比如/usr/bin/passwd 程序允许任意用户更改自己的密码，但是/etc/passwd 这个文件又是 root 所有的，这时候因为/usr/bin/passwd 程序设置了 set_uid，普通用户运行 passwd 程序时就拥有了 root 权限，从而可以更改 /etc/passwd 文件

## 新文件的权限

新文件的 uid 设置为进程的有效 uid。新文件的组 ID 可以是：

1. 进程的有效 gid
2. 文件所在目录的 gid。如果所在目录设置了 set_gid。

## 权限操作

### umask

使用 umask 来设定创建文件的默认权限。可以在 shell 中使用 umask 命令来设定。或者使用 umask 函数：
mode_t umask(mode_t cmask); 注意这个函数是为数不多不反悔错误码的函数。

### 更改文件属性

chmod 和 chown

## 黏着位

主要用于对目录操作，如果目录设置了黏着位，只有该文件的拥有者或者目录的拥有者才能够删除该文件，比如 /tmp 大家都可以写，但是不能删除别人的文件。

# 系统数据

# passwd 文件

/etc/passwd 保存了系统中的用户相关信息，虽然这个信息是纯文本的，但是需要使用系统函数来解析，而不是自己解析这个文件。

```
#include<pwd.h>
struct passwd *getpwuid(uid_t uid);
struct passwd *getpwnam(const char* name);
```

如果需要遍历这个文件的话，使用 getpwdent/setpwent/endpwent 三个函数。ent 是 entry 的缩写。getpwent 获得下一个配置项，setpwent 返回第一个配置项，endpwent 关闭文件。

现代的操作系统，通常将真实的密码放在 /etc/shadow 文件中，从而避免密码破解。而使用数据结构 struct spwd 来存储相关信息。与之对应，可以使用 getspnam/getspent/setspent/endspent 函数来操作这个文件。

## group 文件

/etc/group 文件保存了系统中的组相关信息。在 C 中使用 struc group 来代表这个结构。可以使用类似的函数来访问这个文件：getgrpid getgrpnam getgrent/setgrent/endgrent

现代的 unix 操作系统中都包含了辅助组，可以使用以下这些函数来访问辅助组信息
getgroups/setgroups/initgroups

##  其他数据库文件

```
/etc/hosts/ <netdb.h> hostent | getnameinfo/getaddrinfo
/etc/networks <netdb.h> netent | getnetbyname/getnetbyaddr
/etc/protocols <netdb.h> protoent | getprotobyname/getprotobynumber
/etc/services <netdb.h> servent | getservbyname/get servbyport
```

## hostname

可以使用 uname 和 gethostname/sethostname 来操作相关数据

## 时间和日期

time 函数返回当前时间戳。另一个多功能的函数是 clock_gettime。可以使用 clockid 来制定不同的功能，当使用 clock_gettime(CLOCK_REALTIME, tsp) 时，返回更高精度的时间。后一个参数是 timespec 类型的。

```
struct timespec {
    time_t tv_sec;
    long tv_nsec;
}
```

另外需要注意的是 gettimeofday 和 struct timeval 都已经废弃了，建议使用 clock_gettime。另外相关的函数还有 clock_settime 和 clock_getres。可以使用 gmtime 和 localtime 来定义 struct tm，注意在 struct tm 中没有时区信息。使用 mktime 可以从 struct tm 转换到 time_t 或者 timespec。注意这里是从本地时间转换。mktime 参考 TZ 变量

使用 strftime 和 strftime_l 来把 struct tm 转换为人眼可读的字符串。不同的是，strtime 只从 TZ 环境变量中读取时间信息。而 strftime_l 则可以通过参数指定。

# 进程管理

使用 atexit 可以注册在程序退出时运行的函数。

## C 程序的内存布局

正文段 text、全局常量 data、未初始化数据段 bss、堆、栈、命令行参数和环境变量。地址由低到高。使用 malloc/calloc/realloc 函数分配内存，使用 free 函数释放内存。堆从低地址向高地址增长，栈从高地址向低地址增长。

## 环境变量

使用全局常量 environ 访问所有的环境变量，但是当需要访问一个值的时候，使用 getenv。使用 setenv/putenv/unsetenv 等函数更新环境变量。

## 非局部跳转

使用 setjmp 设定跳转的位置。在程序正常执行时，setjmp 返回 0，当发生错误时，调用 longjmp，同时设置返回值，这时候会再次返回到 setjmp 的位置，返回值是刚刚设定的返回值。jmp_buf 一般设定为全局变量

## 资源控制

使用 getrlimit/setrlimit 两个函数

# 进程控制

## pid 相关函数

```
getpid/getppid/getuid/geteuid/getgid/getegid
```

## 创建子进程

fork 创建新的进程，并把父进程的属性都复制一份给子进程，子进程随后可以执行相同的代码（比如 web 服务器），或者调用 exec 执行新的程序。

linux 上还有更高级的 clone 调用。

exec 使用文件名和参数列表作为参数，执行一个新的程序。还可以传递环境变量。其中 execve 是系统调用，而其他函数则是库函数。

可以使用 setuid 和 setgid 来改变进程的 uid 和 gid，但是仅限于实际 uid 和文件的 setuid。

system 函数直接执行一个命令，并返回执行结果。需要注意的是，千万不要在 setuid 的程序中使用 system 函数，这样会导致 system 调用的命令权限过大。

通过 nice 函数可以调节进程的 nice 值，nice 值越大，优先级月底

## 进程退出
在 Unix 上，exit 是一个库函数，_exit 是一个系统调用。所有父进程结束的进程，他们的父进程会变为 init 进程。父进程有义务处理子进程的现场，对于已经退出，但是父进程还没有处理的进程，称之为僵尸进程，而 init 进程总会回收他的子进程，避免造成僵尸进程。

进程退出后，系统会向父进程发送信号，父进程可以在这时候回收进程。可以使用 wait/waitpid/waitid 来获取退出的进程的 ID，从而进行相应的清理。其中 waitid 应该是最好的，但是似乎比较新，文档不多

信号定义的头文件是 singal.h 

restrict keyword

restrict says that the pointer is the only thing that accesses the underlying object. It eliminates the potential for pointer aliasing, enabling better optimization by the compiler.
For instance, suppose I have a machine with specialized instructions that can multiply vectors of numbers in memory, and I have the following code:

```c
void MultiplyArrays(int* dest, int* src1, int* src2, int n) {
    for(int i = 0; i < n; i++) {
        dest[i] = src1[i]*src2[i];
    }
}
```

The compiler needs to properly handle if dest, src1, and src2 overlap, meaning it must do one multiplication at a time, from start to the end. By having restrict, the compiler is free to optimize this code to using the vector instructions.
EDIT: Wikipedia has an entry on restrict, with another example, here.