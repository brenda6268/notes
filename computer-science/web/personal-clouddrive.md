# 云时代的个人存储搭建


wp_id: 602
Status: publish
Date: 2019-02-16 22:27:00
Modified: 2020-05-16 11:04:45


昨天想用 iPad 上的 GoodReader 看一本书，但是从 iCloud 同步的时候出了些问题，进度始终为零。由于国内糟糕的网络环境，这种同步失败的问题时有发生。虽然可以直接通过 WiFi 把书从电脑上传过来，但是因为偶尔需要在另一个 iPad 上查看，为了同步进度，还是最终决定还是自己搭建一套云存储设施。

# ftp 与 webdav

ftp 协议有诸多问题，现在用的已经很少了。WebDav 协议基于 HTTP，相比 FTP 有不少有点，可以参见文章1。另外不少开源的网盘客户端也支持 webdav。NextCloud 支持 webdav，后面会讲到

# sftp 和 sshfs

sftp 则和 ftp 是完全独立的两个东西，虽然最终目的是一样的。好比海豚和鲨鱼都是在海里的生物，但是一个是哺乳动物，而一个是鱼类。sftp 基于 ssh 协议。

sshfs 相比 sftp 则更近了一步，通过 sftp 把远程的文件系统直接映射到本地，从而无缝衔接。

## 搭建

sftp 直接基于 linux 的用户和文件权限系统。

### 添加相应的用户和分组，以用户名 sftp，分组名 ftpaccess 为例。

```
% sudo groupadd ftpaccess
% sudo useradd -m sftp -g ftpaccess -s /usr/sbin/nologin
% sudo passwd sftp  # 更改密码
% sudo mkdir /var/sftp
% sudo chown root /var/sftp  # 这一步非常坑，切记不可省略，后面讲为什么
% sudo mkdir -p /var/sftp/files
% sudo chown sftp:ftpaccess /var/sftp/files
```

### 修改 /etc/ssh/sshd_config 文件

注释掉这一行 `Subsystem sftp /usr/lib/openssh/sftp-server`

然后在文件的结尾添加

```
Subsystem sftp internal-sftp
Match group ftpaccess
ChrootDirectory /var/sftp  # 这里可以随便指定你想要的顶级目录
X11Forwarding no
AllowTcpForwarding no
ForceCommand internal-sftp
PasswordAuthentication yes
```

ssh 的安全配置要求 ChrootDirectory 本身必须是 root 所有的，所以登录都的根目录我们是不可写的，但是可以在新建的目录中读写。

### 重启 ssh 服务

```
% sudo systemctl restart ssh
```

可以使用客户端链接啦~ 如果需要使用 publickey 登录的话，只需要像普通的用户一样，把文件传到 ~sftp 的对应目录就可以了。

### 使用 sshfs mount 到本地

```
% brew install sshfs
% brew cask install osxfuse
% sshfs -o allow_other,defer_permissions -o volname=sftp_files sftp@your.example.com:/files $HOME/sftp_files
```

![](https://ws3.sinaimg.cn/large/006tKfTcly1g09iu47ttpj30i207cabm.jpg)

# nextcloud

未完待续


# 参考资料
1. https://stackoverflow.com/questions/11216884/which-file-access-is-the-best-webdav-or-ftp
2. [SSHFS](https://github.com/osxfuse/osxfuse/wiki/SSHFS)
3. [搭建 sftp 服务器](https://askubuntu.com/questions/420652/how-to-setup-a-restricted-sftp-server-on-ubuntu)
4. [sftp 的一个坑](https://www.minstrel.org.uk/papers/sftp/builtin/)