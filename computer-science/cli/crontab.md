# Crontab 的语法和使用


ID: 433
Status: publish
Date: 2017-05-29 15:41:00
Modified: 2020-05-16 12:10:16


Crontab 时间的语法:

```
Minute Hour Day Month DoW
```

每一个选项默认都是第几的意思

* Minute, 每小时的第几分, 可选值 0-59
* Hour, 每天的第几个小时, 可选值 0-23
* Day, 每月的第几天, 可选值 1-31
* Month, 每年的第几个月, 可选值 1-12
* DoW, 每周的第几天, 可选值 0-7, 0 和 7 都代表 Sunday
* Command, 要执行的命令

另外:

- 用 * 表示所有
- 可以用逗号分隔指定多个
- 用 `*/xx` 表示每 xx 一次

比如

```
5 * * * * echo &quot;hello world&quot;
```

每小时的第五分钟打印 hello world

更多地例子

```
* * * * *	每分钟
12 * * * *	每小时第 12 分
0,15,30,45 * * * * 每小时的第 0, 15, 30, 45 分, 也就是每15分钟一次
0 4 * * *	每天的凌晨 4 点
0 4 * * 2	每周二的凌晨 4 点
*/4 2-6 * * *	2点和6点之间每 4 分钟一次, 也就是 0, 4, 8...
```

# crontab 命令

应该使用 crontab 命令来编辑 crontab 文件, tab 就是 table 的缩写

```
crontab -e # 编辑 crontab
crontab -l # 列出 crontab
crontab -u # 指定用户
```

crontab 还支持一些特殊语法

```
@hourly 相当于 0 * * * * 也就是每小时执行
@daily  相当于 0 0 * * * 也就是每天执行
@weekly 相当于 0 0 0 0 0
monthly
@yearly
@reboot	at reboot
```

NOTE:

```
# add these line to tweak cron behavior
SHELL=/bin/bash
HOME=/
MAILTO=&quot;example@digitalocean.com&quot;
```


# Cron 表达式的局限性

cron 表达式难以表达 "every x" 这个语义。比如说每隔 9 个小时如何， 每隔 13 分钟如何如何。

# cron 的实现