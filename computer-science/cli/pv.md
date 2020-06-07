# pv - 在 Linux 下查看命令执行进度


wp_id: 435
Status: publish
Date: 2018-04-12 07:41:00
Modified: 2020-05-16 11:35:20


pv 是 Pipe Viewer 的缩写，也就是管道查看器。挡在命令行执行命令的时候，可以通过使用 pv 来指导当前的进度。

# 使用

## 替换 cat

比如你要把一个日志打包好下载：

```
% gzip -c access.log > access.log.gz
```

可以改成

```
% cat access.log | gzip > access.log.gz
```

使用 pv

```
% pv access.log | gzip > access.log.gz
611MB 0:00:11 [58.3MB/s] [=>      ] 15% ETA 0:00:59
```

## 使用多个 pv

可以使用多个 pv 来查看在不同阶段的速率

```
$ pv -cN source access.log | gzip | pv -cN gzip > access.log.gz
source:  760MB 0:00:15 [37.4MB/s] [=>     ] 19% ETA 0:01:02
  gzip: 34.5MB 0:00:15 [1.74MB/s] [  <=>  ]
```

在上面的命令中，`-c` 是为了防止两个 pv 的显示混在一起。`-N` 表示名字。可以看到读取 access.log 的速率是 37.4 MB/s，而写入 gzip 文件的速率大概是 1.74 MB/s，我们大概也可以得出压缩率大概是21倍。

## 指定文件的大小

可以用下面这个命令压缩一个文件夹。

```
$ tar -czf - . | pv > out.tgz
 117MB 0:00:55 [2.7MB/s] [>         ]
```

在上面的例子中我们可以看到下面 gzip 一行的输出中没有百分比，因为 pv 没法知道 gzip 之后的最终大小，所以没有办法计算进度。可以使用 `-s` 指定大小。

```
$ tar -cf - . | pv -s $(du -sb . | awk "{print $1}") | gzip > out.tgz
 253MB 0:00:05 [46.7MB/s] [>     ]  1% ETA 0:04:49
```