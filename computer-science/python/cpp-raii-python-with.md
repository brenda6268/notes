# C++ 的 RAII 与 Python 的 with 语句

<!--
ID: 61cbf17a-c91e-4933-8d93-1847aef1b2a6
Status: draft
Date: 2017-11-20T18:25:00
Modified: 2020-05-16T11:56:04
wp_id: 678
-->

在 C++ 中我们可以使用 RAII 来自动管理资源，避免忘记释放资源而造成内存泄漏。

RAII 是 Resource acquisition as initialisation的 缩写，也就是使用初始化来代表资源获取。具体来说就是在构造函数中获取资源，在析构函数中释放资源。同时利用 C++ 变量在离开块的时候会被自动释放的原理，实现资源的自动管理。

一个典型的 RAII 的代码如下。

```
class Handle {};

```

Python 中的 with 语句也用来做资源管理