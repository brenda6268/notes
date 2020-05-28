# strace


wp_id: 107
Status: publish
Date: 2019-06-15 17:44:26
Modified: 2019-07-06 13:17:49


尽管在线下会做充足的测试，但是线上出问题是难免的。当我们的程序在线上运行中遇到问题的时候，而我们又没有日志可以观察到底哪里出了问题，这时候可以使用 strace 命令。strace 可以直接根据 pid 附着到进程上，打印出进程的一些统计信息，为排查 bug 提供有意义的参考。

Strace 的选项

1. c – See what time is spend and where (combine with -S for sorting)
2. f – Track process including forked child processes
3. o my-process-trace.txt – Log strace output to a file
4. p 1234 – Track a process by PID
5. P /tmp – Track a process when interacting with a path
6. T – Display syscall duration in the output

Track by specific system call group 

1. e trace=ipc – Track communication between processes (IPC)
2. e trace=memory – Track memory syscalls
3. e trace=network – Track memory syscalls
4. e trace=process – Track process calls (like fork, exec)
5. e trace=signal – Track process signal handling (like HUP, exit)
6. e trace=file – Track file related syscalls

Trace multiple syscalls 

```
strace -e open,close
```

## 统计进程系统调用花费时间

```
strace -c -f -p 11084
```

一般来说要加上 -f 选项，这样才能跟踪多进程程序，也就是 fork 之后的进程。

![](https://yifei.me/wp-content/uploads/2019/06/20190605-145050-1.png)

```
strace -o output.txt -T -tt -e trace=all -p 28979
```

使用和这个命令可以统计每一个系统调用的时间

1. 使用 struss 查看系统问题 [https://www.ibm.com/developerworks/cn/linux/l-tsl/index.html](https://www.ibm.com/developerworks/cn/linux/l-tsl/index.html "https://www.ibm.com/developerworks/cn/linux/l-tsl/index.html")
2. strace 的详细用法 [https://blog.csdn.net/uisoul/article/details/83143290](https://blog.csdn.net/uisoul/article/details/83143290 "https://blog.csdn.net/uisoul/article/details/83143290")
3. [https://blog.csdn.net/budong282712018/article/details/83151953](https://blog.csdn.net/budong282712018/article/details/83151953 "https://blog.csdn.net/budong282712018/article/details/83151953")
4. [https://blog.csdn.net/maple_leaves_for_me/article/details/42391979](https://blog.csdn.net/maple_leaves_for_me/article/details/42391979 "https://blog.csdn.net/maple_leaves_for_me/article/details/42391979")
5. [https://blog.51cto.com/5iwww/771031](https://blog.51cto.com/5iwww/771031 "https://blog.51cto.com/5iwww/771031")
6. [https://blog.csdn.net/lotluck/article/details/77943152](https://blog.csdn.net/lotluck/article/details/77943152 "https://blog.csdn.net/lotluck/article/details/77943152")
7. [https://linux-audit.com/the-ultimate-strace-cheat-sheet/](https://linux-audit.com/the-ultimate-strace-cheat-sheet/ "https://linux-audit.com/the-ultimate-strace-cheat-sheet/")