# 如何让安卓手机插上电源自动开机

<!--
ID: 9ce86f28-8b3d-468c-8d46-0fb9a1b32937
Status: publish
Date: 2017-05-30T03:10:00
Modified: 2020-05-16T11:58:21
wp_id: 543
-->

非常简单的原理，把充电电池动画文件替换成重启命令。

比如说，对于红米 Note2，这个文件是 `/system/bin/kpoc_charger`

替换成如下文件

```sh
#!/system/bin/sh
/system/bin/reboot
```

然后 `chmod +x /system/bin/kpoc_charger`




http://developwear.com/blog/2014/07/03/autobootstart-android-when-charger-is-connected/