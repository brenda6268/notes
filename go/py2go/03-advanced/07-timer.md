# 定时机制

这块在 Python 中好像没有直接的对应。非要对应的话应该是和标准库的 sched 或者是嗲三方的 apscheduler 比较类似。其实主要也就是实现了 unix 系统上传统的 at 和 cron 这两个守护进程的功能。Golang 的定时机制是基于 channel 的。

timer 适用于一次性的定时，类似于 at 命令

ticker 适用于多次定时，类似于 cron 的功能呢？