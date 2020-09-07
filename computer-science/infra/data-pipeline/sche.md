# sche - 一种人类能够看懂的 cron 语法

<!--
ID: 0652dcaa-4d96-45b5-aafd-3540981f5549
Status: publish
Date: 2020-09-01T22:30:41
Modified: 2020-09-01T22:30:41
wp_id: 1887
-->

在 Linux 系统上，我们一般使用 `cron` 来设置定时任务，然而 cron 的语法还是有些佶屈聱牙的，几乎每次要修改的时候都需要查一下文档才知道什么意思，以至于有 crontab.guru 这种网站专门来解释 cron 的语法。

![](https://tva1.sinaimg.cn/large/007S8ZIlly1gibjy5v5iuj30zk0kmq4t.jpg)

想象一下，能不能有一种让人一眼就能看懂的语法来表达周期性的调度操作呢？比如说这样：

```
every 10 minutes         , curl apple.com
every hour               , echo 'time to take some coffee'
every day at 10:30       , eat
every 5 to 10 minutes    , firefox http://news.ycombinator.com
every monday             , say 'Good week'
every wednesday at 13:15 , rm -rf /
every minute at :17      , ping apple.com
every 90 minutes         , echo 'time to stand up'
```

这样的配置文件是不是很容易懂呢？如果要写成 crontab 的格式大概是这样的：

```
*/10 * * * *    curl apple.com
0 * * * *       echo 'time to take some coffee'
30 10 * * *     eat
*/7 * * * *     firefox http://news.ycombinator.com  # 实际上是不对的，因为 cron 没法随机
0 0 * * MON     say 'Good week'
15 13 * * WED   rm -rf /
# every minute at :17  无法实现，因为 cron 中没有秒
0 0-21/3 * * *  echo 'time to stand up'  # 需要两条命令来完成每隔 90 分钟的操作
30 1-22/3 * * * echo 'time to stand up'
```

可以很明显看出，cron 的语法可读性还是差一些的，关键是维护起来更是像读天书一样。幸运的是，我在周末刚刚做了一个小工具，虽然还比较粗糙，但是也已经可以解析上面这种可读性比较好的语法。下面简单介绍一下如何使用：

## 介绍 `sche`

sche 是一个 Python 程序，所以可以使用 pip 直接安装：

```
pip install sche
```

安装之后，就会得到一个 `sche` 命令，帮助文件如下：

```
-> % sche -h
usage: sche [-h] [-f FILE] [-t]

A simple command like `cron`, but more human friendly.

The default configuration file is /etc/schetab, syntax goes like:

    # (optional) set time zone first
    timezone = +0800

    # line starts with # is a comment
    every 60 minutes, echo "wubba lubba dub dub"

    # backup database every day at midnight
    every day at 00:00, mysqldump -u backup

    # redirect logs so you can see them
    every minute, do_some_magic >> /some/output/file 2>&1

optional arguments:
  -h, --help            show this help message and exit
  -f FILE, --file FILE  configuration file to use
  -t, --test            test configuration and exit
```

我们只需要把需要执行的命令放到 `/etc/schetab` 文件下就好了，这里显然是在致敬 `/etc/crontab`。比如说：

```
-> % cat /etc/schetab
timzone = +0800
every 5 seconds, echo "wubba lubba dub dub"
every 10 seconds, date

-> % sche
wubba lubba dub dub
Tue Sep  1 22:15:01 CST 2020
wubba lubba dub dub
wubba lubba dub dub
Tue Sep  1 22:15:11 CST 2020
wubba lubba dub dub
wubba lubba dub dub
Tue Sep  1 22:15:21 CST 2020
wubba lubba dub dub
```

如何让 sche 像 cron 一样作为一个守护进程呢？秉承 Unix 一个命令只做一件事的哲学，sche 本身显然是不提供这个功能的，可以使用 `systemd` 实现，几行配置写个 unit 文件就搞定了。

## sche 的来源

sche 是 schedule -- 另一个 Python 库的一个 fork, schedule 支持这样的 Python 语句：

```py
schedule.every(10).minutes.do(job)
schedule.every().hour.do(job)
schedule.every().day.at("10:30").do(job)
schedule.every().monday.do(job)
schedule.every().wednesday.at("13:15").do(job)
schedule.every().minute.at(":17").do(job)
```

然而我的需求是把时间配置独立出来，能够像 cron 一样存到一个文本文件里，而不是写成 Python 代码，于是提了一个 PR，增加了 `when` 这个方法来解析表达式。同时我还强烈需求时区支持，然而原版的 schedule 也不支持。所以就创建了一个 fork.

```py
sche.when("every wednesday at 13:15").do(job)
sche.timezone("+0800").every().day.at("00:00").do(job)
```

最后，原生的 cron 命令实际上（至少我）已经极少用了，然而 crontab 的语法流传还是非常广的，在所有需要定时任务的地方，几乎都能看到 cron 的身影，比如说 Kubernetes job 等等，如果能够使用一种让正常人能随时看懂的语法，感觉还是很有意义的。


## 参考

1. https://schedule.readthedocs.io/en/stable/
2. https://crontab.guru/
3. https://stackoverflow.com/q/247626/1061155

