# sudo passwordless


ID: 427
Status: publish
Date: 2017-06-30 13:51:00
Modified: 2017-06-30 13:51:00


```
$ EDITOR=vi visudo

# then add this

ALL ALL=(ALL) NOPASSWD: ALL
username ALL=(ALL) NOPASSWD: ALL
%group ALL=(ALL) NOPASSWD: ALL
Defaults env_keep += "EDITOR"
```