# 学习写一个编译器

<!--
ID: ab4c32ae-f9c3-4132-a700-048f98254736
Status: draft
Date: 2017-12-18T07:14:00
Modified: 2020-05-16T11:28:55
wp_id: 512
-->

## 为什么？

有一个很好的比喻：不懂编译器写程序就好比没有学过人体解剖学就去画人像一样，能当让是能，但是核心上总有些不对的地方

每个成功的项目都有很多的语言构成，拿一个简单的 Python Web 项目来说，我们可能需要 Python、yml、jinja、ini 等等多种语言（不一定是完备的变成语言）。总有一天你对发现现有的语言并不能特别好得满足你的特定需求的时候，而这时候你就需要一个编译器了。

设计一门语言还是一个很好的联系

![](http://www.craftinginterpreters.com/image/a-map-of-the-territory/mountain.png)

## 编译的步骤

![](http://www.craftinginterpreters.com/image/a-map-of-the-territory/string.png)

1. Scanning，也就是词法分析（Lexical Analysis）
2. Parsing