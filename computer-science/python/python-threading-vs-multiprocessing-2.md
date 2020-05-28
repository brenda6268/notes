# Python 的多线程和多进程


wp_id: 685
Status: publish
Date: 2017-11-08 19:30:00
Modified: 2020-05-16 11:51:35


# 高层次多线程

使用 threading 模块，threading.Thread

```py
import threading

def worker(i):
    """thread worker function"""
    print "Worker {}".format(i)

threads = []
for i in range(5):
    t = threading.Thread(name="worker", target=worker, args=(i,))
    threads.append(t)
    t.start()
```
	
by default, it does not start running

    t.start  # start executing the thread
    t.is_alive
    t.join   # wait for a thread, daemon thread can't be joined
	
直接子类化 Thread 是不推荐的，因为这样会使代码和线程耦合在一起。

Each Thread has its own stack, so when a child thread throws a exception, the main thread will not catch it

http://stackoverflow.com/questions/2829329/catch-a-threads-exception-in-the-caller-thread-in-python


## Daemon 线程

默认情况下，主线程等待所有子线程的执行。设定为 Daemon 线程后，主线程继续执行，并不等待，但当主线程退出时会杀掉所有子线程。如果想要使用Ctrl-C, 必须设定为daemon

使用 t.daemon = True 设定为 Daemon 线程

使用 `t.join(timeout)` 等待子线程完成，如果 timeout 之内没有完成，继续执行

`threading.enumerate()` 返回所有活动的线程

`threading.current_thread()` 返回当前进程

## 长时间运行的守护进程

头条的代码是如何处理的：

1. 主线程等待
2. 所有的 worker 线程 daemon 化
3. 使用 systemd 管理进程

关于 coroutine，首先，他们是线程，用户级线程，也就是说虽然他们的代价比较小，但是如果递归调用，很可能会创建大量的协程。在线程中，我们显然不能创建数量过大的线程，因此，也不能无限地创造过多的协程。

## 线程池和进程池

* `multiprocessing.Pool` 进程池，只能接受 marshalable 作为 worker
* `multiprocessing.ThreadPool` 线程池，同样受到了 GIL 的影响。

用法如下:

```py
multiporcessing.Pool.map(fn, iterable)
```

线程池的例子

```py
from multiprocessing.pool import ThreadPool
 
def square_number(n):
    return n ** 2
 
# function to be mapped over
def calculate_parallel(numbers, threads=2):
    pool = ThreadPool(threads)
    results = pool.map(square_number, numbers)
    pool.close()  # NOTE close before join
    pool.join()
    return results
 
if __name__ == "__main__":
    numbers = [1, 2, 3, 4, 5]
    squared_numbers = calculate_parallel(numbers, 4)
    for n in squared_numbers:
        print(n)
```
 
使用pool的一个陷阱是不太好debug, 爆出的异常往往看不清问题, 需要使用单线程调试之后再去使用

## `concurrent.futures`



## 参考

1. https://medium.com/python-pandemonium/asyncio-coroutine-patterns-beyond-await-a6121486656f
2. http://lucumr.pocoo.org/2016/10/30/i-dont-understand-asyncio/
3. https://medium.com/@yeraydiazdiaz/asyncio-coroutine-patterns-errors-and-cancellation-3bb422e961ff
4. https://pymotw.com/2/threading/
5. https://news.ycombinator.com/item?id=9793466