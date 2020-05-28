# 无头浏览器和 Puppeteer 的一些最佳实践


wp_id: 80
Status: publish
Date: 2019-06-15 15:07:08
Modified: 2020-05-16 10:58:53


<!-- wp:paragraph -->
<p>
在做爬虫的时候，总会遇到一些动态网页，他们的内容是 Ajax 加载甚至是加密的。虽然说对于一些大站来说，分析接口是值得的，但是对于众多的小网站来说，一个一个分析接口太繁琐了，这时候直接使用浏览器渲染就简单得多了。
</p>
<!-- /wp:paragraph -->

<!-- wp:paragraph -->
<p>
以往比较流行的是 selenium + phantomjs 的组合，不过在自从 Google 官方推出了谷歌浏览器的无头模式和 
puppeteer 这个库以后，稳定性和易用度都大幅得到了提升，本文也主要探讨谷歌浏览器和 puppeteer。另外 puppeteer 
也有第三方的 Python 移植，叫做 pyppeteer，不过这个库目前来看不太稳定（个人使用体验）。另外 pyppeteer 这个库使用了 
asyncio，如果你的爬虫使用的是普通的同步语法，那么也还是不方便调用 pyppeteer 这个库，个人建议还是使用官方的 node 版 
puppeteer，如果需要在 Python 中调用，直接调用 node 然后渲染就可以了。
</p>
<!-- /wp:paragraph -->

<!-- wp:paragraph -->
<p>
browserless 是一家在提供云端浏览器渲染服务的公司，本文翻译了他们关于如何提升无头浏览器稳定性和性能的两篇文章并添加了本人在使用过程中遇到的一些问题和经验总结。browserless 的两篇原文链接在最后。
</p>
<!-- /wp:paragraph -->

<!-- wp:heading -->
<h2 id="不要使用无头浏览器">不要使用无头浏览器</h2>
<!-- /wp:heading -->

<!-- wp:paragraph -->
<p>
Headless Chrome 
占用大量的资源。无论如何，只要可以的话，不要运行无头浏览器。特别是千万别在你跑其他应用的服务器上跑。无头浏览器的行为难以预测，对资源占用非常多，就像是
 Rick and Morty 里面的 Meseeks（美国动画片《瑞克和莫蒂》中，召唤出了过多的 Meseeks 
导致出了大问题）。几乎所有你想通过浏览器用的事情（比如说运行 JavaScript）都可以使用简单的 Linux 工具来实现。Cheerio 
和其他的库提供了优雅的 Node <abbr title="">API</abbr> 来实现 HTTP 请求和采集等需求。
</p>
<!-- /wp:paragraph -->

<!-- wp:paragraph -->
<p>
比如，你可以像这样获取一个页面并抽取内容：
</p>
<!-- /wp:paragraph -->

<!-- wp:preformatted -->
<pre class="wp-block-preformatted">import cheerio from 'cheerio';
import fetch from 'node-fetch';
&nbsp;
async function getPrice(url) {
    const res = await fetch(url);
    const html = await res.test();
    const $ = cheerio.load(html);
    return $('buy-now.price').text();
}
&nbsp;
getPrice('https://my-cool-website.com/');</pre>
<!-- /wp:preformatted -->

<!-- wp:paragraph -->
<p>
显然这肯定不能覆盖所有的方面，如果你正在读这篇文章的话，你可能需要一个无头浏览器，所以接着看吧。
</p>
<!-- /wp:paragraph -->

<!-- wp:heading -->
<h2 id="使用_docker_来管理_chrome">使用 docker 来管理 Chrome</h2>
<!-- /wp:heading -->

<!-- wp:paragraph -->
<p>
在 Linux 上跑 Chrome 的话，很可能连字体渲染都没有，还要安装好多的依赖。Chrome 
除了浏览之外，还会有好多的莫名其妙的线程，所以最好使用 docker 来管理。建议使用 browserless/chrome 
这个镜像，这个镜像是 browserless 这家专门做 Chrome 渲染的公司在生产环境中使用的镜像。关于这个镜像的文档在这里：<a href="https://docs.browserless.io/docs/docker.html" target="_blank" rel="noreferrer noopener">https://docs.browserless.io/docs/docker.html</a> （英文）
</p>
<!-- /wp:paragraph -->

<!-- wp:preformatted -->
<pre class="wp-block-preformatted">docker run -p 8080:3000 --restart always -d --name browserless browserless/chrome</pre>
<!-- /wp:preformatted -->

<!-- wp:preformatted -->
<pre class="wp-block-preformatted">const puppeteer = require('puppeteer');
&nbsp;
    // 从 puppeteer.launch() 改成如下
    const browser = await puppeteer.connect({ browserWSEndpoint: 'ws://localhost:3000' });
    const page = await browser.newPage();
&nbsp;
    await page.goto('http://www.example.com/');
    const screenshot = await page.screenshot();
&nbsp;
    await browser.disconnect();</pre>
<!-- /wp:preformatted -->

<!-- wp:heading -->
<h2 id="保持_chrome_在运行状态">保持 Chrome 在运行状态</h2>
<!-- /wp:heading -->

<!-- wp:paragraph -->
<p>
当负载很高的情况下，Chrome 启动可能会花上好几秒钟。对大多数情况来说，我们还是希望避免这个启动时间。所以，最好的办法就是预先启动好 Chrome，然后让他在后台等着我们调用。
</p>
<!-- /wp:paragraph -->

<!-- wp:paragraph -->
<p>
如果使用 browserless/chrome 这个镜像的话，直接指定 PREBOOT_CHROME=true 就好了。下面的命令会直接启动 
10 个浏览器，如果你指定 KEEP_ALIVE，那么在你断开链接(pp.disconnect)的时候也不会关闭浏览器，而只是把相关页面关闭掉。
</p>
<!-- /wp:paragraph -->

<!-- wp:preformatted -->
<pre class="wp-block-preformatted">docker run -d -p 3000:3000 \
    -e DEBUG=browserless* \
    -e PREBOOT_CHROME=true -e MAX_CONCURRENT_SESSIONS=10 -e KEEP_ALIVE=true
    --name browserless browserless/chrome:latest</pre>
<!-- /wp:preformatted -->

<!-- wp:heading -->
<h2 id="pageevaluate_是你的好朋友">page.evaluate 是你的好朋友</h2>
<!-- /wp:heading -->

<!-- wp:paragraph -->
<p>
Puppeteer 有一些很酷的语法糖，比如可以保存 DOM 选择器等等东西到 Node 运行时中。尽管这很方便，但是当有脚本在变换 DOM 
节点的时候很可能坑你一把。尽管看起来有一些 hacky，但是最好还是在浏览器中运行浏览器这边的工作。也就是说使用 page.evaluate 
来操作。
</p>
<!-- /wp:paragraph -->

<!-- wp:paragraph -->
<p>
比如，不要使用下面这种方法（使用了三个 async 动作）：
</p>
<!-- /wp:paragraph -->

<!-- wp:preformatted -->
<pre class="wp-block-preformatted">const $anchor = await page.$('a.buy-now');
const link = await $anchor.getProperty('href');
await $anchor.click();
&nbsp;
return link;</pre>
<!-- /wp:preformatted -->

<!-- wp:paragraph -->
<p>
这样做，使用了一个 async 动作：
</p>
<!-- /wp:paragraph -->

<!-- wp:preformatted -->
<pre class="wp-block-preformatted">await page.evaluate(() => {
    const $anchor = document.querySelector('a.buy-now');
    const text = $anchor.href;
    $anchor.click();
});</pre>
<!-- /wp:preformatted -->

<!-- wp:paragraph -->
<p>
另外的好处是这样做是可移植的：也就是说你可以在浏览器中运行这个代码来测试下是不是需要重写你的 node 代码。当然，能用调试器调试的时候还是用调试器来缩短开发时间。
</p>
<!-- /wp:paragraph -->

<!-- wp:paragraph -->
<p>
最重要的规则就是数一下你使用的 await 的数量，如果超过 1 了，那么说明你最好把代码写在 page.evaluate 中。原因在于，所有的
 async 函数都必须在 Node 和 浏览器直接传来传去，也就是需要不停地 json 序列化和反序列化。尽管这些解析成本也不是很高（有 
WebSocket 支持），但是总还是要花费时间的。
</p>
<!-- /wp:paragraph -->

<!-- wp:paragraph -->
<p>
除此之外，还要牢记使用 puppeteer 的时候是由两个 JS 的执行环境的，别把他们搞混了。在执行 page.evaluate 的时候，函数会先被序列化成字符串，传递给浏览器的 JS 运行时，然后再执行。比如说下面这个错误。
</p>
<!-- /wp:paragraph -->

<!-- wp:preformatted -->
<pre class="wp-block-preformatted">const anchor = 'a';
&nbsp;
await page.goto('https://example.com/');
&nbsp;
// 这里是错的，因为浏览器中访问不到 anchor 这个变量
const clicked = await page.evaluate(() => document.querySelector(anchor).click());</pre>
<!-- /wp:preformatted -->

<!-- wp:paragraph -->
<p>
修改方法也很简单，把这个参数作为变量传递给 page.evaluate 就可以了。
</p>
<!-- /wp:paragraph -->

<!-- wp:preformatted -->
<pre class="wp-block-preformatted">const anchor = 'a';
&nbsp;
await page.goto('https://example.com/');
&nbsp;
// Here we add a `selector` arg and pass in the reference in `evaluate`
const clicked = await page.evaluate((selector) => document.querySelector(selector).click(), anchor);</pre>
<!-- /wp:preformatted -->

<!-- wp:heading -->
<h2 id="队列和限制并发">队列和限制并发</h2>
<!-- /wp:heading -->

<!-- wp:paragraph -->
<p>
browserless 的镜像一个核心功能是无缝限制并行和使用队列。也就是说消费程序可以直接使用 puppeteer.connect 而不需要自己实现一个队列。这避免了大量的问题，大部分是太多的 Chrome 实例杀掉了你的应用的可用资源。
</p>
<!-- /wp:paragraph -->

<!-- wp:preformatted -->
<pre class="wp-block-preformatted">$ docker run -e "MAX_CONCURRENT_SESSIONS=10" browserless/chrome</pre>
<!-- /wp:preformatted -->

<!-- wp:paragraph -->
<p>
上面限制了并发连接数到10，还可以使用MAX_QUEUE_LENGTH来配置队列的长度。总体来说，每1GB内存可以并行运行10个请求。CPU 有时候会占用过多，但是总的来说瓶颈还是在内存上。
</p>
<!-- /wp:paragraph -->

<!-- wp:heading -->
<h2 id="不要忘记_pagewaitfornavigation">不要忘记 page.waitForNavigation</h2>
<!-- /wp:heading -->

<!-- wp:paragraph -->
<p>
如果点击了链接之后，需要使用 page.waitForNavigation 来等待页面加载。
</p>
<!-- /wp:paragraph -->

<!-- wp:paragraph -->
<p>
下面这个不行
</p>
<!-- /wp:paragraph -->

<!-- wp:preformatted -->
<pre class="wp-block-preformatted">await page.goto('https://example.com');
await page.click('a');
const title = await page.title();
console.log(title);</pre>
<!-- /wp:preformatted -->

<!-- wp:paragraph -->
<p>
这个可以
</p>
<!-- /wp:paragraph -->

<!-- wp:preformatted -->
<pre class="wp-block-preformatted">await page.goto('https://example.com');
page.click('a');
await page.waitForNavigation();
const title = await page.title();
console.log(title);</pre>
<!-- /wp:preformatted -->

<!-- wp:heading -->
<h2 id="屏蔽广告内容">屏蔽广告内容</h2>
<!-- /wp:heading -->

<!-- wp:paragraph -->
<p>
browserless 家的镜像还有一个功能就是提供了屏蔽广告的功能。屏蔽广告可以是你的流量降低，同时提升加载速度。
</p>
<!-- /wp:paragraph -->

<!-- wp:paragraph -->
<p>
只需要在连接的时候加上 blockAds 参数就可以了。
</p>
<!-- /wp:paragraph -->

<!-- wp:heading -->
<h2 id="启动的时候指定_--user-data-dir">启动的时候指定 --user-data-dir</h2>
<!-- /wp:heading -->

<!-- wp:paragraph -->
<p>
Chrome 最好的一点就是它支持你指定一个用户的数据文件夹。通过指定用户数据文件夹，每次打开的时候都可以使用上次的缓存。这样可以大大加快网站的访问速度。
</p>
<!-- /wp:paragraph -->

<!-- wp:preformatted -->
<pre class="wp-block-preformatted">const browser = await pp.launch({
    args: ["--user-data-dir=/var/data/session-xxx"]
})</pre>
<!-- /wp:preformatted -->

<!-- wp:paragraph -->
<p>
不过需要注意的是，这样的话会保存上次访问时候的 cookie，这个不一定是你想要的效果。
</p>
<!-- /wp:paragraph -->