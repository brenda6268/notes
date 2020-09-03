# 在 Ubuntu 上安装 MySQL

<!--
ID: 774d9784-3880-45bc-a3b7-d3b6abc41b6b
Status: publish
Date: 2018-06-15T15:09:32
Modified: 2020-05-16T11:40:11
wp_id: 87
-->

安装

```
apt -y install mysql-server
```

默认账号密码：

```
cat /etc/mysql/debian.cnf
```

需要把 ubuntu 绑定地址改为 0.0.0.0。在 /etc/mysql/mysql.conf.d/mysqld.cnf 中注释掉 bind-address=127.0.0.1 行

开启 root 的远程登录：

```
GRANT ALL PRIVILEGES ON *.* TO 'root'@'%' IDENTIFIED BY 'password';
```
