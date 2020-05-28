# curio


wp_id: 665
Status: publish
Date: 2017-07-07 14:56:00
Modified: 2017-07-07 14:56:00


curio 是一个神奇的 Python 库，它完全面向 Python 3.5 增加的 async/await 语法，从低层就没有使用 callback 的语法，因此相比 asyncio 来说设计更简单，API 更优雅，性能却更好。

## 一个例子
curio 的文档给了一个很好的例子，下面总结一下这个例子。这个例子模拟了孩子在玩Minecraft，而家长在催促孩子该出发了的情景。

```py
import curio

async def countdonw(n):
    while n > 0:
        print('T-minus', n)
        await cuiro.sleep(1)  # 在异步编程中，不能使用同步代码中的 time.sleep
        n -= 1
        
start_evt = cruio.Event()

async def frined(name):
    print('你好, 我叫', name)
    print('开始玩 Minecraft')
    try:
        await curio.sleep(1000)
    except curio.CancelledError:
        print(name, '回家了')
        raise

def fib(n):
    if n <= 2:
        return 1
    else:
        return fib(n-1) + fib(n-2)

async def kid():
    while True:
        try:
            print('可以玩了吗?')
            await curio.timeout_after(1, start_evt.wait)  # 等待一秒
            break
        except curio.TaskTimeout:
            print('啊啊啊')
    print('在 Minecraft 中造建筑')
    async with curio.TaskGroup() as f:
        await f.spawn(friend, 'Max')  # 生成 friend 协程
        await f.spawn(friend, 'Lilikan')
        await f.spawn(friend, 'Thomas')
        try:
            total = 0:
            for i in range(10):
                total += await curio.run_in_process(fib, n)   # 把计算密集型的任务交给另一个进程
                await curio.run_in_thread(time.sleep, n)  # 会阻塞的，放到其他线程
            await curio.sleep(1000)  # 模拟延迟
        except curio.CancelledError:
            print('好的，保存中')  # 如果被取消了，做好善后工作
            raise  # 需要重新跑出异常
    
async def parent():
    kid_task = await curio.spawn(kid)  # 打开 kid 协程，这里并不会等待kid 运行完毕
    await curio.sleep(5)
    
    print('去玩吧')
    await start_evt.set()
    await curio.sleep(5)
    
    print('该出发了')
    count_task = await curio.spawn(countdown, 10)  # 开始倒计时协程
    await count_task.join()  # 使用 join 等待一个协程完成
    
    print('真的要走了')
    try:
        await curio.timeout_after(10, kid_task.join)  # 等待 kid 协程运行完毕，最多十秒
    except curio.TaksTimeout:
        print('警告过你了')
        await kid_task.cancel()
    print('出发了')
    
if __name__ == '__main__':
    curio.run(parent， with_monitor=True)  # 开始执行
    # with_monitor 可以在另一个窗口实时观察有多少协程在运行
    # python3 -m curio.monitor
```

## curio monitor 的使用

### 打开 curio
```
$ python -m cuiro.monitor
Curio Monitor: 4 tasks running
Type help for commands
curio> 
```

### 使用 ps 列出当前正在执行的任务
```
curio > ps
Task   State        Cycles     Timeout Task
------ ------------ ---------- ------- --------------------------------------------------
1      FUTURE_WAIT  1          None    Monitor.monitor_task
2      READ_WAIT    1          None    Kernel._run_coro.<locals>._kernel_task
3      TASK_JOIN    3          None    parent
4      TIME_SLEEP   1          None    kid
curio >
```

### 使用 where 查看每个协程的调用栈
```
curio > w 3
Stack for Task(id=3, name='parent', <coroutine object parent at 0x1024796d0>, state='TASK_JOIN') (most recent call last):
  File "hello.py", line 23, in parent
    await kid_task.join()
  File "/Users/beazley/Desktop/Projects/curio/curio/task.py", line 106, in join
    await self.wait()
  File "/Users/beazley/Desktop/Projects/curio/curio/task.py", line 117, in wait
    await _scheduler_wait(self.joining, 'TASK_JOIN')
  File "/Users/beazley/Desktop/Projects/curio/curio/traps.py", line 104, in _scheduler_wait
    yield (_trap_sched_wait, sched, state)

curio > w 4
Stack for Task(id=4, name='kid', <coroutine object kid at 0x102479990>, state='TIME_SLEEP') (most recent call last):
  File "hello.py", line 12, in kid
    await curio.sleep(1000)
  File "/Users/beazley/Desktop/Projects/curio/curio/task.py", line 440, in sleep
    return await _sleep(seconds, False)
  File "/Users/beazley/Desktop/Projects/curio/curio/traps.py", line 80, in _sleep
    return (yield (_trap_sleep, clock, absolute))

curio >
```

### 使用cancel取消一个协程

```
curio > cancel 4
Cancelling task 4
*** Connection closed by remote host ***
```

## curio 的API

### coroutine 与 kernel

使用`async def`来创建一个新的coroutine. 每个coroutine不能够单独执行, 而是需要通过一个`kernel`来执行(相当于asyncio中的loop). 当然一般情况下, 我们不会主动去生成一个kernel, 而是调用curio.run来交给curio 隐式执行. 

```
async def hello(name):
    print('hello', name) 

run(hello, 'Guido')    # Preferred
run(hello('Guido'))    # Ok
```

### tasks

前面说到, 一个coroutine需要交给curio来运行, 但是实际上 curio 运行的并不是这个coroutine, 而是包含了这个coroutine 的 task. task 可以认为是一个线程, 而coroutine则可以看成是target函数. 和线程一样, task 也分为了daemon的和非daemon的. 当所有非daemon的task执行完毕之后, kernel就会自动退出. 这个和线程是类似的, 所有的非daemon的线程执行完毕之后, 整个进程就会退出. 而我们通过 curio.run 创建的那个task实际上就相当于是我们在多线程程序中的主线程了.

#### spawn

```py
await spawn(corofunc, *args, daemon=False)
```

在多线程编程中, 我们通过使用 `t = Theaad(target=func); t.start()` 来开始执行新的线程. 然而, 在curio中,你不能通过 `t = Task(target=func); t.start()` 来创建新的 task. 而应改通过 `t = await spawn(corofunc)` 来创建并开始执行新的coroutine.

#### Task join

可以使用 `r = await task.join()` 来等待task运行结束, 并获得返回值. 也可以使用 `await task.wait()` 但是不会返回值, 必须之后再使用 task.result 获得返回值
```py
v = await Task.join()  # 返回返回值

# or 

await task.wait()
v = task.result  # 如果在task结束之前访问, 会raise RuntimeError
```

#### Task Group

curio 支持使用 taskgroup 来管理一组任务, `class TaskGroup(tasks=(), *, wait=all, name=None)`.

在创建task group的时候就可以把已经生成的task放入group中, 或者随后使用 task_group.spawn/add_task 来向group 中添加task.

```
await TaskGroup.spawn(corofunc, *args, ignore_result=False)
# 生成一个task, 并放入到该task group中

await TaskGroup.add_task(coro)
# 添加已有的 task 到该 task group 中
# 以上两个方法分别添加 corofunc 和 task 到当前 group 中

await TaskGroup.join(*, wait=all)
# 等待所有的task运行结束

await TaskGroup.cancel_remaining()
# 取消所有还在运行的task
```

##### 用在with语句和迭代器中

task group 可以用在with语句中, 这样在with块退出的时候就会隐式地调用 task_group.join().

```
async with TaskGroup() as g:
    t1 = await g.spawn(func1)
    t2 = await g.spawn(func2)
    t3 = await g.spawn(func3)

# all tasks done here
print('t1 got', t1.result)
print('t2 got', t2.result)
print('t3 got', t3.result)
```

task group 还可以用作迭代器, 其中包含了所有 task.result

```
async with TaskGroup() as g:
    t1 = await g.spawn(func1)
    t2 = await g.spawn(func2)
    t3 = await g.spawn(func3)
    async for task in g:
        print(task, 'completed.', task.result)
```

#### task local storage

`class Local` 类似于threading.Local, 但是随着一个新的 context local storage PEP 的到来, 这个功能会被废弃掉

### time

使用 curio.sleep 而不是 time.sleep, 以为整个协程都是单线程的.

### workers
如果需要运行一些CPU密集的任务或者是一些可能block住的任务, 可以使用workers.

#### 有用的函数
```
await curio.workers.run_in_process(callable, *args)
```

如果取消对应的coroutine的话, 相应的进程会收到SIGTERM而立即停止执行

```
await curio.workers.run_in_thread(callable, *args)
```

如果取消对应coroutine的话, 相应的线程并不会停止执行, 而是进入一种类似 zombie 的状态, 知道运行结束

```
await curio.workers.block_in_thread(callable, *args)
```

类似 run_in_thread, 但是对用同一个callable, 同时只有一个线程在执行.

```
curio.workers.MAX_WORKER_THREADS  # 同一个kernel能使用的最大的线程数, 默认64
curio.workers.MAX_WORKER_PROCESSES  # 同一个kernel能使用的最大进程数, 默认 CPU 数量
```

### 文件

读取文件可能是个很耗时的工作, 不光是读写磁盘, 如果你的文件是在一个网络文件系统上, 那么将会更加耗时. 如果在协程中发生这种操作, 整个协程kernel 都会被block住.

curio.file 提供了一些供异步读取文件的机制.

```
curio.file.aopen(*args, **kwargs)
```

需要注意的是, 这个函数只能用在 Async Context Manager 中, 而不能直接 `f = await aopen()`

```
async with aopen(filename) as:
    async for line in f:
        print(line)
```

### 原语

curio 提供了 `Event`, `Lock`, `RLock`, `Semephore`, `BoundedSemaphore`, `Condition`等

### queue

正如标准库提供了 queue 模块用于多线程之间通信一样, curio 提供了 curio.queue 来实现task 之间的通信. 用法和queue 模块基本上是一样的, 除了一些方法变成了 coroutine function, 而不是普通的函数了.

### 异步线程

如果你需要执行很多的同步操作, 但是还是想要能够和 curio 来交互, 可以使用异步线程. 在异步线程内, 可以使用`AWAIT`函数来实现`await`关键字的操作, 可以使用普通的`with` 和 `for`来实现使用了`async with`. 也就是实现了不用在coroutine内部而使用 coroutine 的操作.

另外值得注意的一点是, 如果把定义的async thread当做同步版本的线程来运行, 那么 `AWIAT` 就是一个 no-op, 也就是说可以直接把他当做同步线程来用.