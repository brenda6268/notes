# Linux 命令行网络相关命令学习


wp_id: 595
Status: publish
Date: 2017-05-31 06:54:00
Modified: 2020-05-16 12:03:44


有待整理。。。

# fuser

查看哪个程序占用了给定端口

```
fuser XXX/tcp  # see which program is using tcp port XXX
fuser XXX/upd  # see which program is using udp port XXX
fuser -k XXX/tcp  # kill the program, if you have right permissions
```

# curl

wget 功能很有限，httpie 虽然比较人性化但是有很多 bug，还是 curl 比较好用。

```
curl -L/--follow http://example.com	          follow redirect
curl -I/--head http://example.com	          only headers 
curl -o/--output file http://example.com	  http -d
curl -v/--verbose http://example.com	
curl --data "key=value" http://example.com	
curl --data-urlencode "key=
curl -X/--request GET/POST http://example.com	
curl -H/--header "Accept: utf-8"	
curl --referer http://x.com http://example.com
curl --user-agent 
```
curl --cookie

## 使用代理


```
curl -x <protocol>://<user>:<password>@<host>:<port> --proxy-anyauth <url>
```


## cookies

cookies 功能主要通过两个选项实现 `-b/--cookie` 和 `-c/--cookie-jar`. `--cookie` 用于发送请求时
携带 Cookies, `--cookie-jar` 会把返回的 Cookie 按照 cookie.txt 规范存储到给定的文件中.

```
curl -v --cookie "USER_TOKEN=Yes" http://127.0.0.1:5000/
curl -v --cookie example.txt http://example.com
```

需要注意的是, 如果 `--cookie` 的参数中包含了 `=`, 他就会被当做一个键值对来处理, 而且可以
使用多个 Cookie, 用分号分开即可: "key1=val1;key2=val2;...". 否则的话, 这个参数会被当做文
件名, 会读取对应文件的 Cookie, 这个文件同样要遵守 cookie.txt 的协议.


# 查看网络情况

需要注意的是，在 Linux 上 netstat 已经废弃了，应该使用新的 ss 命令。不过在 macOS 等Unix系统中，还是只有netstat

```
netstat -a 	list all ports
netstat -at	list all tcp ports
netstat -l	all listening ports
```

netstat -in 查看提供网络接口的信息

netstat -rn 显示路由表

ifconfig eth0 显示接口的状态

ifconfig -a 所有接口的状态

ip addr eth0 全新的命令

Mac

和 Linux 基本相同, 但是缺少 ip 指令, 需要安装 iproute2mac 包



traceroute

nslookup

host

wget --noproxy

mtr

bt download

sudo add-apt-repository ppa:t-tujikawa/ppa 
sudo apt-get update 
sudo apt-get install aria2




# 使用 rsync 同步

rsync -azP local_dir remote_dir

* `-a` archive，表示归档
* `-n` dry-run，只显示要执行的操作而不具体执行
* `-z` compress，压缩
* `-P` --progress + --partial，显示进度同时断点续传
* `--exclude=<dir>` exclude directory from being rsynced


默认情况下，rsync 使用增量同步，而不会删除文件。使用 `--delete` 删除文件

# 参考资料

1. https://curl.haxx.se/docs/http-cookies.html
