# 故障排查记录

<!--
ID: 4cc6683a-2967-4580-a0bd-dbe268bb2901
Status: publish
Date: 2019-01-25T18:03:00
Modified: 2019-01-25T18:03:00
wp_id: 553
-->

Case 1：

CPU 和内存都被打满了，同时发现硬盘 IO 也很高。

```
ps -eo pid,ppid,cmd,%mem,mem,%cpu --sort=-%mem | head -n 50
```

发现 kswapd0 偶尔会占用很高的 CPU，而这个进程是在内存满的时候负责在内存和 swap 之间交换。也就是问题的根源是内存满了，而 kswapd0 开始在内存和 swap 之间反复读写文件，导致 CPU 和 IO 也涨了起来，这时候应该找到内存暴涨的根源，进而解决问题。

[1] https://askubuntu.com/questions/259739/kswapd0-is-taking-a-lot-of-cpu