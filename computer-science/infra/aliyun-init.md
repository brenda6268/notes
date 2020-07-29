# 阿里云新环境机器配置步骤

<!--
ID: dcae92c6-a70c-49ff-ae58-67482ff28e81
Status: draft
Date: 2017-08-24T06:30:00
Modified: 2020-05-16T11:50:59
wp_id: 589
-->

首先机器分为两类，一台开发机或者叫堡垒机，用来做开发测试，其他的都是生产环境或者测试环境的线上机器。所有机器上都有 tiger 账户作为默认账户，如果没有指定特殊用户的话，服务就会使用这个账户运行。开发机上每个人都有自己单独的账户，是姓名的全拼。

# 修改 hostname

修改 hostname 为 `ip-10-0-0-0` 的样式，因为 hostname 是 consul 默认的节点名称，很关键。

文件为 `/etc/hostname`

```
echo ip-10-0-0-0 > /etc/hostname
```

# 配置账户

把 public key 推送到 root 账户下，如果使用阿里云并且指定了密钥对，那么直接登录就可以了，跳过这一步

```
$ ssh-copy-id root@...
```

## 创建 tiger 账户

```
# adduser tiger
# EDITOR=vi visudo
添加 tiger ALL=(ALL) NOPASSWD: ALL，使得tiger账户可以无密码t使用sudo
```

```
$ ssh-copy-id tiger@10.0.0.0
```

```
mkdir -p ~tiger/.ssh
cp .ssh/authorized_keys ~tiger/.ssh/
chown -R tiger:tiger ~tiger/.ssh/
```

到这里root用户就使用完了，之后尽量不要使用root账户


# 安装基础库

```
$ sudo apt-get update
$ sudo apt-get install -y git

# 部署服务的机器就不装 dotfiles 了

$ git clone git@github.com:yifeikong/dotfiles .dotfiles
$ cd .dotfiles
$ ./setup.sh  # 安装配置文件

$ mkdir repos
$ git clone git@github.com:yifeikong/install repos/install
$ cd repos/install
$ ./install_tmux.sh
$ ./install_mosh.sh  # 仅在开发机上安装
$ ./install_python.sh
$ ./install_docker.sh
...
```

# 安装数据库

线上环境安装mysql `./install_mysql.sh`

线上环境和开发机都安装 mycli `pip3 install mycli`

更改 mysql 的绑定的IP `/etc/mysql/mysql.conf.d/mysqld.cnf` => `bind-address = 10.1.3.6`

```
systemctl restart mysql
```

创建数据库用户 tiger：

```
create user "tiger"@"%" identified by "password";
grant all on *.* to "tiger"@"%";
flush privileges;
exit;
```

# 基础 python 库

1. 安装 `git clone git@github.com:yifeikong/futile ~/repos/futile`
2. 设置环境变量 

# 把某台ECS作为NAT主机，提供网络访问

参考这里：http://yifei.me/note/556

# 安装 registry

```
git clone git@github.com:yifeikong/docker_registry /opt/docker_registry
/opt/docker_registry/install.sh
```