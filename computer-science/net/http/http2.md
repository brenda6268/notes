# http 2 明显改进的地方


<!--
ID: 9ee99755-8f92-425e-b771-18701a478c62
Status: draft
Date: 2017-11-13T20:49:00
Modified: 2020-05-16T11:53:10
wp_id: 581
-->


1. 全双工
2. 强制 https
...


# The RFC

http/2 的基本单元是frame, 比如说 headers 和 data frame. http/2还实现了全双工, 流控制等. 而且在http/2中不只是客户端向服务器请求, 服务器还可以向客户端推送响应. http/2 还做了头部压缩.

http/2 必须通过http/1.1 upgrade来得到, 所以先去学习一下http/1.1吧