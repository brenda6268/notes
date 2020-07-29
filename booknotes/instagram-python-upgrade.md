# 阅读 instagram 的 python 升级文章

<!--
ID: 5da98de2-1d4a-4a20-9adc-6d8686b550c2
Status: publish
Date: 2017-08-16T17:03:00
Modified: 2020-05-16T11:49:45
wp_id: 353
-->

在 Instagram 的用户数迅速增长的过程中，性能问题还是出现了：服务器数量的增长率已经慢慢的超过了用户增长率。

为此，他们决定跳过 Python 2 中哪些蹩脚的异步 IO 实现 （可怜的 gevent、tornado、twisted 众），直接升级到 Python 3，去探索标准库中的 asyncio 模块所能带来的可能性。

在 Instagram，进行 Python 3 的迁移需要必须满足两个前提条件：

- 不停机，不能有任何的服务因此不可用
- 不能影响产品新特性的开发
