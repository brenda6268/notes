# Linux 下分区并挂载磁盘


wp_id: 426
Status: publish
Date: 2018-11-01 23:45:00
Modified: 2020-05-16 11:26:19


# 分区

```
parted -s -a optimal /dev/sda mklabel gpt -- mkpart primary ext4 1 -1s
```

# 创建文件系统

```
mkfs.ext4 /dev/sda1
```

# 查看分区结果

```
parted -l
```

# 复制数据

首先挂载到临时分区

```
mount /dev/sdb1 /mnt
```

把之前的数据考进去

```
# rsync -av /home/* /mnt/
OR
# cp -aR /home/* /mnt/
```

校验数据

```
diff -r /home /mnt
```

删除老数据

```
rm -rf /home/*
```

```
umount /mnt
```

# 挂载

```
mount /dev/sdb1 /home
```

写入到 fstab 中

```
blkid /dev/sdb1

/dev/sdb1: UUID="e087e709-20f9-42a4-a4dc-d74544c490a6" TYPE="ext4" PARTLABEL="primary" PARTUUID="52d77e5c-0b20-4a68-ada4-881851b2ca99"
```

在 /etc/fstab 中增加

```
UUID=e087e709-20f9-42a4-a4dc-d74544c490a6   /home   ext4   defaults   0   2
```

每一列的含义如下

```

    UUID – specifies the block device, you can alternatively use the device file /dev/sdb1.
    /home – this is the mount point.
    etx4 – describes the filesystem type on the device/partition.
    defaults – mount options, (here this value means rw, suid, dev, exec, auto, nouser, and async).
    0 – used by dump tool, 0 meaning don’t dump if filesystem is not present.
    2 – used by fsck tool for discovering filesystem check order, this value means check this device after root filesystem.
```

# 调整分区大小

首先使用 parted 打开对应的磁盘

```
tiger@iZ8vbe91kz7sqlvkjdu8p6Z:~$ sudo parted
GNU Parted 3.2
Using /dev/vda
Welcome to GNU Parted! Type "help" to view a list of commands.
(parted) select /dev/vdc
Using /dev/vdc
(parted) resizepart
Partition number? 1
Warning: Partition /dev/vdc1 is being used. Are you sure you want to continue?
Yes/No? yes
End?  [107GB]? 1100G
(parted) print
Model: Virtio Block Device (virtblk)
Disk /dev/vdc: 1100GB
Sector size (logical/physical): 512B/512B
Partition Table: msdos
Disk Flags:

Number  Start   End     Size    Type     File system  Flags
 1      1049kB  1100GB  1100GB  primary  ext4
```

然后使用 resize2fs 重新调整分区大小

```
resize2fs /dev/vdb1
```

# 参考



1. https://www.tecmint.com/move-home-directory-to-new-partition-disk-in-linux/
2. https://www.tecmint.com/parted-command-to-create-resize-rescue-linux-disk-partitions/