# sudo passwordless

<!--
ID: bab4f695-79f7-457b-b102-6a860f4daa45
Status: publish
Date: 2017-06-30T13:51:00
Modified: 2017-06-30T13:51:00
wp_id: 427
-->

```sh
$ EDITOR=vi visudo

# then add this

ALL ALL=(ALL) NOPASSWD: ALL
username ALL=(ALL) NOPASSWD: ALL
%group ALL=(ALL) NOPASSWD: ALL
Defaults env_keep += "EDITOR"
```
