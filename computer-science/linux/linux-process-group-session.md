# Linux 中的 Process Group 和 Session

<!--
ID: d7f54367-5f6d-4001-8dec-a4b7be72658e
Status: publish
Date: 2018-10-20T07:22:00
Modified: 2020-05-16T11:25:59
wp_id: 482
-->

# 进程

## 进程的几个基本概念

Init Process：PID 为 1 的进程，所有用户进程的根，一般来说，现在都是 systemd 了。
进程组：当使用管道的时候，创建的多个进程在一个进程组内。
Session：一个会话
控制终端：这个是和 session 绑定的概念
孤儿进程：父进程已经退出，子进程还没有退出，这时候子进程叫做孤儿进程，一般来说孤儿进程会被 init 接管。
僵尸进程：子进程已经退出，但是父进程还没有处理，这时候子进程叫做僵尸进程

## 守护进程

可以使用 `ps -axj` 查看守护进程，x 是没有 control Terminal 的意思。

PPID = 0 的进程一般是内核进程。除了 init 以外。

除了处理文件以外，实现一个守护进程一般有以下几步，一般称作 double fork

1. 第一次 fork，退出父进程，子进程不再是进程组 Leader，这样才能调用 setsid。 
2. 调用 setsid，创建一个新的 session，并成为 Leader，这样就摆脱了 Control Terminal。
3. 再次调用 fork，退出父进程，init 成为 Session Leader。彻底避免 Control Terminal。

有的守护进程为了避免有多个实例在运行，会创建 /var/run/DAEMON.pid 文件，通过文件锁的形式避免。

使用了这么多年的 Ubuntu, 自以为 Linux 下进程的概念已经很熟悉了，然而发现进程组 (Process Group) 和会话 (Session) 两个概念日常并不会接触很多，平时也没有注意，导致今天遇到一个问题还想了半天才想明白。

看了一些讲进程控制的书和文章，感觉都比较老了，不少都还在讲 double fork 的原理及意义，而现实是 systemd 已经接管了几乎整个 Linux 世界，double fork 这种东西真的不应该存在了，至少在新的程序中不应该再使用了，所以有了这篇文章。

## 引子--问题

我们知道在命令行运行的前台命令，可以随时通过 Ctrl-C 关闭掉。原理很简单，当我们按下 Ctrl-C 的时候，shell 进程会向前台进程发送一个 SIGINT 信号，进程收到 SIGINT 的默认操作就是退出。按照这个思路出发，在 fork 之后，如果按下 Ctrl-C 应该只有主进程会关闭，而子进程应该继续运行，实际上并不是这样的，两个进程都收到了 SIGINT 信号。

```py
import os
import sys
import time

def child():
    while True:
        try:
            sys.stdout.write("child process\n")
            sys.stdout.flush()
            time.sleep(5)
        except KeyboardInterrupt:
            sys.stdout.write("child sigint\n")
            sys.stdout.flush()
            sys.exit()

def main():
    while True:
        try:
            sys.stdout.write("main process\n")
            sys.stdout.flush()
            time.sleep(4)
        except KeyboardInterrupt:
            sys.stdout.write("main sigint\n")
            sys.stdout.flush()
            sys.exit()

pid = os.fork()

if pid != 0:
    main()
else:
    child()
```

当我们按下 Ctrl-C 的时候

```
main process
child process
main process
child process
^Cchild sigint
main sigint

```

也就是说上述说法并不是完全正确的。实际上，SIGINT 并不只会发送给前台进程，而是发送给**前台进程组**中的每一个进程。那么什么是进程组呢？

# 进程 -- Process

要说进程组，我们首先来回忆一下进程的概念。进程可以理解为 "进行中的程序", 在 Linux 上可以通过 fork 来创建新的进程，然后可以使用 exec 来在子进程或者父进程中执行新的程序。

## 进程退出的情况

当一个进程的子进程退出的时候，父进程有义务对子进程的状态进行回收 (wait). 子进程退出的时候，父进程会收到 SIGCHLD 信号。如果子进程退出了，而父进程又还没有进行回收，那么在这段时间内，这个子进程被称为僵尸进程 (zombie process), 僵尸进程会持续占用一部分系统资源，所以最好还是尽快回收。如果父进程没有进行回收，也退出了，pid=1 的 init 进程会接管僵尸状态的子进程并进行回收。

当一个进程的父进程退出时，这个进程被称为孤儿进程 (orphaned process), 子进程会被 init 进程接管，也就是说，子进程的 ppid 会变成 1. 但是，默认情况下，子进程并不会收到任何信号。不过，可以使用 prctl 系统调用来设置在父进程退出的时候，子进程收到什么信号。

# 进程组 -- Process Group

顾名思义就是一组进程。进程组的 id (pgid) 就是进程组组长 (group leader) 的 pid. 当一个进程 fork 的时候，子进程默认是和父进程在同一个进程组的。从 shell 中启动一个进程的时候，shell 会给这个进程设置为一个新的进程组。如果使用了 pipe, 那么 shell 会将这些进程放入同一个进程组，比如 `cat hello | less`

需要注意的是，当进程组的 leader 退出的时候，进程组的其他进程并不会受影响，系统不会给孤儿进程发送任何信号。一个进程组在最后一个进程退出时消失。

## 相关函数

```
getpgid(pid) - 获得指定 pid 对应的 pgid
setpgid(pid, pgid) - 设定指定进程的 pgid
```

其中可以用 0 来表示当前进程，如果设置当前进程的 pgid 为自己的 pid, 也就是钦点自己为 group leader, 那么就相当于创建了一个新的进程组。

## 相关命令

kill 命令用来给 pid 发送信号，一般命令形式是 `kill -SIG PID`, 可以在 PID 参数前面加上 `-` 表示一个 Process Group, 而不是 Process. 比如：

```
kill -TERM -6379  # 向 6379 进程组发送 TERM 信号
```

# 回到问题

那么我们现在可以再思考一下刚开始的问题，为什么按 Ctrl-C 的时候，父进程和子进程都会收到 SIGINT 信号呢？答案之前说了：实际上，SIGINT 并不只会发送给前台进程，而是发送给前台进程组中的每一个进程。而父进程和子进程当前所在的组正是前台进程组。

前台进程组是一个 session 中在前台运行的那一组进程，那么什么又是 session 呢？

# 会话 -- session

session 是一个更大的概念，一个 session 中可以包含多个 process group.

他们的关系是这样的：

```
+--------------------------------------------------------------+
|                                                              |
|      pg1             pg2             pg3            pg4      |
|    +------+       +-------+        +-----+        +------+   |
|    | bash |       | sleep |        | cat |        | jobs |   |
|    +------+       +-------+        +-----+        +------+   |
| session leader                     | wc  |                   |
|                                    +-----+                   |
|                                                              |
+--------------------------------------------------------------+
                            session
```

和 process group 一样，每个 session 也有一个 leader, session leader 就是 这个进程的 pid. session 的本意是用来作业控制，每个用户登录的时候都会创建自己的 session. 一般来说在 shell 中，session leader 就是 shell 本身。

## 相关函数

```
getsid(pid) - 获得指定 pid 对应的 sid
setsid() - 创建新的 session
```

其中需要注意的是，setsid 不能由 group leader 进程来调用，因为这样会导致同一个 group 中的进程属于不同的 session, 所以 POSIX 标准直接禁止了这么做。

## session 退出

当一个 session leader 退出时，其他进程不会受到任何影响，但是因为 session leader 退出可能造成 orphaned process group, 因此在 shell 中，**一般情况下会造成进程退出的情况**

## Orphaned Process Group

当一个 group leader 退出的时候，本身并不会对进程组造成任何影响，也不会收到任何信号。但是，当一个进程组变成孤儿进程组 (orphaned process group) 的时候，可能会收到一些信号。

> 孤儿进程组
>
> A process group is called orphaned when the parent of every member is either in the process group or outside the session. In particular, the process group of the session leader is always orphaned.

如果一个进程组中的所有进程的父进程都在组内或者都是其他 session 的进程（比如 init) 的时候，这个进程组被称为孤儿进程组。显然，每个进程的退出或者移出进程组都可能造成进程组变成孤儿进程组。

**如果这时候进程组中的某个进程的状态是 STOP, 那么内核会向该进程组的所有进程发送 SIGHUP, 并紧接着发送 SIGCONT 信号。**

值得注意的是，session leader 本身就是一个孤儿进程组了，所以退出的时候不会给本组的进程发信号，下面要用到。

为什么内核要这么做呢？

一般情况下，shell 进程是当前 session 的 leader, 当我们运行每个命令的时候都会创建一个新的 Process Group, 如果这时候某个孤儿进程组中有进程是 STOP 状态的，那么可能就再也没有机会运行了，所以系统首先发送 SIGHUP 信号退出，如果有进程对 SIGINT 做了处理，那么在收到 SIGCONT 信号之后又可以继续运行了。

也就是说当我们退出 shell 的时候，内核会向 session 中的

1. 前台进程组
2. 孤儿进程组

发送 SIGHUP 信号，从而退出他们。那么问题来了，后台进程组呢？

答案是：shell 会向 session 的所有进程组发送 SIGHUP 信号，所以运行中的后台进程组也会退出。

## daemonize

在 Unix 的上古时期，没有 Process Manager 这个概念，所以每个守护进程（比如说 apache) 都需要自己变成守护进程，一般来说是通过 double fork 的形式：

1. fork 第一次，确保自己不是 group leader
2. setsid, 创建新的 session
3. fork 第二次，确保自己不是 session leader, 避免获取 tty

实际上整个步骤需要 15 步之多，可以查看 `man 7 daemon` 命令。

整个过程非常复杂，在 GNU C lib 中提供了 daemon() 函数来实现这些步骤，然而讽刺的是，由于步骤实在太多了，系统提供的 daemon 函数竟然忘了其中几步，所以不推荐使用。..

在我看来，由进程自我守护实际上完全背离的 Unix philosophy -- Write programs that do one thing and do it well, 每个进程应该只做一件事，变成守护进程显然是让一个进程做了两件事，而且是一个重复性的工作，由一个统一的 init 进程来管理 daemon 才是真正符合 Unix 哲学的。

# systemd

在现代的 Linux 上，系统层面，我们通过 systemd 来管理守护进程，每个进程只需要实现最简单的单进程程序就好了，然后通过编写 systemd 的 unit 文件来实现 daemonize. 用户层面，我们可以使用 supervisord 或者 pm2 来管理进程，他们和 systemd 的功能和理念都是类似的。

但是，如上文所述，一个进程完全可以通过 setsid 和 fork 等操作而完全脱离创建进程的控制，而且不少进程在创建的时候也是具有 root 权限的，那么 systemd 是怎样确保进程不会偷偷跑掉的呢？

答案是 cgroups, 且听下回分解。..

# 参考资料

1. https://www.win.tue.nl/~aeb/linux/lk/lk-10.html
2. https://notes.shichao.io/apue/ch9/#sessions
3. http://blog.jorgenschaefer.de/2014/07/why-systemd.html
4. https://unix.stackexchange.com/questions/149741/why-is-sigint-not-propagated-to-child-process-when-sent-to-its-parent-process
5. https://segmentfault.com/a/1190000009152815
6. https://stackoverflow.com/questions/24346126/where-do-zombie-processes-go-after-their-parent-dies
7. https://stackoverflow.com/questions/881388/what-is-the-reason-for-performing-a-double-fork-when-creating-a-daemon
8. https://unix.stackexchange.com/questions/404054/how-is-a-process-group-id-set
9. https://stackoverflow.com/a/39109685/1061155
10. https://stackoverflow.com/questions/32780706/does-linux-kill-background-processes-if-we-close-the-terminal-from-which-it-has
11. https://superuser.com/questions/403200/what-is-a-stopped-process-in-linux
12. http://www.informit.com/articles/article.aspx?p=397655&seqNum=6
13. https://stackoverflow.com/questions/13069634/python-daemon-and-systemd-service
14. https://unix.stackexchange.com/questions/447275/does-systemd-not-protect-processes-against-acquiring-a-controlling-terminal
15. https://linuxaria.com/article/how-to-manage-processes-with-cgroup-on-systemd
1. https://unix.stackexchange.com/questions/407448/what-happens-to-a-unix-session-when-the-session-leader-exits