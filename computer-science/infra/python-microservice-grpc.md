# 基于 gRPC 的 Python 微服务框架探索


<!--
ID: 08876b74-dc21-42bc-a6e3-94bb65df98ce
Status: draft
Date: 2018-09-28T22:42:00
Modified: 2020-05-16T11:24:28
wp_id: 557
-->


最近要搭一个系统，用 gRPC 搭建了一个服务，发现有很大部分重复的代码，可以用模板来生成。正好刚看到 reddit ad 系统的一篇文章讲如何用 go 搭建微服务系统的，很受启发，遂有此文。

Go 语言的微服务框架有很多，用户较多的有 gomicro 和 gokit。而 Python 方面则没有发现合适的框架，之前在头条工作的时候倒是有一个基于 Thrift 的 Python 框架——PIE。通过研究这两个框架的文档，发现 PIE 框架大概和

微服务都需要什么

grpc python 中如何使用 ProcessPoolExecutor

https://github.com/grpc/grpc/issues/16001#issuecomment-470185940