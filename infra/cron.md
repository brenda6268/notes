# 关机了 cron job 还会执行吗？


cron 的问题在于当系统宕机的时候可能会错过任务执行。要实现这个功能就需要记录上次任务执行时间。

如果错过了好多次，那么需要执行多少次呢？

如果上一次任务还没执行完，那么行为是未定义的。也就是并发的任务是多少。

## K8S 中的 cron


## 参考

1. https://serverfault.com/questions/52335/job-scheduling-using-crontab-what-will-happen-when-computer-is-shutdown-during
2. 