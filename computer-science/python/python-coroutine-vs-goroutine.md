# Python coroutine 以及和 Goroutine 的对比


wp_id: 681
Status: publish
Date: 2018-04-29 05:44:00
Modified: 2020-05-16 11:37:10


# Python 中的 coroutine

Python 3.5 中终于引入了 `async` 和 `await` 关键字，算是在语言层次上支持了 coroutine。

## coroutine 基础

coroutine 又被称为用户级线程，也就是可以在一个系统线程中模拟多个线程构成的并发操作，对于有 GIL 的 Python 来说，反正线程也是费了，不失为多了一种选择，使用 asyncio 来爬取网页可以这样写：

首先，`pip install pulsar lxml`。pulsar 是一个异步版的 http 库。

```py
import asyncio
from pulsar.apps import http

client = http.HttpClient()

async def fetch(url):
    r = await client.get(url)
    return r.content.decode("utf-8")

async def main():
    page = await fetch("http://toutiao.com")
    print(page)

if __name__ == "__main__":
    loop = asyncio.get_event_loop()
    loop.run_until_complete(main())
```

注意其中我们使用 `async def` 定义了一个 `coroutine function`，并且在其中调用（await）了另一个 coroutine function。在 Python 中只有在使用 async def 定义的函数上下文中才能使用 await。

如果我们需要下载多个网址呢？

## coroutine 并发

```
import asyncio
import lxml.html
from pulsar.apps import http


client = http.HttpClient()

async def fetch(url):
    r = await client.get(url)
    return r.content.decode("utf-8")

def get_title(page):
    doc = lxml.html.fromstring(page)
    return doc.xpath("//title/text()")[0]

async def main():
    urls = ["https://www.toutiao.com", "https://www.douban.com", "https://www.sina.com.cn"]
    futures = []
    for url in urls:
        future = asyncio.ensure_future(fetch(url))
        futures.append(future)
    pages = await asyncio.gather(*futures)
    for url, page in zip(urls, pages):
        print(url, get_title(page))

if __name__ == "__main__":
    loop = asyncio.get_event_loop()
    loop.run_until_complete(main())
```

在上面的例子中，我们在 for 循环使用 `asyncio.ensure_future` 创建了三个 Future 对象。Future 对象指的是可以在未来（future）的某个时间获得结果的一个对象。然后我们使用 `asyncio.gather` 来同时 `await` 了这三个 Future。在我们 await 的时候，可以认为这三个 future 是"并发"执行的。如果你了解 JavaScript 的话，可以看出来 Future 就相当于 JS 中的 Promise 对象。注意这里的并发指的是 IO 上可以并发加速，如果从 CPU 上考虑的话，因为都是在一个线程中，也就没有性能提升的，所以说协程特别适合于 IO 密集的应用。

不过，对于初学者来说，经常会直接 await 每一个协程，导致实际上没有任何并发。比如下面的代码就是错误的：

```
async def main():
    urls = ["https://www.toutiao.com", "https://www.douban.com", "https://www.sina.com.cn"]
    for url in urls:
        page = await fetch(url)
        print(page)
```

上面这种错误有人称作 async/await hell，可以参考这篇文章：[如何避免async/await地狱](https://www.zcfy.cc/article/how-to-escape-async-await-hell)

## 协程的调度

我们知道线程是内核进行抢占式的调度的，这样就确保了每个线程都有执行的机会。而 coroutine 运行在同一个线程中，由语言的运行时中的 EventLoop（事件循环）来进行调度。和大多数语言一样，在 Python 中，协程的调度是非抢占式的，也就是说一个协程必须主动让出执行机会，其他协程才有机会运行。让出执行的关键字就是 `await`。也就是说一个协程如果阻塞了，持续不让出 CPU，那么整个线程就卡住了，没有任何并发。比如下面的例子：

```
% cat time_sleep.py

import asyncio
import time

async def do_work():
    time.sleep(1)

async def main():
    for _ in range(3)s:
        future = asyncio.ensure_future(do_work())
        futures.append(future)
    await asyncio.gather(*futures)

if __name__ == "__main__":
    loop = asyncio.get_event_loop()
    loop.run_until_complete(main())

% time python time_sleep.py
python no_concurrent.py  0.13s user 0.03s system 5% cpu 3.173 total
```

虽然我们使用了 asyncio.gather 来并发执行，但是依然可以看到执行时间是 3.173s。因为 time.sleep 是一个阻塞性的操作，只能顺序执行，所以整个运行时间就是 3s。如果要修复这个程序可以改成这样：

```
% cat aio_sleep.py

...
async def do_work():
    await asyncio.sleep(1)
...

% time python aio_sleep.py
python aio_sleep.py  0.13s user 0.03s system 13% cpu 1.166 total
```

使用 asyncio.sleep 替换了阻塞的 time.sleep，执行时间是 1.166s。这样暴露两个问题：

1. Python 整个异步编程生态的问题，之前标准库和各种第三方库的阻塞性函数都不能用了，requests 不能用了，redis.py 不能用了，甚至 open 函数都不能用了。所以 Python 的最大问题不是不好用，而是生态环境不好。
2. 一旦开始采用 async 函数，那么你整个程序都必须是 async 的，不然总会有阻塞的地方，也就是说 async 具有传染性。

这两点结合在一起导致想要写一个完全异步的 Python 程序还是有一定挑战的。

# Goroutine

最近闲暇时间看了看 Go 语言相关的东西。发现 Go 原生的并发模型非常好用。Go 中的 goroutine 类似于其他语言中的 corouine，最重要的是 goroutine 是 go 与生俱来的特性，所以几乎所有库都是可以直接用的，避免了 Python 中需要把所有库重写一遍的问题。

用 Go 来重写一下并发下载：

```
package main

import (
	"fmt"
	"io/ioutil"
	"log"
	"net/http"
)

func fetch(url string, bodies chan []byte) {
	resp, err := http.Get(url)
	if err != nil {
		log.Fatalf("error %s", err)
	}
	defer resp.Body.Close()
	body, _ := ioutil.ReadAll(resp.Body)
	bodies <- body
}

func main() {
	urls := []string{
		"https://www.toutiao.com",
                "https://www.douban.com",
                "https://www.sina.com.cn",
	}
	bodies := make(chan []byte)
	for _, url := range urls {
		go fetch(url, bodies)
	}
	for i := 0; i < len(urls); i++ {
		fmt.Println(string(<-bodies)[:100])
		fmt.Println("--------------------")
	}
	close(bodies)
}
```


## Goroutine 的调度

Goroutine 中不需要显式使用 await 交出控制权，但是 Go 也不会严格按照时间片去调度 goroutine，而是会在可能阻塞的地方插入调度。Goroutine 的调度可以看做是半抢占式的。

## 和系统线程之间的映射关系

Python 中的协程是严格的 1:N 关系，也就是一个线程对应了多个协程。而 Go 中是 M:N 的关系，也就是 N 个协程会映射分配到 M 个线程上，这样带来了两点好处：

1. CPU 密集的应用使用 goroutine 也会获得加速；
2. 即使有少量阻塞的操作，也只会阻塞某个 worker 线程，而不会把整个程序阻塞。

总之，在高并发方面，Go 语言的确有不少优势。