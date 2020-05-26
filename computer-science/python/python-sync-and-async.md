# Python中同步代码和异步代码和谐相处


ID: 635
Status: draft
Date: 2018-05-30 12:08:00
Modified: 2020-05-16 11:39:25


Python 3.5  中引入了`async`函数和异步执行能力。比如aiohttp性能非常强大，远远超过了requests。然而让人不爽的是，异步函数只能在异步函数中调用，也就是说如果你引入了一个异步函数，那么这个函数就会由内而外感染整个程序，无法使用同步阻塞的函数。基本上所有的网络和文件操作是阻塞性质的，这就限制了异步函数的适用范围，那么可以让这两种函数和谐相处么？本文介绍一种方法。

本文使用的是 Python 3.7

# 错误方案

首先，我们先来看*错误*的代码：

```
import asyncio
import aiohttp

session = aiohttp.ClientSession()

async def download(url):
    async with session.get(url) as resp:
        return await resp.content()

async def batch_download(urls):
    futures = []
    for url in urls:
        task = asyncio.create_task(download(url))
        futures.append(task)
    return await asyncio.gather(futures)

def main():
    urls = [&#039;https://www.baidu.com&#039;,
            &#039;https://www.weibo.com&#039;,
            &#039;https://www.toutiao.com&#039;
           ]
    pages = await batch_download(urls)  # 错误

if __name__ == &#039;__main__&#039;:
    main()
```

上面的代码本意是使用 asyncio 并发下载，但是实际上会直接出发 syntax error，因为在普通函数中不能使用 await 语句。


# 微小的改进

可以使用 asyncio.run() 函数来运行异步程序

```
def main():
    urls = [&#039;https://www.baidu.com&#039;,
            &#039;https://www.weibo.com&#039;,
            &#039;https://www.toutiao.com&#039;
           ]
    pages = asyncio.run(batch_download(urls))
```

但是这个代码还是有问题，如果我们的程序需要多次下载，那么需要多次调用 async.run。而每次调用都会生成一个