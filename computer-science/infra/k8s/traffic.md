Kubernetes 如何向外提供服务

## ClusterIP + Proxy

ClusterIP 是集群内部提供服务的默认方式。可以采用 Proxy + ClusterIP 的方式临时提供对外服务。

## NodePort

NodePort 方式在每个 host 上都开一个端口来对外提供服务，适合一些临时性的服务。

## LoadBalancer

使用云厂商提供的 LoadBalancer 来提供服务，唯一的缺点是每一个服务会消耗一个 IP，比较贵。。

除此之外，还可以使用 MetalLB 等等。

## Ingress

Ingress 并不是 K8S 的一种服务类型，实际上他本身是一个 Service，然后路由到不同的服务。实际上 Ingress 就是反向代理。

但是要暴露出去 Ingress 服务本身，可能还是要使用 NodePort 或者 LoadBalancer。

Internet -> Loadbalancer -> Ingress Controller -> Ingress Rules -> K8s-Services -> Replicas

Internet -> NodePort -> Ingress Controller -> Ingress Rules -> K8s-Services -> Replicas

在 K3S 中自带了一个 service lb，所以只要确保 ingress controller 第一个暴露出 loadbalancer 类型的 80 端口，就能自动通过 80 端口访问了。

### Traefik

traefik 在 2.0 中不止支持了 K8S 默认的 ingress，还自己定义了一种 IngressRoute 类型的 CRD。千万不要用这个 IngressRoute，他还不支持证书，简直就是废物。

尽量不要使用 Traefik，bug 太多了。。

### nginx

nginx 毕竟是官方支持的 ingress，比较稳定，而且性能也比较好。            



## 参考

1. https://medium.com/google-cloud/kubernetes-nodeport-vs-loadbalancer-vs-ingress-when-should-i-use-what-922f010849e0
2. https://stackoverflow.com/questions/45079988/ingress-vs-load-balancer