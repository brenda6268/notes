# 使用 ssh 反向隧道登录没有 IP 的服务器

<!--
ID: b1280b96-4fe8-4f5a-a010-103bffe5eaa2
Status: publish
Date: 2019-10-16T10:18:29
Modified: 2020-05-16T10:49:47
wp_id: 775
-->

假设我们家里的服务器叫做 homeserver，没有公网 IP。然后我们有一台服务器叫做 relayserver，拥有公网 IP。

在家里执行
```bash
homeserver~$ ssh -fN -R 10022:localhost:22 relayserver_user@1.1.1.1
```

在服务器上就可以登陆啦
```bash
relayserver~$ ssh -p 10022 homeserver_user@localhost
```

然而这样链接还是很不稳定的，我们还是需要一个稳定的链接，这时候就可以使用 autossh 了，它会保持链接的稳定，自动重新连接。

```bash
autossh -M 20000 -f -N your_public_server -R 1234:localhost:22 -C
```

参考

1. http://xmodulo.com/access-linux-server-behind-nat-reverse-ssh-tunnel.html
2. https://superuser.com/questions/37738/how-to-reliably-keep-an-ssh-tunnel-open
