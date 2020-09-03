# Linux 内存与进程管理（ps/top/kill...）

<!--
ID: 5c899af6-2bd0-4aba-a90d-e2bd07a10aed
Status: publish
Date: 2017-11-15T04:55:00
Modified: 2020-05-16T11:53:59
wp_id: 603
-->

# ps 命令

比较有用的选项有

```
-e 显示所有的进程
-f 显示 uid, pid, ppid, cpu, starttime, tty, cpu usage, command
-j 显示 user, pid, ppid, pgid, sess, jobc, state, tt, time, command。个人更喜欢 -j 一点
-l 显示 uid, pid, ppid, flags, cpu, pri, nice, vsz=SZ, rss, wchan, state=S, paddr=ADDR, tty, time, and command=CMD.
-v 显示 pid, state, time, sl, re, pagein, vsz, rss, lim, tsiz, %cpu, %mem, and command

-L 显示能够排序的关键字（mac）
L 显示能排序的关键字（Linux）
-o/-O 指定显示的列，-o 只显示指定的列，-O 有默认的几列，等价于：-o pid,format,state,tname,time,command

-S 把所有已经退出的进程的时间计算到父进程上（mac）
S 把所有已经退出的进程的时间计算到父进程上（Linux）
-u 按照 uid/username 过滤
-p/--pid 限制 pid
-g/--gid 限制 gid
-C 按照命令过滤
--ppid 按照 ppid 过滤
--ssid 按照 ssid 过滤
--tid 按照 tty 过滤

-E 显示环境变量
-H/--forest 按照进程树显示

--sort 按照某一列排序

-ww 不要限制显示的输出宽度
```

## 例子

1. 使用 ps 显示占用内存最多的进程

```
% ps -eo pid,ppid,cmd,%mem,%cpu --sort=-%mem | head
```

2. 显示所有进程树

```
% ps -ejH
```

## 其他相关命令

pstree 查看进程树

pgrep process_name 按照名字查找进程 pid


# top 命令

定时刷新系统的进程状态的监控程序。mac 上的默认排序是 pid，Linux 上是 %CPU。mac 上的 top 程序和 Linux 上非常不一样。

- top 教程：https://linoxide.com/linux-command/linux-top-command-examples-screenshots/
- htop 教程：http://www.cnblogs.com/lizhenghn/p/3728610.html
- atop 教程：http://www.cnblogs.com/bangerlee/archive/2011/12/23/2294090.html

## atop

atop 用来分析机器在历史上的负载情况。通过 crontab 固定时间采样，组合起来形成一个 atop 日志文件，可以使用 atop -r XXX 对日志文件查看。

atop 每天以一个 `/var/log/atop/atop_YYYYMMDD` 的形式生成一个日志文件。

常用命令

* b mm:ss 到指定时间
* t 查看后十秒
* T 查看前十秒
* m 按照内存排序
* C 按照 CPU 排序
* c 查看详细命令

# kill 命令系列

kill -s SIGNAL pid

或者 pkill xxx，不要使用 killall ，[use pkill over killall](https://unix.stackexchange.com/questions/91527/whats-the-difference-between-pkill-and-killall)

# 调整 nice 值

使用 nice 和 renice。nice 的范围是 -20 ~ 19，nice 值越低，优先级越高。

nice -n 10 COMMAND  # 以 10 为初始 nice 值启动命令
renice 10 -p pid

# jobs 命令相关

`jobs` list all jobs

`command &`  put job in the background

`fg N` to put it in the foreground

`bg N` to put it in the background

`ctrl-z` to put a job to sleep

`kill %n` to kill job number n


# lsof

lsof -i:port  列出指定端口对应的进程

lsof -u username 指定用户

lsof -c process_name 指定进程名

lsof -p pid 指定 pid


使用 dmesg 查看当前的内核日志，debian 上可以查看 /var/log/kern.log /var/log/dmesg.0


RSS is Resident Set Size (physically resident memory - this is currently occupying space in the machine's physical memory), and VSZ is Virtual Memory Size (address space allocated - this has addresses allocated in the process's memory map, but there isn't necessarily any actual memory behind it all right now).[1]


[1] https://stackoverflow.com/questions/7880784/what-is-rss-and-vsz-in-linux-memory-management
