# ssh tutorial

<!--
ID: 2b7a7b5e-4198-4cf8-9ddb-8f68b8a8e5f6
Status: draft
Date: 2017-05-30T01:21:00
Modified: 2020-05-16T12:10:33
wp_id: 596
-->

## 配置文件

路径: `~/.ssh/config`

权限必须设置成: `.ssh/` 700，`.ssh/authorized_keys` 600, `.ssh/config` 600

### 添加一个 host 到配置中

```
Host HOSTNAME or *
    HostName  
    Port           
    User          
    IdentityFile    
    ServerAliveInterval    240
```

这样就可以直接 `ssh HOSTNAME` 了

## ssh command line

```
ssh [-i Identitty_file] [-o options] username@host [command]

StrictHostKeyChecking=no # sets check host key to false

```

## other

mosh is a drop-in replacement for ssh. `mosh --server=~/bin/mosh-server user@remote-host`

when copying files from remote host A to remote host B, you use `ssh -3`

use `ssh-keygen` and `ssh-copy-id`, do not manually copy id_rsa.pub to remote host.

## Gotchas

`error: key_read: uudecode` may be caused by disk full.