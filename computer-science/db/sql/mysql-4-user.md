# mysql 基础知识 (4) - 用户和权限

<!--
ID: 44d77455-57ac-4476-8e4b-f285361f6c45
Status: publish
Date: 2017-11-13T17:25:23
Modified: 2020-05-16T11:53:03
wp_id: 177
-->

创建用户

```sql
CREATE USER "newuser"@"%" IDENTIFIED BY "password";
```

授权所有权限

```sql
GRANT ALL PRIVILEGES ON *.* TO "newuser"@"%";
```

其中的 `%` 代表这个用户可以在任意主机登录。

如果只需要在本机登录，使用 `localhost`

显示一个用户的当前授权：

```sql
SHOW GRANTS FOR newuser
```

更改用户密码：

```sql
ALTER USER 'userName'@'localhost' IDENTIFIED BY 'New-Password-Here';
```

## 重置密码

```sql
sudo mysqld_safe --skip-grant-tables --skip-networking &amp;
 
use mysql;
update user set authentication_string=PASSWORD("") where User="root";
update user set plugin="mysql_native_password"; # THIS LINE
flush privileges;
quit;
```

## 其他问题

EXPLAIN, slow-log
