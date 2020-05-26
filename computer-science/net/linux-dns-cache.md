# Linux 上的 DNS 缓存


ID: 414
Status: publish
Date: 2018-04-13 05:51:00
Modified: 2020-05-16 11:35:48


Linux 内核中没有 DNS 缓存

Firefox 内置了 DNS 缓存

`nscd` 可以提供本地的 DNS 缓存，好多机器开了，但是据说这个服务有很多问题。

Python 使用了 `getaddrinfo` 函数，会使用系统的 DNS 缓存

像 `nslookup` 和是dig这样的工具会 bypass 掉 DNS 缓存。

另外 Go 语言好像也不会使用本机的 DNS 缓存，即使开了

https://wiki.archlinux.org/index.php/dnsmasq 可以用来做本地缓存

还可以使用systemd提供的resolved

1 https://stackoverflow.com/questions/11020027/dns-caching-in-linux