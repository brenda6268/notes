# 使用 prctl 在父进程退出的时候安全退出子进程


wp_id: 655
Status: publish
Date: 2018-10-15 23:50:00
Modified: 2020-05-16 11:25:31


在 Linux 中, 当子进程退出的时候, 父进程可以收到信号, 但是当父进程退出的时候, 子进程并不会受到信号. 这样就造成了在父进程崩溃的时候, 子进程并不能同时退出, 而是一直会在后台运行, 比如下面的例子:

```py
import os
import time

def loop_print():
    import time
    while True:
        print(&#039;child alive, %s&#039; % time.time())
        time.sleep(1)

try:
    pid = os.fork()
except OSError:
    pass

if pid != 0:  # parent
    print(&#039;parent sleep for 2&#039;)
    time.sleep(2)
    print(&#039;parent quit&#039;)
else:
    loop_print()
```

当父进程退出的时候, 子进程一直在不断地 print, 而没有退出.

# naive 的方法, 使用 multiprocessing 库

昨天我已经吐槽过标准库的 multiprocessing 有很多坑, 不出所望, 在这个问题上 multiprocessing 依然提供了半个解法, 只解决了一半问题......

在使用 multiprocessing 库创建进程的时候, 可以设置 `Process.daemon = True`, 这个属性又是模仿 threading 库的 API 来的.

正常情况下, 当一个程序收到 SIGTERM 或者 SIGHUP 等信号的时候, multiprocessing 会调用每个子进程的 terminate 方法, 这样会给每个子进程发送 SIGTERM 信号, 子进程就可以优雅退出. 然而, 当异常发生的时候, 父进程挂了, 比如说收到了 SIGKILL 信号, 那么子进程就得不到收割, 也就变成了孤儿进程.

所以说, multiprocessing 库只解决了半个问题, 真遇到问题的时候就会坑你一把.

# 正确解决方法

Linux 提供了 prctl 系统调用, 可以由子进程向内核注册父进程退出时候收到什么信号, 我们只要注册一个 SIGTERM 信号就好了.

在 Python 中可以使用 python-prctl 这个包.

## 安装

```
# apt install libcap-dev &amp;&amp; pip install python-prctl
```

## 使用

以上面的程序为例:

```
import os
import time

def loop_print():
    import time
    import prctl
    import signal
    prctl.set_pdeathsig(signal.SIGTERM)
    while True:
        print(&#039;child alive, %s&#039; % time.time())
        time.sleep(1)

try:
    pid = os.fork()
except OSError:
    pass

if pid != 0:  # parent
    print(&#039;parent sleep for 2&#039;)
    time.sleep(2)
    print(&#039;parent quit&#039;)
else:
    loop_print()
```

这次我们看到, 在父进程退出的同时, 子进程也推出了.

```
parent sleep for 2
child alive, 1539676057.5094635
child alive, 1539676058.5105338
parent quit
```