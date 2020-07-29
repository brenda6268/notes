# android vpn service

<!--
ID: 1cd44d61-8db8-48c3-acd0-4f3814fec8d5
Status: publish
Date: 2017-07-06T10:07:00
Modified: 2017-07-06T10:07:00
wp_id: 522
-->

VPN Service 运行在 IP 层。它创建了一个虚拟的网络接口，可以配置地址和路由规则，并返回一个 file descriptor。每次读这个 fp 返回一个数据包，每次写发送一个数据包。

两个最重要的方法分别是`prepare(Context)` 和 `establish()`。前者接受用户响应并关闭其他应用的 VPN 链接，后者使用 `VpnService.Builder` 的参数创建 VPN 接口。

实现 VpnService 的类必须在 manifest 中声明：

```
<service android:name=".ExampleVpnService"
         android:permission="android.permission.BIND_VPN_SERVICE">
     <intent-filter>
         <action android:name="android.net.VpnService"/>
     </intent-filter>
 </service>
```

1. VpnService works on the network layer, the IP protocol is a point to point protocol, the packet changes between each hop, TCP is a end to end protocol
2. use the vpn service as a layer4(NAT) router, and then you could modify or relay the packet
3. IP packet contains only src and dst IP address and upper protocol, the port information is stored in TCP packet
4. TCP is a stream protocol, so thers is no packet in tcp(see http://stackoverflow.com/q/1529680/)

# 关于 VPN Service 的一些讨论

[you need to reverse the ip order for ip layer headers](http://stackoverflow.com/questions/17766405/android-vpnservice-to-capture-packets-wont-capture-packets)

[ToyVPN is the official example on using vpn service](https://github.com/android/platform_development/tree/master/samples/ToyVpn)

[SSL in java](https://stackoverflow.com/questions/16358589/implementing-a-simple-https-proxy-application-with-java)

# building a client

Your VPN will need to create a new socket, protect the socket from being routed back into the VPN using `VpnService.protect(Socket)`, and connect the socket to 10.162.1.2. Having set up a tunnel connection to the VPN server, you should proceed to writing the input stream of the VpnService's interface into the tunnel's output stream, and in turn write the tunnel response back into the interface output stream.
	
http://stackoverflow.com/questions/13233477/how-to-use-vpn-in-android/#answers

1. simple example

http://www.thegeekstuff.com/2014/06/android-vpn-service/

2. building a firewall with vpn service

Incoming and outgoing streams of the VpnService are in the network layer( layer); you are receiving (and should in turn be transmitting) raw IP packets, as you describe in your question.
	
also check out the OSI model and IP header format on WikiPedia
	
When forwarding the requests, you are in the application layer; you should be transmitting the contents of the UDP or TCP payload (i.e. only their data, not the headers themselves) using respectively a DatagramSocket or a Socket.
	
Bear in mind that this skips the transport layer as those implementations take care of constructing the UDP header (in case of DatagramSocket) and the TCP header and options (in case of Socket).
	
all I hava to do is to:
	
check if the IP packet is for http or https:

if not:

act as a route, forward as is, but ack requests and reconstruct the packet with new src, and 

if so:

* act as the server, ack the request packet
* act as the client, send new http request to the server and retrive the response
* act as the server, send back the response packet

The whole process is like we are the router, and dispatch different packet to different nodes(servers).
		

http://stackoverflow.com/questions/20237743/android-firewall-with-vpnservice