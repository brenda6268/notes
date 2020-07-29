# Linux 命令行文件管理

<!--
ID: a9e92bac-e10d-46bf-9c57-049fc2998715
Status: publish
Date: 2017-05-30T12:31:00
Modified: 2020-05-16T12:01:20
wp_id: 423
-->

## get current file path

```
#!/bin/bash 
# Absolute path to this script, e.g. /home/user/bin/foo.sh
SCRIPT=$(readlink -f "$0")
# Absolute path this script is in, thus /home/user/bin
SCRIPTPATH=$(dirname "$SCRIPT")
echo $SCRIPTPATH
```

这些程序基本都有一个模式：如果不给定文件作为参数，那么就从stdin读取，从 stdout 输出，非常适合 pipe，而且一般可以接受多个文件作为参数，并把结果合并

## ls

ls 的一个很好用的命令组合 `ls -sail`

## stat 和 file

stat 读取一个文件的所有信息，file 猜测文件的类型

## cat 

cat > fiie1 从标准输入读取并插入到file1
cat -ns file -n命令表示加入行号，-s 表示压缩多个空行到一个

## chattr

## find

### Syntax
```
find <dir> [!] <filter> <action>
```

### Filters
```
-name 	后面可以跟通配符
-wholename	
-regex 	Match on a whole path -iregex 不区分大小写
-type 	文件类型 f 文件 d 目录 l 链接
-atime/mtime/ctime 	使用+-区分未来过去，可以使用的单位smhdw
-newer file 	比
-size 	后面跟大小可以使用ckMGTP
-user/-group/-nouser 	用户
-perm 	权限
-path 	在整个路径中，使用通配符
```

### Actions

执行的动作跟在-exec/-ok后面
```
find ... -exec command {} + .. # give all files combined to the command
find ... -exec command {} \; # give each file
```

### Tips

如果打印出绝对路径，使用find $PWD ...

### find with xargs

`find ... -print0 | xargs -0 ...`

A numeric mode is from one to four octal digits (0-7), derived by adding up the bits with values 4, 2, and 1. Omitted digits are assumed to be leading zeros. The first digit selects the set user ID (4) and set group ID (2) and restricted deletion or sticky (1) attributes. The second digit selects permissions for the user who owns the file: read (4), write (2), and execute (1); the third selects permissions for other users in the file's group, with the same values; and the fourth for other users not in the file's group, with the same values.

## 权限
Linux 文件的权限可以使用0-7的四个八进制数字代表, 由1/2/4三个数字相加而成. 省略的数字会被认为是按0打头的. 第一个数字设定了 set user ID(4), set group ID(2) 和 限制删除或者叫 sticky bit(1). 第二个数字设定了文件所有者的权限: read(4), write(2), execute(1). 第三个设定了文件所在组的权限