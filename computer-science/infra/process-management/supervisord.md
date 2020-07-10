# 使用 supervisord 部署服务

wp_id: 613
Status: publish
Date: 2018-05-24 00:32:00
Modified: 2020-05-16 11:39:17

在某一刻你会意识到你需要写一个长期运行的服务。如果有错误发生，这些脚本不应该停止运行，而且当系统重启的时候应该自动把这些脚本拉起来。为了实现这一点，我们需要一些东西来监控脚本。这些工具在脚本挂掉的时候重启他们，并且在系统启动的时候拉起他们。

## 脚本

这样的工具应该是怎样的呢？我们安装的大多数东西都带了某种进程监控的机制。比如说 Upstart 和 Systemd。这些工具被许多系统用来监控重要的进程。当我们安装 php5-fpm，Apache 和 nginx 的时候，他们通常已经和系统集成好了，以便于他们不会默默挂掉。

然而，我们有时候需要一些简单点儿的解决方案。比如说我经常写一些 nodejs 的脚本来监控 github 上的某个动态并作相应的动作。node 可以处理 http 请求并且同时处理他们，也就是很适合作为一个一次性运行的服务。这些小的脚本可能不值得使用 Upstart 或者 Systemd 这种重量级的东西。

下面是我们的例子， 把它放在 /srv/http.js 中

```javascript
var http = require("http");

function serve(ip, port) {
    http.createServer(function (req, res) {
        res.writeHead(200, {"Content-Type": "text/plain"});
        res.write("\nSome Secrets:");
        res.write("\n"+process.env.SECRET_PASSPHRASE);
        res.write("\n"+process.env.SECRET_TWO);
        res.end("\nThere"s no place like "+ip+":"+port+"\n");
    }).listen(port, ip);
    console.log("Server running at http://"+ip+":"+port+"/");
}

// Create a server listening on all networks
serve("0.0.0.0", 9000);
```
这个服务仅仅是接受一个 http 请求并打印一条消息。在现实中并没有什么卵用，但是用来演示很好。我们只是需要一个服务来运行和监控。

注意到这个服务打印两个变量 "SECRET_PASSPHRASE" 和 "SECRET_TWO"。我们将会演示如何把这个传递个被监控的进程。

## Supervisord

Supervisord 是一个使用很广也很简单的进程监控工具。

### 安装

supervisor 支持 python 3，也建议用这个版本。

```bash
brew install supervisor
```

在 linux 上可以通过 apt-get 来安装 supervisor，同样的命令。Centos 的命令请自己查询。

```bash
% sudo apt-get install supervisor
% sudo systemctl status supervisor
● supervisor.service - Supervisor process control system for UNIX
   Loaded: loaded (/lib/systemd/system/supervisor.service; enabled; vendor preset: enabled)
   Active: active (running) since Mon 2019-12-09 18:05:36 CST; 1min 15s ago
     Docs: http://supervisord.org
 Main Pwp_id: 1356 (supervisord)
    Tasks: 1 (limit: 4915)
   CGroup: /system.slice/supervisor.service
           └─1356 /usr/bin/python /usr/bin/supervisord -n -c /etc/supervisor/supervisord.conf
```

用系统的包管理器安装的好处是默认会设置 supervisord 的 systemd unit 文件，也就是已经开机启动了。

要想安装最新版本的 supervisor，可以使用 pip。但是需要自己设计开机启动

```
pip install supervisor
```

### 配置

下面我们来配置一个 supervisor 服务。

打开 /etc/supervisor/supervisord.conf，我们可以看到最后一行：

```ini
[include]
files = /etc/supervisor/conf.d/*.conf
```

所以我们只需要把我们的配置文件放在 /etc/supervisor/conf.d 文件夹下就好了。

```ini
[program:nodehook]
command=/usr/bin/node /srv/http.js
directory=/srv
autostart=true
autorestart=true
startretries=3
stderr_logfile=/var/log/webhook/nodehook.err.log
stdout_logfile=/var/log/webhook/nodehook.out.log
user=www-data
environment=SECRET_PASSPHRASE="this is secret",SECRET_TWO="another secret"
```

每个选项如下：

* [program:xxx] 定义运行的服务的名字。
* command 启动被监控的服务的命令，如果你需要传递命令行参数的话，也放在这里
* directory 设定进程的运行目录
* autostart 是否需要在 supervisord 启动的时候自动拉起
* autorestart 是否在程序挂掉的时候自动重新拉起
* startretries 如果启动失败，重试多少次
* stderr_logfile 标准错误输出写入到哪个文件
* stdout_logfile 标准输出写入到哪个文件
* user 运行进程的用户
* environment 传递给进程的环境变量

需要注意的是，supervisor 不会自动创建日志文件夹，所以需要我们首先创建好。

```bash
sudo mkdir /var/log/webhook
```

supervisor 配置文件的搜索路径包括：

```bash
/usr/local/etc/supervisord.conf
/usr/local/supervisord.conf
supervisord.conf  # 当前目录
etc/supervisord.conf
/etc/supervisord.conf
/etc/supervisor/supervisord.conf
```

### 控制进程

可以使用 supervisorctl 来控制对应的服务了。不过需要首先启动 supervisord 的 daemon 才行。

```bash
supervisorctl reread
supervisorctl update
```

这样就可以启动刚刚定义的服务。supervisorctl 的其他功能可以查看帮助

## Web 界面

supervisor 自带了一个 web 界面。这样我们就可以通过浏览器来管理进程了。

在 /etc/supervisord.conf 中添加：

```ini
[inet_http_server]
port = 9001
username = user # Basic auth username
password = pass # Basic auth password
```

If we access our server in a web browser at port 9001, we'll see the web interface:

![](https://ws4.sinaimg.cn/large/006tNc79ly1frmjham7zcj319i0c2mz7.jpg)

## 注意

千万不要在 Docker 内部使用 supervisord 来启动多个进程，你这是在玩儿火！Docker 本身就是一个进程管理器，他的设计理念也是进程挂了就重启，如果你加了 supervisord 的话，很可能进程挂了，但是 supervisord 还活着，这样在 docker 看来整个服务就是健康的，殊不知 supervisord 可能在循环重启服务。总之，禁止套娃！

## 参考

1. https://serversforhackers.com/c/monitoring-processes-with-supervisord