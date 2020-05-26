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