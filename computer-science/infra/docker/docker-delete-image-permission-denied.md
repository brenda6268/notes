# Docker 删除镜像“Permission Denied”


<!--
ID: b4beb6a3-3577-4c8c-977d-334ab08c410a
Status: publish
Date: 2019-10-15T12:05:20
Modified: 2020-05-16T10:50:00
wp_id: 774
-->


```bash
sudo aa-remove-unknown
```

这种一般是因为使用了 ubuntu snap 安装的 docker。建议 `snap remove docker` 然后安装官方版。

参考：https://stackoverflow.com/questions/49104733/docker-on-ubuntu-16-04-error-when-killing-container