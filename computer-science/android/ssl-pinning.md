# SSL Pinning 与破解


wp_id: 194
Status: publish
Date: 2017-06-22 22:45:28
Modified: 2020-05-16 11:44:02


## 什么是 SSL Pinning

To view https traffic, you could sign your own root CA, and perform mitm attack to view the traffic. HPKP (http public key pinning) stops this sniffing by only trust given CA, thus, your self-signed certs will be invalid. To let given app to trust your certs, you will have to modify the apk file.

## How to break it?
### Introducing Xposed

decompile, modify and then recompile the apk file can be very diffcult. so you'd better hook to some api to let the app you trying to intercept trust your certs. xposed offers this kind of ability. moreover, a xposed module called JustTrustMe have done the tedious work for you. just install xposed and JustTrustMe and you are off to go. Here are the detaild steps:

1. Install Xposed Installer

for android 5.0 above, use the xposed installer.

NOTE: 对于 MIUI，需要搜索 Xposed 安装器 MIUI 专版。

2. Install Xposed from xposed installer, note, you have to give root privilege to xposed installer

3. Install JustTrustMe