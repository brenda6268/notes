# Linux 命令行账户管理

<!--
ID: dbe6fff1-1408-41a6-a1ae-0539e985c405
Status: publish
Date: 2017-05-29T12:40:00
Modified: 2020-05-16T12:08:00
wp_id: 432
-->

执行 `sudo vi /etc/suduers`, 然后输入：

`username ALL=(ALL) NOPASSWD: ALL`


```
useradd -m USERNAME  # add a user
userdel USERNAME  # delete a user
passwd -e  # password expire next time user login

groups username  # view username groups
usermod -G groupname username  # add user to a group
usermod -g groupname username # set user to a group

newgrp
make newly added group work immediately without login/out
```

chsh 提示输入密码的问题

```
Changing /etc/pam.d/chsh: from:

auth       required   pam_shells.so
to

auth       sufficient   pam_shells.so
```
