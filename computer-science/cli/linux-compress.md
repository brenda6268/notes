# Linux 命令行压缩工具


ID: 425
Status: draft
Date: 2017-06-12 00:06:00
Modified: 2020-05-16 12:04:51


压缩文件主要分四类：

1. tar.gz 或者 tgz 文件
2. zip 文件
3. rar 文件
4. 7z 文件

# zip 文件

`zip -r ZIPFILE DIRECTORY` to zip a directory

`zip -r ZIPFILE DIRECTORY -x "*.git*"` exclude the .git directory

`zip -l ZIPFILE` list the files

# 7z 文件

安装对应工具

```
apt-get install p7zip-full
```

解压缩

```
7z x some.7z
```