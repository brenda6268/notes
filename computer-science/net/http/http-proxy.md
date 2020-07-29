# http(s) 代理的原理


<!--
ID: 104a400f-5298-4f24-89f5-ae07ace431dd
Status: draft
Date: 2017-05-29T11:53:00
Modified: 2020-05-16T12:07:49
wp_id: 579
-->


## http(s) 协议

http 协议相信大家都明白，不再赘述。

https 是在 http 协议下面加了一层 ssl 协议。root ca's public key is preinstalled into the OS/browser. server and client exchange metadata, server send its certs, the certs is issued by the root ca and contains the sites's public key

## http proxy

![](https://ws2.sinaimg.cn/large/006tKfTcly1fqautp3tlrj30mr0awdh5.jpg)

http proxy is simple, skip.

one thing to notice is that, browser use persistent connections by default, so a connection or only a few connections are created to the proxy server, and then the browser reuse all the connections.

https protocol is basically ssl layer on port 443 + http protocol

## http proxy tunneling/https proxy

if a http proxy server support the CONNECT method, and forward the following binary bytes as is, then it's considered a tunneling http proxy.

if a http proxy supports tunneling, then it can be used in https, then it's a https proxy. however, the proxy does not know anything about the traffic.

要想在代理上能够劫持或者篡改的 https 的流量，需要在客户端预先按照自己的根证书，一些能够查看网络流量的工具，像是 charles、fiddler 都是这么做的