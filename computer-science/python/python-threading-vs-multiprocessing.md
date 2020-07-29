# 吐槽一下 Python 混乱的 threading 和 multiprocessing

<!--
ID: 05afd3c8-bb66-4703-8cad-93a68f171ba4
Status: publish
Date: 2018-10-15T03:21:00
Modified: 2020-05-16T11:25:22
wp_id: 645
-->

最近要写一个库往 influxdb 中打点, 因为要被很多程序使用, 而又要创建新的进程, 为了避免引起使用方的异常, 简单深入了解了下 Python 的并发控制, 这才发现标准库真是坑. 之前没过多考虑过, 只是凭感觉在 CPU 密集的时候使用 multiprocessing, 而默认使用 threading, 其实两个还是有很多不一样的, 除了都是并发执行以外还有很大的不同. Python 中试图用 threading 和 multiprocessing 实现类似的接口来统一两方面, 结果导致更混乱了. 本文探讨几个坑.

## 在多线程环境中 fork

首先不谈 Python, 我们思考一下, 在多线程环境下如果执行 fork 会怎样? 在新的进程中, 会不会所有线程都在运行? 答案是否定的, **在 fork 之后, 只有执行 fork 的线程在运行**, 而其他线程都不会运行. 这是 POSIX 标准规定的:

> A process shall be created with a single thread. If a multi-threaded process calls fork(), the new process shall contain a replica of the calling thread and its entire address space, possibly including the states of mutexes and other resources. Consequently, to avoid errors, the child process may only execute async-signal-safe operations until such time as one of the exec functions is called. Fork handlers may be established by means of the pthread_atfork() function in order to maintain application invariants across fork() calls.

但是这时候其他线程持有的锁并不会自动转化到当前线程, 所以可能造成死锁. 关于在多线程程序中执行 fork 会造成的问题, 有好多文章有详细的讨论:

1. http://www.linuxprogrammingblog.com/threads-and-fork-think-twice-before-using-them
2. https://stackoverflow.com/questions/1073954/fork-and-existing-threads/1074663#1074663

## 在 python 的 daemon thread 中 fork 又会怎样

在 Python 中可以把线程设置为 daemon 状态, 如果一个进程中只有 daemon thread, 这个进程就会自动退出. 那么问题来了, 如果我们 daemon thread 中执行 fork 会怎样呢?

理论上来说, 既然 fork 之后只有一个线程, 而这个线程又是 daemon 线程, 那么显然这个进程应该直接退出的, 然而并不会这样, 这个进程会一直运行, 直到该线程退出. 这是因为 fork 之后, 唯一的线程自动成为了 main thread, 而 Python 中硬编码了 main thread 不是 daemon thread, 所以这个线程不会退出.

参考: 

1. https://stackoverflow.com/questions/31055960/is-it-a-python-bug-that-the-main-thread-of-a-process-created-in-a-daemon-thread

## 在新创建的进程中创建线程又会怎样

在普通进程中, 进程在所有非daemon 的线程退出之后才会推出, 但是在新创建的进程中, 不论创建的线程是 daemon thread 还是不是 daemon thread 都会在主线程退出后退出. 这是 Python 的一个 [bug](https://bugs.python.org/issue18966), 这个 bug 最早在 2013-09-08 01:20 报告出来, 而直到 2017-08-16 18:54 的 Python 3.7 才修复...

如何复现这个 bug

```py
#!/usr/bin/env python

from multiprocessing import Process
from threading import Thread
from time import sleep

def proc():
    mythread = Thread(target=run)
    mythread.start()
    print("Thread.daemon = %s" % mythread.daemon)
    sleep(4)
    #mythread.join()

def run():
    for i in range(10):
        sleep(1)
        print("Tick: %s" % i)

if __name__ == "__main__":
    p = Process(target=proc)
    p.start()
    print("Process.daemon = %s" % p.daemon)
```

下面大概说下这个 bug 的原因:

1. 普通进程会调用 `sys.exit()` 退出, 在这个函数中会调用 `thread.join()` 也就是会等待其他线程运行结束
2. 在 Python 3.4 之前, 默认只会使用 fork 创建线程, 而对于 fork 创建的线程, 会使用 `os._exit()` 退出, 也就是不会调用 `thread.join()`. 所以也就不会等待其他线程退出
3. 在 Python 3.4 中引入了对 `spawn` 系统调用的支持, 可以通过 `multiprocessing.set_start_method` 来设定创建进程使用的系统调用. 而使用 `spawn` 调用创建的进程会通过 `sys.exit()` 退出, 也就避免了这个 bug 的影响. 而使用 `fork` 创建的进程依然受到这个 bug 的影响.
4. 在 Python 3.7 中终于在添加了 `thread._shutdown` 的调用, 也就是会 join 其他的 thread.

# fork vs spawn 造成的 OS 平台差异性

我们知道, 在 `*nix` 系统中创建一个一个新的进程可以使用系统调用 `fork`, 父进程的所有资源都会被复制到子进程中, 当然是 Copy On Write 的. 如果要执行一个新的程序, 必须在 `fork` 之后调用 `exec*` 家族的系统调用, 后来 Linux 中添加了 `spawn` 系统调用, `spawn` 和 `fork` 的不同是, 他是从头创建了一个新的子程序, 而不是像 `fork` 一样复制了一份父进程. 

而在 Windows 上, 从来没有类似 `fork` 的系统调用, 只有类似 `spawn` 的系统调用, 也就是从头创建一个新的程序.

对于 Python 的影响. 在 `*nix` 操作系统上, 当使用 multiprocessing 的时候, 默认调用的是 fork, 在新的进程中所有导入的包都已经在了, 所以不会再 import 一次. 而在 Windows 系统上, 使用 multiprocessing 创建新的进程时, 所有包都会被在新进程中重新 import 一遍, 如果 import 操作是对外部系统有副作用的, 就会造成不同. 

当然如上文所述, 在 Python 3.4 之后可以选择创建进程时使用的系统调用, 如果选择了 `spawn`, 那么在各个平台上行为就是统一的了.

参考:

1. 为什么要区别 fork 和 exec: https://www.zhihu.com/question/66902460
2. fork 和 spawn 造成的有趣影响: https://zhuanlan.zhihu.com/p/39542342
2. https://stackoverflow.com/questions/38236211/why-multiprocessing-process-behave-differently-on-windows-and-linux-for-global-o


## fork 和 asyncio

多进程和 Event Loop 也可能引起一些问题, [这篇文章](http://4fish.xyz/posts/asyncio-concurrency/) 给了一个很好的例子:

假设现在有一个场景，主进程运行着一个event loop，在某个时候会fork出一个子进程，子进程再去运行一个新建的event loop：

```py
async def coro(loop):
    pid = os.fork()
    if pid != 0:  # parent
        pass
    else:  # child
        cloop = asyncio.new_event_loop()
        cloop.run_forever()

loop = asyncio.get_event_loop()
asyncio.ensure_future(coro(loop), loop=loop)
loop.run_forever()
loop.close()
```

这段代码看起来没有什么问题, 在子进程中开了一个新的 Event Loop, 然而在 Python 3.5 和以下, 在真正运行时会报错:

```py
...
cloop.run_forever()
  File "/Library/Frameworks/Python.framework/Versions/3.5/lib/python3.5/asyncio/base_events.py", line 411, in run_forever
    "Cannot run the event loop while another loop is running")
RuntimeError: Cannot run the event loop while another loop is running
```

原因就在于标准库的 Event Loop 没有考虑多进程环境, 只是使用一个 thread local 来表示当前的 loop, 在多线程条件下, 这样当然是可以的, 但是在 fork 之后, 数据结构全部都得到了复制, 因此子进程就会检查到已经有 event loop 在运行了.

在 Python 3.6 中, 这个问题得到了简单粗暴的修复, 在每个 loop 上都标记一个 pid, 检查的时候再加上 pid 验证是不是当前进程就好了.


总而言之, 尽量不要同时使用多进程和多线程, 如果非要用的话, 首先尽早创建好需要的进程, 然后在进程中再开始创建线程或者开启 Event Loop.

还有一篇文章没看, 用空了再看下吧, 是讲 multiprocessing.Pool 的坑:

1. https://codewithoutrules.com/2018/09/04/python-multiprocessing/