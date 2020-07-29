# 为什么不使用 scrapy，而是从头编写爬虫系统？

<!--
ID: 792aedfd-789e-4db3-bb37-0bf02aa5640b
Status: publish
Date: 2019-12-12T15:58:05
Modified: 2020-05-16T10:46:27
wp_id: 838
-->

时隔一年了，来回答下自己提的问题。个人不喜欢 scrapy 原因一言以蔽之：**高不成，低不就，弊大于利**。
总的来说，需要使用代码来爬一些数据的大概分为两类人：

1. 非程序员，需要爬一些数据来做毕业设计、市场调研等等，他们可能连 Python 都不是很熟；
2. 程序员，需要设计大规模、分布式、高稳定性的爬虫系统，对他们来说，语言都无所谓的，更别说用不用框架了。

# 为什么不适合初学者？

对于初学者来说用不上 scrapy 的原因很简单：

1. scrapy 太复杂了；
2. scrapy 采用异步模式带来的高性能和在反爬面前实际上没有任何卵用；
3. scrapy 项目冗余的代码结构对初学者完全是过度设计。

对于一个任何一个已经入门的程序员来说，Python 都算不上一个很复杂的语言，除了不用大括号可能让一些人感觉有些不适应之外，基本上看看语法上手就能写了。但是恰恰是因为我们都是老司机了，所以不能体会到使用一门编程语言对于外行来说可能『比登天还难』。如果不用 scrapy，可能我只需要这样：

```python
# 以下代码未经测试，可能有些许 bug
import requests

def main():
    for i in range(100):
        rsp = requests.get(f"http://www.example.com/{i}.html")
        with open("example-{i}.html", "w") as f:
            print(f"saving {i}")
            f.write(rsp.text)

if __name__ == "__main__":
    main()
```

就写好了一个简单的爬虫。而使用 scrapy 呢，大概需要这样吧：

```python
# 以下代码未经测试，可能有些许 bug
import scrapy

class QuotesSpider(scrapy.Spider):
    name = "quotes"

    def start_requests(self):
        for i in range(100):
            yield scrapy.Request(url=f"http://www.example.com/{i}.html", callback=self.parse)

    def parse(self, response):
        page = response.url.split("/")[-2]
        with open("example-%s.html" % page, "wb") as f:
            f.write(response.body)
        self.log("Save file %s" % page)
```

先不说代码增长了不少，初学者会问到这些问题：“**什么是 class？为什么类还有参数？啊，什么是继承？yield 又是什么鬼，那个 scrapy.Request 又是啥？**”这些都是心智负担。那么 scrapy 这些心智负担又给我们带来了什么好处呢？好处是性能和相对来说比较统一的代码结构，但是其实这两个对初学者并没有什么卵用啊……

scrapy 采用了 twisted 作为基础，实现了基于协程的高并发。协程看着虽然挺好，但是对于非程序员来说，他们往往就想对一个站点做定向爬取，你说你蹭蹭蹭把并发涨上去了，无非两个后果：

1. 对方承受不住你爬，挂掉了，你拿不到数据；
2. 对方把你封禁了，疯狂弹验证码，你拿不到数据。

所以，对于非程序员做的一些定向爬取来说，速度是没有意义的，甚至往往是越慢越好。scrapy out。

那么相对来说比较统一的代码结构有什么卵用吗？答案依然是没有。我们知道在 web 开发领域基本上稍微有点规模的项目还是要使用框架的，哪怕是 flask 这种微框架。在 web 开发领域，有经典的 MVC 模式，我们需要 路由、模板、ORM 这些固定的组件，所以主循环是由框架和 web server 来控制的。而对于爬虫呢？其实没有什么固定的模式，scrapy 也仅仅是定义了几个钩子函数而已，反倒我们没有了主循环，在编写一些特定逻辑的时候非常受到掣肘。

另外 scrapy 提供的一些其他功能，比如说抓取的队列或者去重等等，个人感觉有过度封装的味道，而且也都是在内存里，在反爬导致爬虫挂掉这种故障面前没有什么卵用，不二次开发的话还是得重爬。对于小白来说，也不用想 redis 这些幺蛾子，其实可以用 Google 最开始使用的一个很简单的方法，就把每个新抓到的 url 写到一个 txt 文件就好了，爬虫每次重启的时候首先读取这个 txt 就好了，网上乱七八糟的教程大多是炫技的。

# 为什么不适合大型爬虫系统？

前面说到，scrapy 基于 twisted。twisted 是 Python 的一个异步框架，最大的问题就是太难懂了，而且现在官方应支持了 asyncio，所以 twisted 的未来堪忧，甚至比起 twisted 来说，我更愿意投入时间到 curio 这样新兴的有潜力的异步框架。第二点就是 scrapy 控制了主循环，所以二次开发相当于只能在他的框架内做一些修修补补，并且还要兼容 twisted。

既然要开发大型爬虫系统，那么其中很重要的一部分就是爬虫的调度了。一种比较简单的模式是 scheduler 作为 master，全局调度。另一种模式没有 master，所有的爬虫 worker 都是对等的。在实际生产中显然是第一种用的更多。

显然 scheduler 这部分是不能再用一个爬虫框架来实现的，连主循环都没有怎么写逻辑呢？我们可能还要实现增量爬取，或者消费业务方发来的爬取请求等各种业务，这块显然是在 scheduler 里面的，那么这个爬虫系统无非是 scheduler 分发任务给各个 worker 来抓取。worker 还可以使用 scrapy 实现，但是呢，这个 worker 其实已经弱化为一层薄薄的 downloader 了，那我要他干嘛呢？scrapy 的核心逻辑也不过是个深度或者广度优先的遍历而已，少一个依赖不好么……

总结一下，爬虫的工作量要么在反爬，要么在调度等业务逻辑，本身只是一个 `requests.get` 而已，scrapy 提供的种种抽象对于初学者太复杂，大型系统又用不上，所以个人**不推荐使用包括但不限于 scrapy 在内的所有爬虫框架**。

建议所有认为学习框架会使自己变强的人读读：Stop learning  frameworks  和 评论，中文翻译

以上仅代表个人观点，欢迎讨论，不要人身攻击。