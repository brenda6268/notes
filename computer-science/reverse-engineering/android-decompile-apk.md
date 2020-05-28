# Android 反汇编 APK


wp_id: 195
Status: publish
Date: 2017-05-29 22:47:05
Modified: 2020-05-16 12:10:25


## 使用 jadx[1]

### 编译和安装 jadx

```
mkdir jadx
git clone https://github.com/skylot/jadx.git
cd jadx
./gradlew dist   # you might need to wait on this
```

或者直接 `brew install jadx`

### decompile apk

1. change apk to zip file and unzip it
2. copy out the class.dex file
3. build/jadx/bin/jadx -d OUTDIR PATH_TO_CLASS.DEX or jadxgui PATH

## 工具

apk studio

如何 sign：https://www.nevermoe.com/?p=373

smali code tutorial： https://forum.xda-developers.com/showthread.php?t=2193735

一篇很好的pdf的文档，利用smali code：http://www.security-assessment.com/files/documents/whitepapers/Bypassing%20SSL%20Pinning%20on%20Android%20via%20Reverse%20Engineering.pdf


安卓中 pinning 的原理

使用自己的keystore实例化 TrustManagerFactory

关键语句

InputStream in = resources.openRawResource(certificateRawResource);//file name of res/raw keyStore = KeyStore.getInstance("BKS"); keyStore.load(resourceStream, password);


http://fdwills.github.io/diary/2014/06/13/ssl-pinning.html


一些现成的 工具

https://github.com/ac-pm/SSLUnpinning_Xposed  xposed 插件，已测试不好用
https://github.com/iSECPartners/Android-SSL-TrustKiller 需要cydia


豌豆荚商店中有一个 xposed installer miui专版，使用这个可以很好地安装 xposed

之后安装

另一只种思路，找到，找到bks文件，替换掉，重新打包，签名

https://stackoverflow.com/questions/30708548/how-to-modify-the-data-in-the-assets-folder-in-existing-apk-programmatically



另外一些工具

https://github.com/ac-pm/Inspeckage

https://github.com/iSECPartners/Android-SSL-TrustKiller  需要cydia

https://github.com/iSECPartners/android-ssl-bypass 一个基础工具，通过替换trust manager实现


arm 汇编教程

https://mp.weixin.qq.com/s/DKeXqzE6bj5t0eWTkLLCBQ




[1] http://www.jianshu.com/p/65c2f447946e