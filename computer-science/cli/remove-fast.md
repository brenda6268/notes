# 如何快速删除文件

<!--
ID: b30ac2f1-6cb8-4d6e-9970-da1ffb307edd
Status: publish
Date: 2019-06-15T14:48:59
Modified: 2020-05-16T11:00:28
wp_id: 59
-->

没想到使用 rm -rf 删除 700 多 G 文件竟然会卡住。还必须使用特殊的技巧来快速删除文件。

rsync -a –delete empty/ your_folder/

参考

https://unix.stackexchange.com/questions/37329/efficiently-delete-large-directory-containing-thousands-of-files
