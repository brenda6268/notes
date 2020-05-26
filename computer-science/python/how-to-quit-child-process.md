# 父进程退出后如何退出子进程


ID: 650
Status: publish
Date: 2018-07-09 03:52:00
Modified: 2020-05-16 11:15:03


我们知道当子进程推出的时候，父进程会收到 SIGCHLD 信号，从而可以采取相应的操作。但是当父进程退出的时候，系统会把子进程的父进程更改为pid=0的 init 进程，而且子进程不会收到任何信号。而我们经常想在父进程退出的时候，让子进程也推出。在 Python 中可以有如下几种做法。

# 设置子进程为 daemon

这里的 daemon 和系统的守护进程没有任何关系，是 quit_when_parent_dies 的意思。也就是当父进程退出的时候，会自动尝试关闭 daemon=True 的子进程。

```
p = multiprocessing.Process(target=foo)
p.daemon = True
p.start()
```

[官方文档](https://docs.python.org/3/library/multiprocessing.html#multiprocessing.Process.daemon)

# 在子进程中设置 PDEATHSIG

在 Linux 中，进程可以要求内核在父进程退出的时候给自己发信号。使用系统调用 prctl。

```
prctl(PR_SET_PDEATHSIG, SIGHUP);
```

在 Python中也有[对应的包 python-prctl](https://github.com/seveas/python-prctl)，可以在**子进程**中这样使用，这样在父进程挂掉的时候，子进程就会收到 SIGHUP 信号：

```
# apt-get install build-essential libcap-dev
# pip install python-prctl

import signal
import prctl

prctl.set_pdeathsig(signal.SIGHUP)
```

缺点：只支持 linux

# 父进程在终止的时候回收子进程

可以使用 atexit.register 在主进程中注册代码：

```
# pip install psutil


import psutil
import atexit
import os
import signal

@atexit.register
def kill_children():
    print(&#039;quitting, press Ctrl-C to force quit&#039;)
    current_process = psutil.Process()
    children = current_process.children(recursive=True)
    for child in children:
        print(&#039;Child pid is {}&#039;.format(child.pid))
        os.kill(child.pid, signal.SIGTERM)
```

使用 atexit 在[收到 SIGTERM 的时候并不能触发](http://yifei.me/note/558)，所以最好使用 signal 注册到主进程对应的信号上。

缺点是当使用 kill -9 或者使用 os._exit 的时候不会调用这些函数。