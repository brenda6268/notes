# Zsh 的小问题

<!--
ID: 65953a32-e77c-4cc7-8fd7-55a91d90a9dc
Status: draft
Date: 2020-10-26T17:40:56
Modified: 2020-10-26T17:40:56
wp_id: 2112
-->

当 PATH 中存在不存在的目录，而且系统中存在 NFS 的时候会导致 zsh 非常慢，解决方法是把不存在的路径去掉就好了。

zshrc 必须是 unix 文件，如果出现 git_prompt_info 错误，使用 vim set ff=unix 就可以了。

zsh 提示 zsh compinit: insecure directories, run compaudit for list. 使用 `sudo chmod -R 755 /usr/local/share/zsh/site-functions`