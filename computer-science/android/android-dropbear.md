# 为安卓编译64位的dropbear


wp_id: 533
Status: publish
Date: 2017-11-15 05:13:00
Modified: 2020-05-16 11:54:39


## 如何使用dropbear

这里主要是需要在安卓上生成 host key，以及把自己的公钥传到安卓上

```
dropbearkey -t rsa -f /data/local/dropbear_host_key # 在安卓上生成key
adb push ~/.ssh/id_rsa.pub /data/local/authorized_keys # 在宿主机把自己的密钥传过去
dropbear -F -E -r /data/local/dropbear_host_key -A -N root -C jk -R /data/local/authorized_keys # 按照给定的key启动dropbear
dropbear -P /data/local/dropbear.pid -r /data/local/dropbear_host_key -A -N root -C jk -R /data/local/authorized_keys # 以daemon形式启动dropbear
```

## 如何为64位的安卓机器编译 dropbear

需要更改如下代码（svr-chansession.c）:

```
addnewvar("LD_LIBRARY_PATH", "/system/lib");

to:

addnewvar("LD_LIBRARY_PATH", "/system/lib64");
```

## 使用AIL把dropbear添加为服务

```
service sshd /system/xbin/dropbear -s
   user  root
   group root
   oneshot
```
试过了，但是没有成功

## 如何重启adb(wifi)

```
setprop service.adb.tcp.port 5555
stop adbd
start adbd
```

# 关闭 ssh key 验证

```
Host *
    StrictHostKeyChecking no
```

mount -o remount,rw /system




## 参考

1. http://forum.xda-developers.com/nexus-7-2013/general/guide-compiling-dropbear-2016-73-t3351671
2. http://forum.xda-developers.com/nexus-7-2013/general/guide-compiling-dropbear-2015-67-t3142412/page3