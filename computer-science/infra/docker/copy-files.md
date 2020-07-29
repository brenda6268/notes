# Docker 与 K8s 复制文件

<!--
ID: 4dc95fcb-d63c-47e5-9908-139395599616
Status: draft
Date: 2020-07-29T19:23:55
Modified: 2020-07-29T19:23:55
wp_id: 1097
-->

## docker 复制文件

```
docker cp <containerId>:/file/path/within/container /host/path/target
```

## 备份镜像 volume

除了直接用 docker cp 之外，还可以使用 volume-backup 这个镜像。

```
docker run -v [volume-name]:/volume --rm loomchild/volume-backup backup - > [archive-name]
```

## K8S 中复制文件

```
kubectl cp -h
```

## 参考

1. https://stackoverflow.com/questions/22049212/copying-files-from-docker-container-to-host
2. https://github.com/loomchild/volume-backup