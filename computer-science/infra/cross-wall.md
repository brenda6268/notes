这篇文章需要你付费购买一个 VPS 或者到 AWS/Linode/DigitalOcean 购买一个实例，以及购买一个阿里云或者国内的服务器，还需要购买 shadowrocket 应用，并且主要讨论`*nix`平台，所以舍不得花钱的或者 Windows 用户可以点击左上角返回了。

## 2019 更新，使用 v2ray

1. [一键安装 v2ray](https://github.com/233boy/v2ray/wiki/V2Ray%E6%90%AD%E5%BB%BA%E8%AF%A6%E7%BB%86%E5%9B%BE%E6%96%87%E6%95%99%E7%A8%8B)
2. [https://www.svlik.com/2113.html](https://www.svlik.com/2113.html)

## 缩略版

墙是无处不在的，有时候只用一种方法总会撞墙，总结一下各种情况下的上网手法，围绕 ss 来说：

1. 在国外的服务器搭建 ss server，其实这样配合 ss client 已经能用了
2. 然后使用阿里云的服务器中继，这样在国内复杂的网络环境下可以保证可用性
3. Chrome 使用 swithyomega 插件，可以订阅 GFWList，避免所有网站都从国外走一遍
4. 命令行可以使用 proxychains4，多数命令行应用可以借此翻墙
5. 本地使用 polipo 打开一个 http 代理，这样不能使用 proxychains 的应用也可以走 http 代理
6. iOS 手机上可以使用 shadowrockets，Android 应该也有类似客户端

## 具体步骤

### 搭建 shadowsocks server

非常简单

```
# 直接安装的话，会报错，需要使用 github 上的最新版本。
$ apt install -y shadowsocks
$ cat> shadowsocks.json <<EOF
{
    "server_port": 10086,
    "password": "jkrowling",
    "method": "aes-256-cfb",
    "fast_open": true
}
EOF
$ ssserver -c shadowsocks.json
# 就可以了，不过建议使用 daemon 模式，参见-h ''
```

### 添加国内中继（可选）

#### 方法一、使用 iptables（不推荐）

这一步是可选的，之所以用阿里云做中继是因为国内网络太复杂了，同样的一台国外服务器，在不同的网络速度完全不一样，而阿里云连接国外的网络还是比较稳定的，同时在国内的网络下表现也比较好，适合做中继。 在阿里云的服务器上执行下面的脚本 

```bash
#!/bin/bash
REMOTE_IP=`host your.server.domain | cut -f 4 -d`

echo 1> /proc/sys/net/ipv4/ip_forward

iptables -t nat -A PREROUTING -p tcp --dport $REMOTE_PORT -j DNAT --to-destination $REMOTE_IP:$REMOTE_PORT
iptables -t nat -A POSTROUTING -p tcp -d $REMOTE_IP --dport $REMOTE_PORT -j SNAT --to-source $LOCAL_IP

echo relay to $REMOTE_IP:$REMOTE_PORT via $LOCAL_IP is enabled
```

#### 方法二、使用 haproxy（推荐）

### 本地普通使用

服务器搭好之后就可以用了，在本地安装 shadowsocks X 或者安装命令行版的客户端。shadowsocks 的客户端，实际上是在本地 localhost:1080 打开了一个 socks5 服务器，客户端配置填上面的服务器，之后启用全局代理的话，打开 Safari 或者 Chrome 应该就可以直接用了，不过建议使用 Chrome 安装 SwitchyOmega，更方便的切换代理。

```
cat > ss.json << EOF
{
    "server":"my_server_ip",
    "server_port":8388,
    "local_address": "127.0.0.1",
    "local_port":1080,
    "password":"mypassword",
    "timeout":300,
    "method":"chacha20-ietf-poly1305",
    "fast_open": false,
    "workers": 1
}

sslocal -c ss.json -d start
```

### 命令行使用

上述的 shadowsocks 客户端是在本地启动了一个 socks 代理，对于 GUI 应用，普遍有设置选项或者会跟随系统代理，应该问题不大，但是面临被墙的另一个大头是 github 和 pypi 等源，如果不能在命令行使用，损失很大。遗憾的是不少的应用都没有支持代理的选项，可以使用 proxychains4。 

```bash
$ git clone https://github.com/rofl0r/proxychains-ng.git

cd proxychains-ng
$
./configure && make && make install
$
make install-config
```

#### 配置文件

```bash
$ cat> ~/.proxychains/proxychians.conf <<EOF strict_chain
proxy_dns
remote_dns_subnet
224 tcp_read_time_out
15000 tcp_connect_time_out
8000 localnet
127.0.0.0 /
255.0.0.0 quiet_mode

[ProxyList]
# shadowsocks
socks5
127.0.0.1 1080 # shadowsocks 默认打开的是 1080 端口
EOF
```

配置好之后，比如，希望通过 git clone 一个仓库，然而运行 `git clone https://github.com/yifeikong/dotfiles` 之后陷入了无尽的等待，这时候只需要`proxychains4 git clone https://github.com/yifeikong/dotfiles` 就可以了。 可以加以句 alias 在。bashrc 中，alias px=proxychains4，这样再有运行不了的命令，直接`px !!` 就可以了~

### 本地 http 代理

遗憾的是，即使有了 proxychains，一些应用依然不能使用代理，这时候可以使用 polipo 再利用 socks 代理建立以 http 代理。

```bash
apt-get -y install polipo
echo "socksParentProxy=localhost:1080" >> /etc/polipo.conf
systemctl restart polipo
```

如上命令将会建立一个本地的 http 代理，默认端口号是 8123，这样我们就可以通过设置$http_proxy 变量来使得一些应用可以翻墙了。 建议添加

```bash
proxy() {

if [ $1 == on ];
then
   export http_proxy=http://127.0.0.1:8123
   export https_proxy=$http_proxy
else
   export http_proxy=
   export https_proxy=$http_proxy
fi
}
```

以便快速切换代理

### 手机

在手机上可以使用 shadowrockets 打开一个全局的 VPN 链接 shadowsocks，不再赘述了。


## 参考

1. https://wiki.archlinux.org/index.php/Shadowsocks#Client