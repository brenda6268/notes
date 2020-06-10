# Linux 磁盘管理命令

wp_id: 610
Status: publish
Date: 2018-04-04 04:29:00
Modified: 2020-05-16 11:32:00

## 挂载磁盘

`mount` 命令，用于挂载磁盘以及显示相关信息

```
mount 显示挂载信息
mount -t TYPE OPTIONS DEVICE DIRECTORY
比如：
     mount -t vfat /dev/sdb1 /mnt/media
```

常用的参数

```
-a 挂载/etc/fstab 中的所有文件
-f 模拟挂载
-r 只读挂载
-w 读写挂载（默认）
-L 指定 lebel
-u 指定 uuid
-o 选项
    ro 只读
    rw 读写
    user 允许普通用户挂载
    check=none 不检查错误
    loop 挂载文件，比如 iso
    nofail 失败了也不要汇报
    remount
--bind 选择新的挂载点作为 alias &#x60;mount --rbind olddir newdir&#x60;
--move 移动到新的挂载点 &#x60;mount --move olddir newdir&#x60;
```

使用 mount 命令的最佳实践是在 `/etc/fstab` 中先输入需要挂载的磁盘对应的配置，然后使用 `mount -a` 挂载。这样避免在 `/etc/fstab` 中挂载的命令是错的导致无法开机。

## 卸载

umount DIRECTORY/DEVICE 卸载设备

## 磁盘使用

* 查看分区的 uuid：ll /dev/disk/by-uuid。在 `etc/fstab` 中挂载磁盘最好使用 uuid
* 查看分区的类型：parted -l
* df show free disk spaces
* du show disk usage infomation。du -sh `ls`  # great command
* dd disk dump

## 分区与格式化

fdisk DEVICE

```	
p	print partition table
n	new partition
w	write back to table
d	删除分区
```
	
创建文件系统

```
mkfs.ext4 PARTITION
```

fsck check a file system

## 逻辑卷

硬盘称作物理卷，多个物理卷构成一个卷组，一个卷组可以分成多个逻辑卷