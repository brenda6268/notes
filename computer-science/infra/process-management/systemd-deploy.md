# systemd


wp_id: 114
Status: publish
Date: 2017-06-26 17:48:47
Modified: 2020-05-16 11:44:20


YN：如何使安装的服务开机启动？是更改 wantedby 吗？如果是，wantedby 的值应该是什么？ 对于 nginx 这样的 daemon 服务如何管理？


大多数的 Linux 系统已经选择了 systemd 来作为进程管理器。之前打算使用 supervisord 来部署服务，思考之后发现还不如直接使用 systemd 呢。这篇文章简单介绍下 systemd。 # 例子

我们从一个例子开始，比如说我们有如下的 go 程序：

```
<pre class="code">package main

import (
    fmt
    net/http
)

func handler(w http.ResponseWriter, r *http.Request) {
    fmt.Fprintf(w, Hi there!)
}

func main() {
    http.HandleFunc(/, handler)
    http.ListenAndServe(:8181, nil)
}
```

编译到 /opt/listen/listen 这里。 首先我们添加一个用户，用来运行我们的服务：

```
<pre class="code">adduser -r -M -s /bin/false www-data
```

记下这条命令，如果需要添加用户来运行服务，可以使用这条。 





# Unit 文件

Unit 文件定义了一个 systemd 服务。`/usr/lib/systemd/system/` 存放了系统安装的软件的 unit 文件，`/etc/systemd/system/` 存放了系统自带的服务的 unit 文件。 我们编辑 /etc/systemd/system/listen.service 文件： 

```
<pre class="code">[Unit]
Description=Listen

[Service]
User=www-data
Group=www-data
Restart=on-failure
ExecStart=/opt/listen/listen
WorkingDirectory=/opt/listen

Environment=VAR1=whatever VAR2=something else
EnvironmentFile=/path/to/file/with/variables

[Install]
WantedBy=multi-user.target
```

然后

```
<pre class="code">sudo systemctl enable listen
sudo systemctl status listen
sudo systemctl start listen
```

其他一些常用的操作还包括：

```
<pre class="code">systemctl start/stop/restart    
systemctl reload/reload-or-restart  
systemctl enable/disable    
systemctl status    
systemctl is-active 
systemctl is-enabled
systemctl is-failed
systemctl list-units [--all] [--state=…]    
systemctl list-unit-files
systemctl daemon-reload 
systemctl cat [unit-name]   
systemctl edit [uni-name]
systemctl list-dependencies [unit]
```







# 依赖管理

In that case add Requires=B and After=B to the [Unit] section of A. If the dependency is optional, add Wants=B and After=B instead. Note that Wants= and Requires= do not imply After=, meaning that if After= is not specified, the two units will be started in parallel. if you service depends on another service, use requires= + after= or wants= + after= 

## 类型

Type: simple / forking 关于每个字段的含义，可以参考[这篇文章](https://www.digitalocean.com/community/tutorials/understanding-systemd-units-and-unit-files "https://www.digitalocean.com/community/tutorials/understanding-systemd-units-and-unit-files")





# 使用 journalctl 查看日志

首先吐槽一下, 为什么要使用 journal 这么一个拗口的单词, 叫做 logctl 不好么… 

```
<pre class="code">journalctl -u service-name.service
```

还可以添加 `-b` 仅查看本次重启之后的日志. 



# 启动多个实例

[https://unix.stackexchange.com/questions/288236/have-systemd-spawn-n-processes](https://unix.stackexchange.com/questions/288236/have-systemd-spawn-n-processes "https://unix.stackexchange.com/questions/288236/have-systemd-spawn-n-processes")[http://0pointer.de/blog/projects/instances.html](http://0pointer.de/blog/projects/instances.html "http://0pointer.de/blog/projects/instances.html")