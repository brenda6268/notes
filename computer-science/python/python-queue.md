# Python 中的 queue 模块

<!--
ID: 9f96455b-8040-4b1a-b083-57039158f962
Status: publish
Date: 2018-06-22T09:20:00
Modified: 2020-05-16T11:13:11
wp_id: 647
-->

在Python中多进程或者多线程之间通信可以使用队列，标准库中实现了一个线程安全的库 queue.Queue，和进程安全的库 multiprocessing.Queue

There are 3 kind of queues: `Queue LifoQueue HeapQueue

```
q = Queue(size)

get(block=True) return a object
get_nowait()
put(item, block=True) put a object 

qsize()
empty()
full()

task_done() # indicate one item process finished raise ValueError
join() # wait until all item processed

Queue.Empty
Queue.Full
```

How to iterate a queue?

by using `iter(q, None)`, note that you have to put a sentinel value manually

Queue vs multiprocessing.Queue

despite their similar api, their implementation is completely different

http://stackoverflow.com/questions/925100


如果在一个线程使用了异步代码，那么所有的操作都必须使用异步操作，但是并不是所有的操作都需要或者能够使用异步操作。

在异步线程和同步线程之间分享数据需要使用一个共用的queue

如果需要把异步操作分布式不熟使用，在异步的事件循环之间分享数据也需要使用一个queue