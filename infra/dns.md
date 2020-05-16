# 使用 dnsmasq 配置内网解析 DNS

在公司的内部网络，我们往往需要私有的域名解析到内网地址。如果把这些信息放到公网的 DNS 服务上，会暴露我们的内网 IP，从而构成一些安全隐患。所以最好把解析放到内部来。

## 使用 /etc/hosts 的不足

1. 无法泛解析，比如说把 `*.test` 全部解析到本机 localhost。
2. 只在本地生效，每台机器都需要配置。

而如果我们使用了 dnsmasq 这类的 DNS 工具，只需要配置一次，并把本机的 DNS 指向改了就好了。

一下假设我们的 DNS 服务器是 10.10.10.53，应用服务器是 10.10.10.10。

## 安装 dnsmasq

在 DNS 服务器上安装：

```
sudo apt -y install dnsmasq
```

## 关闭 systemd-resolved

在现代的 Linux 发行版上，一般是使用 systemd 作为 pid=1 的 init 进程。而 systemd 还自带了 DNS 服务器 (systemd-resolved) 作为本机的 DNS 缓存，并把本机的 DNS 服务器指向了 127.0.0.53，也就是本机（127.0.0.0/8 都是本机）。

```bash
sudo systemctl disable systemd-resolved.service
sudo systemctl stop systemd-resolved
sudo rm /etc/resolv.conf  # 删掉 systemd 原有的链接
```

然后打开 /etc/resolv.conf 输入如下内容

```
nameserver 127.0.0.1
```

这时候我们可以看到当前机器就无法解析 DNS 了，比如使用 `curl baidu.com`，会返回错误。

## 启动 dnsmasq

我们有 kyf.la 的域名，但是想把 *.int.kyf.la 作为内部的域名（int是internal 的缩写）。我们内部服务器的地址是 10.10.10.10 。

编辑 `/etc/dnsmasq.conf`，增加以下两行：

```
server=8.8.8.8  # 指定上游的服务器
address=/.int.kyf.la/10.10.10.10  # 把 *.int.kyf.la 的域名都指向本地
```

然后重启 dnsmasq。

然后用 dig 看一下，就已经可以啦。

```
-> % dig traefik.int.kyf.la @127.0.0.1

; <<>> DiG 9.11.3-1ubuntu1.8-Ubuntu <<>> traefik.int.kyf.la @127.0.0.1
;; global options: +cmd
;; Got answer:
;; ->>HEADER<<- opcode: QUERY, status: NOERROR, id: 62867
;; flags: qr aa rd ra ad; QUERY: 1, ANSWER: 1, AUTHORITY: 0, ADDITIONAL: 0

;; QUESTION SECTION:
;traefik.int.kyf.la.            IN      A

;; ANSWER SECTION:
traefik.int.kyf.la.     0       IN      A       10.10.10.10

;; Query time: 0 msec
;; SERVER: 127.0.0.1#53(127.0.0.1)
;; WHEN: Thu May 14 16:14:49 CST 2020
;; MSG SIZE  rcvd: 52
```

## 在本地配置 DNS 服务器

在本机的 DNS 配置中，修改 DNS 服务器指向 10.10.10.53，然后就可以使用了。需要注意的是如果本地使用了 VPN 等工具，那么需要把 VPN 的代理也改成 10.10.10.53。

## 结合 Kubernetes Ingress Controller 使用

## 参考

1. https://en.wikipedia.org/wiki/.local
2. https://www.stevenrombauts.be/2018/01/use-dnsmasq-instead-of-etc-hosts/
3. https://qiita.com/bmj0114/items/9c24d863bcab1a634503
4. https://www.naut.ca/blog/2018/12/12/disabling-systemd-networking/