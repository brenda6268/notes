# Linux 命令行查看系统信息

<!--
ID: ade1e70c-e327-4756-b545-b6b85051c0b7
Status: publish
Date: 2018-03-03T05:23:00
Modified: 2020-05-16T11:30:52
wp_id: 599
-->

# 查看机器名

uname -a # view system name
arch # show arch

# 查看 ubuntu 版本

show ubuntu version

cat /etc/*release


# 查看内存使用

free -mh

```
(master)kongyifei@localhost ~ $ free -mh
             total       used       free     shared    buffers     cached
Mem:          251G       241G       9.8G       5.9G       4.3G        76G
-/+ buffers/cache:       161G        90G
Swap:           0B         0B         0B
```

含义，第一行表示实际的内存占用情况，linux 的机制是尽可能多的占用内存，所以 free 往往很小；但是占用的内存不一定都在被使用，也就是最后的 buffers 和 cached 内存是被系统预先占用的。
在第二行把这两项抛出，就是你的实际内存占用 161G，实际可使用内存 90G

# iostat 和 vmstat

vmstat -awS M

```
(master)kongyifei.rocks@n8-147-097 ~/repos/crawl_deploy/svc_ctl $ vmstat -a
procs -----------memory---------- ---swap-- -----io---- -system-- ------cpu-----
 r  b   swpd   free  inact active   si   so    bi    bo   in   cs us sy id wa st
57  0      0 197155680 3614480 57558348    0    0     8    39    0    0  6  2 91  0  0
```

查看内存使用情况，其中最重要的是 free 和 si、so 三列，其中 free 表示空闲内存，si 表示 swap in，so 表示 swap out

vmstat INTERVAL TIMES 执行 vmstat 每 INTERVAL 秒，并且执行 TIMES 次

http://www.orczhou.com/index.php/2010/03/iostat-detail/
