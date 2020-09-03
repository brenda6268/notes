# Python 和 Go 异步对比

<!--
ID: 24a89217-020c-4870-9adb-dd00b7d11b7e
Status: draft
Date: 2019-10-18T18:08:59
Modified: 2020-05-16T10:49:36
wp_id: 777
-->

Python 3.6 中终于引入了 `async` 和 `await` 关键字，算是在语言层次上支持了 `coroutine`，
`coroutine` 又被称为用户级线程，也就是可以再一个系统线程中模拟多个线程构成的并发操作，
对于有 GIL 的 Python 来说，不失为多了一种选择，使用 `asyncio` 来访问网页可以这样写：

```python
import asyncio as aio
import aiohttp

async def fetch(url):
    return await aiohttp.get(url)

async def main():
    page = await fetch("http://toutiao.com")
    print(page)

if __name__ == "__main__":
    loop = asyncio.get_event_loop()
    loop.run_until_complete(main())
```

注意其中我们使用 `async def` 定义了一个 `coroutine function`，并且在其中调用（await）了
另一个 `coroutine function`。在 Python 中只有在使用 `async def` 定义的函数中才能使用
`await`。

如果我们需要下载多个网址呢？

```python
async def main():
    urls = ["http://toutiao.com", "http://baidu.com", "http://sina.com.cn"]
    for url in urls:
        page = await fetch("http://toutiao.com")
        print(page)

if __name__ == "__main__":
    loop = asyncio.get_event_loop()
    loop.run_until_complete(main())
```

在 Python 中，函数还有 `coroutine` 函数之间是严格区分的，也就是说下面的代码是无效的，
并不能达到我们想要的效果：

```python
async def main():
    page = fetch("http://toutiao.com")  # 注意这里少了 await 关键字
    print(page)

if __name__ == "__main__":
    loop = asyncio.get_event_loop()
    loop.run_until_complete(main())
```

也就是说，对于 `async` 的函数我们只能通过 `await` 来调用，而 `await` 语句又只能出现在
`async` 函数中，也就是说一旦使用了一个 `async` 函数，这种 `coroutine`
的模式就感染了整个应用。这一点是非常蛋疼的，也就是说当然最终 `async` 函数需要使用
`loop.run_until_complete` 来驱动。

另外一个蛋疼的地方就是，在 `coroutine` 中，不能够调用常规的阻塞函数，如果调用了阻塞性的函数，
那么整个线程就阻塞了，也就是所有的 `coroutine` 就阻塞住了，那么什么样的函数是阻塞性的呢？
所有涉及到 IO 的函数几乎都是。也就是说 urllib、redis、mysql 这些库都是阻塞性的函数，甚至 `open`
函数都是阻塞性的，也就是一旦使用了 `async`，你连写文件都不可以了。

所以使用 `async` 特性的话，必须把几乎所有的轮子都发明一遍，所以就有了 aioredis、aiomysql、aiohttp
等等一大批库，然而因为 `async` 还比较新，所以这些库还都很不完善，在 GitHub 上的 star
都比对应的同步版本少一个数量级。


然而上面的代码并没有体现出 `coroutine` 的优势来，每次循环都会等待到网页下载完，
如果我们想要并发地下载网页呢？

```
async def main(loop):
    urls = ["http://toutiao.com", "http://baidu.com", "http://sina.com.cn"]
    tasks = []
    for url in urls:
        task = loop.ensure_future(fetch("http://toutiao.com"))
        tasks.append(task)
    results = asyncio.gather(tasks)
    for result in results:
        print(result)

if __name__ == "__main__":
    loop = asyncio.get_event_loop()
    loop.run_until_complete(main(loop))
```

可以看到上面的代码中我们首先生成了对应的下载任务，然后使用 `async.gather`
来收集下载的结果。


最近闲暇时间看了看 `Go` 语言相关的东西。发现 `Go` 原生的并发模型非常好用。正好
Python 在 3.6 版本也加入了 `async/await` 两个关键字，算是对携程提供了语言级别的支持，
然而两者之间的差别还是非常大的。


# 和系统线程之间的映射关系

# 生态系统的对比

总的来看，Go 语言因为从设计之初就是强调对并发的支持
