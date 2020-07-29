# 如何爬取 js 动态渲染的网页

<!--
ID: 4689b6dc-8efe-4af3-a2b1-3b81f8489f39
Status: draft
Date: 2017-08-16T03:22:00
Modified: 2020-05-16T11:49:34
wp_id: 447
-->

爬虫难免要爬一些动态网页, 使用诸如 Qtwebkit 或者 phantomjs 之类的渲染工具总有无法渲染的问题, 最好的方法直接使用Google Chrome 渲染网页. 前一段时间 Google Chrome 支持了 headless 模式, 也就是可以在没有显卡, 没有显示器的服务器上原生运行, 更令人惊喜的是还提供了一个node的库来操作. 这个库叫做puppeteer, 顾名思义, 操作木偶的人, 哈哈, 挺有创意的名字.

把 Chrome 作为浏览器来用还是太重量了，如果能有一个单独的 binary 或者 lib 渲染页面就好了。有人就做了这样一个东西——[libchromecontent][1]。

作为一个大型的工程，chrome的源码是非常模块化的，其中 Chrome 中用于渲染的模块叫做 content 模块，而libchromecontent就是把这个模块构建成了一个 lib，这样我们就可以在自己的程序中调用chrome来做离线渲染。


[1]: https://electronjs.org/blog/electron-internals-building-chromium-as-a-library