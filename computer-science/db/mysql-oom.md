# 解决小内存机器 MySQL 总是 OOM 的问题


ID: 173
Status: publish
Date: 2017-11-13 16:52:49
Modified: 2020-05-16 11:52:54


有一台512M内存的小机器总是报数据库错误, 查看了下日志是OOM了

解决方案:

一 Add swap file to cloud instance

http://www.prowebdev.us/2012/05/amazon-ec2-linux-micro-swap-space.html

1. Run dd if=/dev/zero of=/swapfile bs=1M count=1024
2. Run mkswap /swapfile
3. Run swapon /swapfile
4. Add this line /swapfile swap swap defaults 0 0 to /etc/fstab  

Some useful command related to SWAP space:

```
$ swapon -s   
$ free -k
$ swapoff -a
$ swapon  -a
```
	
二 limit mysql buffersize

innodb_buffer_pool_size = 8M
	
三 limit apache memory cosumption，editing /etc/apache2/mods-enabled/mpm_prefork.conf

```	
&lt;IfModule mpm_prefork_module&gt;
    StartServers        3
    MinSpareServers     3
    MaxSpareServers     5
    MaxRequestWorkers   25
    MaxConnectionsPerChild  0
&lt;/IfModule&gt;
```