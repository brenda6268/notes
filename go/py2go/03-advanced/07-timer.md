Date: 2019-11-25
# 定时机制

这块在 Python 中好像没有直接的对应。非要对应的话应该是和标准库的 sched 或者是第三方的 apscheduler 比较类似。其实主要也就是实现了 unix 系统上传统的 at 和 cron 这两个守护进程的功能。Golang 的定时机制是基于 channel 的。

timer 适用于一次性的定时，类似于 at 命令. ticker 适用于多次定时，类似于 cron 的功能呢？

## Timers and tickers

Timers 定义在你在未来的某个时间想要去做一次某件事。而 Tickers 则是定期执行某一个动作。这两个有点像是 js 里面的 setTimeout 和 setInterval 两个函数。

time.NewTicker(500 * time.Millisecond)
time.NewTimer(500 * time.Millisecond)

time.After
time.Tick
time.Sleep

## Time 中的 Channel