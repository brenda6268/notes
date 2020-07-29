# CertManager

<!--
ID: 7a225989-84f1-4cd5-a8aa-d5bc1e51bb63
Status: draft
Date: 2020-07-29T19:25:34
Modified: 2020-07-29T19:25:34
wp_id: 1103
-->

Cert-Manager 用于管理 k8s 集群内部的证书。

Cert-Manager 中最重要的三个概念是：

- Issuer, 只能在当前命名空间颁发证书
- ClusterIssuer，可以在所有 namespace 颁发证书
- Certificate, 颁发的证书



## 参考

1. https://medium.com/@jmrobles/free-ssl-certificate-for-your-kubernetes-cluster-with-rancher-2cf6559adeba
2. 这个教程有些问题，但是也有参考价值。https://community.hetzner.com/tutorials/howto-k8s-traefik-certmanager
3. https://stackoverflow.com/questions/58553510/cant-get-certs-working-with-cert-manager