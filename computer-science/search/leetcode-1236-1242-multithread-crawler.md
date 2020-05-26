# LeetCode 1236/1242 设计一个(多线程)爬虫解法


ID: 818
Status: publish
Date: 2019-11-03 15:59:30
Modified: 2020-05-16 10:47:24


# 单线程题目 LeetCode-1236

具体题目就不说了，直接去 LeetCode 上看就好了。1236 要求使用单线程即可，考察的主要是图的遍历。只要注意到对于新发现的节点需要考虑是否已经访问过就好了。在实际生产中，肯定也是要用广度优先，深度优先基本就会陷进一个网站出不来了。

```python
from urllib.parse import urlsplit

class Solution:
    def crawl(self, startUrl: str, htmlParser: &#039;HtmlParser&#039;) -&gt; List[str]:
        domain = urlsplit(startUrl).netloc
        q = [startUrl]
        visited = set([startUrl])
        while q:
            newUrls = []
            for url in q:
                urls = htmlParser.getUrls(url)
                for newUrl in urls:
                    u = urlsplit(newUrl)
                    if u.netloc != domain:
                        continue
                    if newUrl in visited:
                        continue
                    visited.add(newUrl)
                    newUrls.append(newUrl)
            q = newUrls
        return list(visited)
```
# 多线程题目 LeetCode-1242

1242 题要求使用多线程来实现。在现实生活中，爬虫作为一个 IO 密集型的任务，使用多线程是一项必须的优化。

在上述的单线程版本中，我们使用了 visited 这个数组来存放已经访问过的节点，如果我们采用多线程的话，并且在每个线程中并发判断某个 URL 是否被访问过，那么势必需要给这个变量加一个锁。而我们知道，在多线程程序中，加锁往往造成性能损失最大，最容易引起潜在的 bug。那么有没有一种办法可以不用显式加锁呢？

其实也很简单，我们只要把需要**把并发访问的部分放到一个线程里**就好了。这个想法是最近阅读 *The Go Programming Language* 得到的启发。全部代码如下：

```python
import threading
import queue
from urllib.parse import urlsplit

class Solution:
    def crawl(self, startUrl: str, htmlParser: &#039;HtmlParser&#039;) -&gt; List[str]:
        domain = urlsplit(startUrl).netloc
        requestQueue = queue.Queue()
        resultQueue = queue.Queue()
        requestQueue.put(startUrl)
        for _ in range(5):
            t = threading.Thread(target=self._crawl, 
                args=(domain, htmlParser, requestQueue, resultQueue))
            t.daemon = True
            t.start()
        running = 1
        visited = set([startUrl])
        while running &gt; 0:
            urls = resultQueue.get()
            for url in urls:
                if url in visited:
                    continue
                visited.add(url)
                requestQueue.put(url)
                running += 1
            running -= 1
        return list(visited)

    def _crawl(self, domain, htmlParser, requestQueue, resultQueue):
        while True:
            url = requestQueue.get()
            urls = htmlParser.getUrls(url)
            newUrls = []
            for url in urls:
                u = urlsplit(url)
                if u.netloc == domain:
                    newUrls.append(url)
            resultQueue.put(newUrls)
```

在上面的代码中，我们开启了 5 个线程并发请求，每个 worker 线程都做同样的事情：

1. 从 requestQueue 中读取一个待访问的 url；
2. 执行一个很耗时的网络请求：`htmlParser.getUrls`；
3. 然后把获取到的新的 url 处理后放到 resultQueue 中。

而在主线程中：

1. 从 resultQueue 中读取一个访问的结果
2. 判断每个 URL 是否已经被访问过
3. 并分发到 requestQueue 中。

我们可以看到在上述的过程中并没有显式使用锁（当然 queue 本身是带锁的）。原因就在于，我们把对于需要并发访问的结构限制在了一个线程中。

当然如果可以用锁的话，也可以在每个 worker 线程中计数。而这种情况下，为了使用 running > 0 这个条件，一定要首先在发现新的 url 的时候 running++，在处理完整个页面之后再 running--。

