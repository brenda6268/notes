# kubernetes 初探——在 Master 节点部署 Pod

<!--
ID: d52c9393-b35a-41b2-90c9-fcd3872000dd
Status: publish
Date: 2019-02-12T19:57:00
Modified: 2020-05-16T11:05:00
wp_id: 551
-->

虽然 K8S 本身不建议在 Master 节点中部署 Pod，但是实际上也是可以的。

```sh
kubectl taint nodes --all node-role.kubernetes.io/master-
```

这行命令的意思是移除所有节点的 master taint，这样就可以在 master 节点部署 pod 啦~

# 原理解释——taint 和 toleration


1. https://www.ibm.com/support/knowledgecenter/en/SSCKRH_1.0.1/platform/install_pod_scheduling.html
2. https://kubernetes.io/docs/concepts/configuration/taint-and-toleration/