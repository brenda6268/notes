# squid proxy

<!--
ID: b3662d8a-8a5b-444a-82ad-e53ba12e8d60
Status: publish
Date: 2017-06-20T15:22:00
Modified: 2017-06-20T15:22:00
wp_id: 450
-->

# Install squid
plain old `apt-get update && apt-get install squid3 apache2-utils -y`

# Basic squid conf
`/etc/squid3/squid.conf` instead of the super bloated default config file

```
# note that on ubuntu 16.04, use squid instead of squid3
auth_param basic program /usr/lib/squid3/basic_ncsa_auth /etc/squid3/passwords
auth_param basic realm proxy
acl authenticated proxy_auth REQUIRED
http_access allow authenticated
forwarded_for delete
http_port 0.0.0.0:3128
```

Please note the `basic_ncsa_auth` program instead of the old `ncsa_auth`

# Setting up a user
`sudo htpasswd -c /etc/squid3/passwords username_you_like`, *on 16.04, it's squid, not squid3*
and enter a password twice for the chosen username then
`sudo service squid3 restart`

see: https://stackoverflow.com/questions/3297196/how-to-set-up-a-squid-proxy-with-basic-username-and-password-authentication

# centos
I have to use centos, since adsl providers are not capable of providing ubuntu

check out this wonderful article: https://hostpresto.com/community/tutorials/how-to-install-and-configure-squid-proxy-on-centos-7/

```
yum install -y epel-release
yum install -y squid
yum install -y httpd-tools
```

```
systemctl start squid
systemctl enable squid
touch /etc/squid/passwd && chown squid /etc/squid/passwd
htpasswd -c /etc/squid/passwd root
```

edit `/etc/squid/squid.conf`

```
auth_param basic program /usr/lib64/squid/basic_ncsa_auth /etc/squid/passwd
auth_param basic children 5
auth_param basic realm Squid Basic Authentication
auth_param basic credentialsttl 2 hours
acl auth_users proxy_auth REQUIRED
http_access allow auth_users
http_port 3128
```

一个小问题

squid 默认只允许代理 443 端口的https流量，而会拒绝对其他端口的connect请求。需要更改配置文件

To fix this, add your port to the line in the config file:
acl SSL_ports port 443
so it becomes
acl SSL_ports port 443 4444
squid 默认还禁止了除了443之外的所有connect 
deny CONNECT !SSL_Ports  # 删掉这一句