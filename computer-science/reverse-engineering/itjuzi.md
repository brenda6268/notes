# IT桔子逆向实战


ID: 196
Status: publish
Date: 2019-06-23 10:12:30
Modified: 2020-05-16 10:53:36


## 使用 jadx 反编译

首先，我们到豌豆荚下载最新的 APK。然后执行 `jadx-gui itjuzi.apk`。很遗憾发现加壳了，应该是百度的壳，我们先跳过，去找一个老版本，看看有没有没加过壳的。

![](https://yifei.me/wp-content/uploads/2019/06/WX20190623-094348@2x.png)

很遗憾，没有找到不带壳的版本，所以我们需要进行脱壳

## 脱壳

阅读了[这篇文章][1]，我们知道凡是脱壳都会有两个步骤，一个是找到原始的 classes.dex 文件，一个是修复这个 dex 文件。

> 首先，我们知道动态加载的dex必然会调用dalvik/vm/DvmDex.cpp中以下两个函数任意一个:
> 1. dvmDexFileOpenFromFd  从文件描述符获取DexFile结构体
> 2. dvmDexFileOpenPartial    从内存获取DexFile结构体

通过编写函数可以把这个 dex 文件 dump 出来，但是这个函数运行在哪儿呢？

未完待续。。



[1] https://bbs.pediy.com/thread-218891.htm