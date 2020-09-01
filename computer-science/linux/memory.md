# Linux 下的内存管理

<!--
ID: a65a8ed1-81a5-4cdb-b0b4-327f294ea292
Status: draft
Date: 2019-10-10T00:00:00
Modified: 2020-07-29T23:37:30
wp_id: 1584
-->


## Free 命令

新版本的 free 命令中增加了 available 一列，这里直接就是实际可使用的内存：

```
-> % free -h
              total        used        free      shared  buff/cache   available
Mem:           1.9G        775M         97M        1.2M        1.1G        1.0G
Swap:            0B          0B          0B
```

## 参考

- https://stackoverflow.com/questions/7880784/what-is-rss-and-vsz-in-linux-memory-management
- https://askubuntu.com/questions/223759/how-to-interpret-output-of-free-m-command
