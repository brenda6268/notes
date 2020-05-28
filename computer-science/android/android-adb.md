# 安卓的adb工具与命令行


wp_id: 529
Status: publish
Date: 2017-05-29 12:45:00
Modified: 2020-05-16 12:08:09


## Yifei's Notes

adb is pretty unstable, it's meant for debug usage, NOT for a long-running service.


## Install

install on ubuntu: `apt-get install android-tools-adb android-tools-fastboot`

install on mac: `brew install android-platform-tools`


## Connect model


there is a server on PC called adb server, if not started, will be started on first adb client call commands. there is an adbd daemon on phone, run as not root by default.

## adb devices

list all devices, give serial number for usb, and ip:port for wifi devices as adb id. if only one device, all commands are issued to that device, if many, use adb -s <adb-id> command to select a device.

## Connect over Wifi

1. first usb adb to the device
2. second

if rooted and run this on phone

```sh
su
setprop service.adb.tcp.port 5555
stop adbd && start adbd
```
    
if not rooted and run this on computer

```
adb tcpip 5555
```

3. `adb connect ip:port`
4. `adb usb`  # back to usb mode

## pull/push

`adb pull phone_path pc_path`
`adb push pc_path phone_path`

## install/uninstall

```
adb install 
adb uninstall
adb shell pm clear PACKAGE_NAME  # clears package data
```

## forward

```
adb forward local:port android:port
adb wait-for-device
```

`adb forward host device`
`adb forward tcp:6100 tcp:7100`

## remount

remounts the /system, /vendor (if present) and /oem (if present) partitions on the device read-write



## get running activity name 

`adb shell dumpsys activity | grep mFocusedActivity`


pm
setprop/getprop
netcfg
screencap
screenrecord

error closed

可能是权限不够，执行了n权限过高的操作，需要首先执行 adb root

能用 ssh，就用 ssh ，不要用 adb

## Android Shell Command

https://github.com/jackpal/Android-Terminal-Emulator/wiki/Android-Shell-Command-Reference
http://forum.xda-developers.com/showthread.php?t=1694251 
http://forum.xda-developers.com/wiki/Guide%3aUsing_the_Terminal#SSHD
http://www.kpbird.com/2013/05/android-shell-command-pm-package-manager.html

termux

## 32 bit adb 在64位linux上无法运行

The error message is no such file of directory, which is quite miss-leading

## adb install 安装失败

apk 没有权限  应该777
apk 有证书不一致的 卸载旧的apk


## Configuator 设置 uiautomator 的超时时间，参见[1]

[1] https://developer.android.com/reference/android/support/test/uiautomator/Configurator.html


从手机上拉取已安装应用的apk文件

```
adb shell pm path com.example.someapp
adb pull /data/app/com.example.someapp-2.apk
```