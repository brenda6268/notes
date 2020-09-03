# C 语言中的 errno

<!--
ID: d82f6c0f-4f55-4722-8bdf-bf29252ffa70
Status: draft
Date: 2017-05-29T15:04:00
Modified: 2020-05-16T12:09:27
wp_id: 409
-->

在 c 的最初定义中 errno 是一个全局变量，但是在实际的实现中 errno 是一个线程本地的变量 threadlocal

通常的使用模式是：

函数返回 0 表示成功，返回非 0 表示失败，同时设置 errno 变量
