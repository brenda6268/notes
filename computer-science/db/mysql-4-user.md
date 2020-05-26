# mysql 基础知识(4) - 用户和权限


ID: 177
Status: publish
Date: 2017-11-13 17:25:23
Modified: 2020-05-16 11:53:03


## 创建用户

```
CREATE USER &#039;newuser&#039;@&#039;%&#039; IDENTIFIED BY &#039;password&#039;;
```

## 授权

```
GRANT ALL PRIVILEGES ON *.* TO &#039;newuser&#039;@&#039;%&#039;;
```

其中的 `%` 代表这个用户可以在任意主机登录.

```
SHOW GRANTS FOR newuser
```
用来显示一个用户的当前授权

```
set password for USERNAME = password(&#039;xxx&#039;)
```
更改用户密码

## 重置密码

```
sudo mysqld_safe --skip-grant-tables --skip-networking &amp;
 
use mysql;
update user set authentication_string=PASSWORD(&quot;&quot;) where User=&#039;root&#039;;
update user set plugin=&quot;mysql_native_password&quot;; # THIS LINE
flush privileges;
quit;
```

## 其他问题

EXPLAIN, slow-log