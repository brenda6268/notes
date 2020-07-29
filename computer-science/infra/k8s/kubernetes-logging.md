# kubernetes 初探——日志收集

<!--
ID: 37dc9f27-57a6-4c9a-87ea-f954e8f6dec9
Status: publish
Date: 2018-09-30T04:58:00
Modified: 2020-05-16T11:24:43
wp_id: 555
-->

在 K8S 中, 默认情况下, 日志分散在每个不同的 Pod, 可以使用 kubectl logs 命令查看, 但是当 Pod 被删除之后, 就无法查看该 Pod 的日志了, 所以需要一种永久性的保存方式.

Grafana 公司推出的 Loki 看起来不错，完全为 Kubernetes 设计, 直接和 grafana 集成。
