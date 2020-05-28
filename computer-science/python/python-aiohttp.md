# Python 高性能请求库 aiohttp 的基本用法


wp_id: 689
Status: publish
Date: 2018-10-13 17:05:00
Modified: 2020-05-16 11:25:10


aiohttp 是 Python 异步编程最常用的一个 web 请求库了, 依托于 asyncio, 性能非常吓人. 下面列举几个常见的用法:

# 最基础: 并发下载网页

```py
import aiohttp
import asyncio

async def fetch(session, url):
    async with session.get(url) as response:
        return await response.text()

async def main():
    urls = [
            "http://python.org",
            "https://google.com",
            "http://yifei.me"
        ]
    tasks = []
    async with aiohttp.ClientSession() as session:
        for url in urls:
            tasks.append(fetch(session, url))
        htmls = await asyncio.gather(*tasks)
        for html in htmls:
            print(html[:100])

if __name__ == "__main__":
    loop = asyncio.get_event_loop()
    loop.run_until_complete(main())
```