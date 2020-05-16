# 进程

## 进程的几个基本概念

Init Process：PID 为 1 的进程，所有用户进程的根，一般来说，现在都是 systemd 了。
进程组：当使用管道的时候，创建的过个进程在一个进程组内。
Session：一个会话
控制终端：这个是和 session 绑定的概念
孤儿进程：父进程已经退出，子进程还没有退出，这时候子进程叫做孤儿进程，一般来说孤儿进程会被 init 接管。
僵尸进程：子进程已经退出，但是父进程还没有处理，这时候子进程叫做僵尸进程

## 守护进程

可以使用 `ps -axj` 查看守护进程，x 是没有 control Terminal 的意思。

PPID = 0 的进程一般是内核进程。除了 init 以外。

除了处理文件以外，实现一个守护进程一般有以下几步, 一般称作 double fork

1. 第一次 fork，退出父进程，子进程不再是进程组 Leader，这样才能调用 setsid。 
2. 调用 setsid，创建一个新的 session，并成为 Leader，这样就摆脱了 Control Terminal。
3. 再次调用 fork，退出父进程，init 成为 Session Leader。彻底避免 Control Terminal。

有的守护进程为了避免有多个实例在运行，会创建 /var/run/DAEMON.pid 文件，通过文件锁的形式避免。


## 参考文献

1. https://unix.stackexchange.com/questions/407448/what-happens-to-a-unix-session-when-the-session-leader-exits