# lua coroutine

<!--
ID: 64ec9a49-cd51-4030-a1b0-c6eace9cb22e
Status: publish
Date: 2017-05-30T13:43:00
Modified: 2017-05-30T13:43:00
wp_id: 695
-->

Lua 的协程是非对称的协程也就是 resume 和 yeild 相当于调用和返回

Python 的协程是对称的协程, 相当于 goto.

Lua中携程相关的函数都放在coroutine包中
coroutine.create(function)  返回一个thread类型的值表示一个协程，并且处于suspend状态。
resume(co, params…) 执行一个协程，并且能够传递参数，返回运行的状态的函数yield返回的结果