# 在 Ubuntu 上安装 MySQL

<!--
ID: 774d9784-3880-45bc-a3b7-d3b6abc41b6b
Status: publish
Date: 2018-06-15T15:09:32
Modified: 2020-05-16T11:40:11
wp_id: 87
-->

安装

```sh
apt -y install mysql-server
```

默认账号密码：

```sh
cat /etc/mysql/debian.cnf
```

或者直接通过 `sudo mysql` 就可以进去。这是因为默认情况下 root 用户是通过 sudo 来校验的，而不需要密码，我们可以改成通过密码校验的方式：

```sql
ALTER USER 'root'@'localhost' IDENTIFIED WITH mysql_native_password BY '';
FLUSH PRIVILEGES;
```

需要把 ubuntu 绑定地址改为 0.0.0.0。在 /etc/mysql/mysql.conf.d/mysqld.cnf 中注释掉 bind-address=127.0.0.1 行

开启 root 的远程登录：

```sh
GRANT ALL PRIVILEGES ON *.* TO 'root'@'%' IDENTIFIED BY 'password';
```
