# 如何导出 Docker 镜像


wp_id: 743
Status: publish
Date: 2019-10-10 09:50:13
Modified: 2020-05-16 10:50:16


可以使用 docker save 和 docker export 导出 docker 镜像。那么两者有什么区别呢？

- export 是用来导出一个容器的，也就是运行中的镜像。
- save 是用来导出镜像的，也就是还没有运行的镜像。

这里我们需要用的显然是 docker save。

语法是：

```bash
docker save [OPTIONS] IMAGE [IMAGE...]
```
其中的 options 也就一个参数 -o 文件名。如果不指定 -o 的话直接输出到 stdout，方便使用管道串联。

如果需要压缩的话还可以这样

```bash
docker save myimage:latest | gzip > myimage_latest.tar.gz
```

导出之后，可以使用 docker load 导入镜像。不使用 -i 的话直接从 stdin 读取。

```bash
docker load -i FILE
```

