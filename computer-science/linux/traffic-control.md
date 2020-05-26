# Linux 流量控制

前几天安装 WireGuard 时候突然想到这个东西为啥没有 Qos（流量控制）呢，查了半天终于发现原来 Linux 下可以直接使用 tc 来控制网卡流量，这样就实现了 WireGuard 的流量控制。Linux 下还真是一个工具只做一件事情啊！

- 状态。IP 协议是没有状态的，而流量控制是要求有状态的。
- 队列。
- 流。这个是个逻辑上的概念。
- 令牌桶。


## 在 WireGuard 中使用

WireGuard 通常使用 wg0 网卡作为流量出口。   

## 参考

1. http://www.tldp.org/HOWTO/html_single/Traffic-Control-HOWTO/
2. https://wiki.debian.org/TrafficControl 重点看这个
3. http://codeshold.me/2017/01/tc_detail_inro.html
4. https://unix.stackexchange.com/questions/208450/how-to-configure-qos-per-ip-basis 重点看这个