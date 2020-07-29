# 物联网相关

<!--
ID: 2119718d-3e42-4aa0-b63b-3c1ba423c996
Status: draft
Date: 2018-04-19T02:17:00
Modified: 2020-05-16T11:36:30
wp_id: 443
-->

早在研一的时候，树莓派刚发布，我就买了一个，然而终究没有多少时间把玩，又或许是能力不够，没法玩转，总之最后在未来花园上又把它卖了。然而我始终是看好物联网的发展的，最近有些时间，决定再抽少许精力研究下。一则是自己兴趣使然，二则也有助于更加了解硬件底层实现，弥补一下自己的计算机组成原理知识。

显然我并不打算使用 C 来去写一些传统的单片机程序。目前而言，可以使用 micropython 和 emgo 两个工具分别来编写 python 和 go 程序运行在某些特定的卡片上。至于其他的 nodemcu 之类的我并不是很感兴趣。

Golang 似乎比 Python 、Lua 或者 Node.js 更适合 IoT，毕竟 Go 更接近硬件，也更接近 C 语言的语法。可以尝试把 Golang 移植到 Pyboard

# emgo

相对于 micropython 对于线程的不完整支持来说，emgo完全支持 go 语言的 channel，也就是说我们有了很好的并发性。虽然大多数时候单线程的逻辑就够了，但是当你需要用到多线程的时候再去切换语言就很费劲了。

了解到 emgo，是从这篇[文章](https://ziutek.github.io/2018/03/30/go_on_very_small_hardware.html)。

# 单片机的一些概念

avr是一款单片机，Arduino是一个基于avr的开发平台。Esp8266是国内厂家乐鑫出品的一个集成了wifi和mcu的开发版，可以刷lua python等语言

这个问题很好 https://www.zhihu.com/question/26421237

Esp8266 的基础介绍，包括什么是 AT 命令等等 www.shaoguoji.cn/2017/01/15/ESP8266-usage/

Esp8266 还支持 Arduino 的开发：https://github.com/esp8266/Arduino