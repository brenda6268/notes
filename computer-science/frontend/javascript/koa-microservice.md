# 基于 koa 的微服务

<!--
ID: f42fa3dc-ec80-4d19-8079-ec3d316ecb1e
Status: draft
Date: 2019-06-15T15:10:07
Modified: 2020-05-16T10:58:33
wp_id: 89
-->

使用 JavaScript 构建微服务时候似乎没有什么多余的选择，毕竟 grpc 都还没有合适的解决方案。所以还是采用 HTTP + JSON 的方式啦。
这里我选择了 koa 这个框架，可以很好地使用 Promise 和 async/await 的语法，再也不用写一大堆回调了，写起来还能轻松一些。

koa 作为一个微框架，简直是把 node 生态圈 isArray 都要写个库这种做法发挥到极致了。默认情况下，koa 连 POST 过来的 JSON 都不给解析出来。所以几乎任何操作都需要安装对应的库，下面总结一下必备的一些库。

解析 JSON

使用 koa-bodyparser: https://github.com/koajs/bodyparser

解析命令行参数

使用 Command Line Args: https://github.com/75lb/command-line-args/wiki/Typical-usage-example

参考文献

https://koajs.com/#request
