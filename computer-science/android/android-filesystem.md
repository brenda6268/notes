# 安卓的文件系统

<!--
ID: 3224fcac-943b-43f4-87ab-a342a0dfa17e
Status: publish
Date: 2017-05-29T13:39:00
Modified: 2020-05-16T12:08:19
wp_id: 527
-->

let's assume `/system` is the rom folder

| Partition   | Explanation               |
|---------|---------------------------|
| /boot       | kernel & Co.              |
| /cache      | app cache                 |  
| /data       | user data partition¹      |  
| /data/data  | app data¹                 |  
| /dev        | devices, virtual fs       |  
| /mnt/asec   | encrypted apps (App2SD)   |  
| /mnt/emmc   | internal sdcard³          |  
| /mnt/sdcard | external sdcard³          |  
| /proc       | process information²      |  
| /recovery   | used in recovery mode     |  
| /system     | system ROM (read-only)    |  

`/data` and `/data/data`
------

These are in most cases two separate partitions, but there might be cases where this is handled otherwise. One thing they have in common (add /cache here as well): they get wiped on a factory-reset, while the other partitions are usually left untouched by that.


| Directory          | Explanation                                  |  
|--------------------|----------------------------------------------|
| /data/anr          | traces from app crashes (App Not Responding) |  
| /data/app          | .apk files of apps installed by the user     |  
| /data/backup       | Googles Cloud-Backup stuff                   |  
| /data/dalvik-cache | optimized versions of installed apps¹        |  
| /data/data         | app data²                                    |  
| /data/local        | temporary files from e.g. Google Play³       |  
| /data/misc         | system configuration (WiFi, VPN, etc.)       |  
| /data/system       | more system related stuff (certs, battstat)  |  
| /data/tombstones   | more crash stuff ("core dumps")              |  
| /data/user         | multi-user support, /data/user/0 is a symlink to /data/data|


Reference
------

[1] http://android.stackexchange.com/questions/46926/android-folder-hierarchy
[2] http://android.stackexchange.com/questions/48393/what-kind-of-data-is-stored-in-data-user-directory