# K3s 


k3s 是 rancher 出品的一个 kubernetes 的衍生版，特点是单二进制文件，非常小巧，可以在树莓派上部署。虽然他对好多组件做了替换，比如把 etcd 替换成了 sqlite3，但是他依然是一个通过了官方认证的 Kubernetes 发行版。

除了 k3s 以外，还有一些其他的精简的 k8s 发行版，比如 microk8s, kind, minikube 等等，但是都远远没有 k3s 轻量。详细资料可以看参考资料.

安装完成之后要设置：export KUBECONFIG=/etc/rancher/k3s/k3s.yaml

## 加入 Worker 节点

其中 K3S_TOKEN 在服务器的 `/var/lib/rancher/k3s/server/node-token` 路径中

```sh
curl -sfL https://get.k3s.io | K3S_URL=https://myserver:6443 K3S_TOKEN=mynodetoken sh -
```


## 存储

k3s 默认带了自己的 local-path provider，所以直接就能使用。

可以使用 rancher 家的 longhorn，安装非常简单

## 网络

k3s 自带了 1.7 版本的 traefik，而现在 traefik 已经 2.2 版本了。

如何禁用内置的 traefik：https://github.com/rancher/k3s/issues/1160#issuecomment-561572618

k3s 好像无论如何弄都在监听 0.0.0.0，只好用安全组禁用掉端口了


## 参考资料

1. k3s 官方文档。https://rancher.com/docs/k3s/latest/en/quick-start/
2. https://www.reddit.com/r/kubernetes/comments/be0415/k3s_minikube_or_microk8s/
3. https://brennerm.github.io/posts/minikube-vs-kind-vs-k3s.html
4. 非常全的一份文档 https://kauri.io/38-install-and-configure-a-kubernetes-cluster-with/418b3bc1e0544fbc955a4bbba6fff8a9/a