# Golang 中需要掌握的包


ID: 780
Status: draft
Date: 2019-10-19 13:50:02
Modified: 2020-05-16 10:49:12


内置的包需要掌握的：

bufio, bytes, flag, fmt, http, io, json, os, sort, sync, time, math/rand

colorgo

fasthttp

http://fuxiaohei.me/2016/9/24/go-and-fasthttp-server.html

net/html

https://godoc.org/golang.org/x/net/html


设计模式： https://github.com/tmrts/go-patterns

调试

似乎可以用 gdb，甚至用 rr。（gdb是万能的？）

https://github.com/derekparker/delve/blob/master/Documentation/usage/dlv.md

日期

golang的时间处理实在太烂了，不如使用第三方库。

https://github.com/araddon/dateparse


爬虫

http://benjamincongdon.me/blog/2018/03/01/Scraping-the-Web-in-Golang-with-Colly-and-Goquery/

https://www.devdungeon.com/content/web-scraping-go

https://github.com/sourcegraph/webloop

https://github.com/DeanThompson/zhihu-go


xpath 解析

https://github.com/antchfx/htmlquery

关于包管理

https://codeengineered.com/blog/2015/go-1.5-vendor-handling/
https://www.calhoun.io/exploring-vgo/
https://blog.golang.org/versioning-proposal
http://blog.adron.me/articles/want-organized-golang/
https://research.swtch.com/vgo-tour

