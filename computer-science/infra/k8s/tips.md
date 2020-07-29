# kubernetes tips

<!--
ID: f7a46688-ad30-4153-a940-ae8f15bc8283
Status: draft
Date: 2020-05-28T14:09:32
Modified: 2020-05-28T14:09:32
wp_id: 1030
-->

重启一个服务

```
kubectl -n service rollout restart deployment <name>
```


## statefulsets vs deployments+volumes

deployments 加上 volumes 之后和 statfulsets 还有什么区别呢？statefulsets 除了永久保存数据之外，还保存了分区主从等信息。比如 mysql 的分区分表，如果只简单挂载同一个 volume 是不行的。