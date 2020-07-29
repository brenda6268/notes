# 爬虫利器 Chrome Headless 和 Puppeteer 最佳实践

<!--
ID: 5428a891-e3a3-4ca6-9d83-a68fdc7f52e2
Status: publish
Date: 2018-06-04T19:04:00
Modified: 2020-05-16T11:39:55
wp_id: 444
-->

> 翻译自：https://docs.browserless.io/blog/2018/06/04/puppeteer-best-practices.html

browserless 已经运行了200万次的 chrome headless 请求，下面是他们总结出来的最佳实践：

# 一、不要使用无头浏览器

![](https://ws2.sinaimg.cn/large/006tNc79gy1fs056p3uvaj319w0fcacy.jpg)

无头 Chrome 占用的大量资源

无论如何，只要可以的话，不要运行无头浏览器。特别是千万别在你跑其他应用的服务器上跑。无头浏览器的行为难以预测，对资源占用非常多，就像是 Rick and Morty 里面的 Meseeks（美国动画片《瑞克和莫蒂》中，召唤出了过多的 Meseeks 导致出了大问题）。几乎所有你想通过浏览器用的事情（比如说运行 JavaScript）都可以使用简单的 Linux 工具来实现。`Cheerio` 和其他的库提供了优雅的 Node API 来实现 HTTP 请求和采集等需求。

比如，你可以像这样获取一个页面并抽取内容：

```
import cheerio from "cheerio";
import fetch from "node-fetch";

async function getPrice(url) {
    const res = await fetch(url);
    const html = await res.test();
    const $ = cheerio.load(html);
    return $("buy-now.price").text();
}

getPrice("https://my-cool-website.com/");
```

显然这肯定不能覆盖所有的方面，如果你正在读这篇文章的话，你可能需要一个无头浏览器，所以接着看吧。

# 二、不要在不需要的时候运行无头浏览器

我们遇到过好多客户尝试在不使用的时候也保持浏览器开着，这样他们就总能够直接连上浏览器。尽管这样能够有效地加快连接速度，但是最终会在几个小时内变糟。很大程度上是因为浏览器总会尝试缓存并且慢慢地吃掉内存。只要你不是在活跃地使用浏览器，就关掉它。

```
import puppeteer from "puppeteer";

async function run() {
    const browser = await puppeteer.launch();
    const page = await browser.newPage();

    await page.goto("https://www.example.com/");

    // More stuff ...page.click() page.type()

    browser.close(); // <- Always do this!
}
```

在 browserless，我们会给每个会话设置一个定时器，而且在WebSocket链接关闭的时候关闭浏览器。但是如果你使用自己独立的浏览器的话，记得一定要关闭浏览器，否则你很可能在半夜还要陷入恶心的调试中。

# 三、 `page.evaluate` 是你的好朋友

Puppeteer 有一些很酷的语法糖，比如可以保存 DOM 选择器等等东西到 Node 运行时中。尽管这很方便，但是当有脚本在变换 DOM 节点的时候很可能坑你一把。尽管看起来有一些 hacky，但是最好还是在浏览器中运行浏览器这边的工作。也就是说使用 `page.evaluate` 来操作。


比如，不要使用下面这种方法（使用了三个 async 动作）：

```
const $anchor = await page.$("a.buy-now");
const link = await $anchor.getProperty("href");
await $anchor.click();

return link;
```

这样做，使用了一个 async 动作：

```
await page.evaluate(() => {
    const $anchor = document.querySelector("a.buy-now");
    const text = $anchor.href;
    $anchor.click();
});
```

另外的好处是这样做是可移植的：也就是说你可以在浏览器中运行这个代码来测试下是不是需要重写你的 node 代码。当然，能用调试器调试的时候还是用调试器来缩短开发时间。

最重要的规则就是数一下你使用的 await 的数量，如果超过 1 了，那么说明你最好把代码写在 page.evaluate 中。原因在于，所有的 async 函数都必须在 Node 和 浏览器直接传来传去，也就是需要不停地 json 序列化和反序列化。尽管这些解析成本也不是很高（有 WebSocket 支持），但是总还是要花费时间的。

# 四、并行化浏览器，而不是页面

上面我们已经说过尽量不要使用浏览器，而且只在需要的时候才打开浏览器，下面的这条最佳实践是——在一个浏览器中只使用一个会话。尽管通过页面来并行化可能会给你省下一些时间，如果一个页面崩溃了，可能会把整个浏览器都带翻车。而且，每个页面都不能保证是完全干净的（cookies 和存储可能会互相渗透）。


不要这样：

```
import puppeteer from "puppeteer";

// Launch one browser and capture the promise
const launch = puppeteer.launch();

const runJob = async (url) {
    // Re-use the browser here
    const browser = await launch;
    const page = await browser.newPage();
    await page.goto(url);
    const title = await page.title();

    browser.close();

    return title;
};
```

要这样：

```
import puppeteer from "puppeteer";

const runJob = async (url) {
    // Launch a clean browser for every "job"
    const browser = puppeteer.launch();
    const page = await browser.newPage();
    await page.goto(url);
    const title = await page.title();

    browser.close();

    return title;
};
```

每一个新的浏览器实例都会得到一个干净的 `--user-data-dir` （除非你手工设定）。也就是说会是一个完全新的会话。如果 Chrome 崩溃了，也不会把其他的会话一起干掉。

# 五、队列和限制并发

browserless 的一个核心功能是无缝限制并行和使用队列。也就是说消费程序可以直接使用 puppeteer.connect 而不需要自己实现一个队列。这避免了大量的问题，大部分是太多的 Chrome 实例杀掉了你的应用的可用资源。

最好也最简单的方法是使用 browserless 提供的镜像：

```
# Pull in Puppeteer@1.4.0 support
$ docker pull browserless/chrome:release-puppeteer-1.4.0
$ docker run -e "MAX_CONCURRENT_SESSIONS=10" browserless/chrome:release-puppeteer-1.4.0
```

上面限制了并发连接数到10，还可以使用`MAX_QUEUE_LENGTH`来配置队列的长度。总体来说，**每1GB内存可以并行运行10个请求**。CPU 有时候会占用过多，但是总的来说瓶颈还是在内存上。

# 六、不要忘记 `page.waitForNavigation`

如果点击了链接之后，需要使用 page.waitForNavigation 来等待页面加载。

下面这个不行
```
await page.goto("https://example.com");
await page.click("a");
const title = await page.title();
console.log(title);
```

这个可以
```
await page.goto("https://example.com");
page.click("a");
await page.waitForNavigation();
const title = await page.title();
console.log(title);
```

# 七、使用 docker 来管理 Chrome

Chrome 除了浏览之外，还会有好多的莫名其妙的线程，所以最好使用 docker 来管理
