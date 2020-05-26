# 如何快速删除文件


ID: 59
Status: publish
Date: 2019-06-15 14:48:59
Modified: 2020-05-16 11:00:28


<!-- wp:paragraph -->
<p>
没想到使用 rm -rf 删除 700 多 G文件竟然会卡住。还必须使用特殊的技巧来快速删除文件。
</p>
<!-- /wp:paragraph -->

<!-- wp:paragraph -->
<p>
rsync -a –delete empty/ your_folder/
</p>
<!-- /wp:paragraph -->

<!-- wp:paragraph -->
<p>
参考
</p>
<!-- /wp:paragraph -->

<!-- wp:paragraph -->
<p><a href="https://unix.stackexchange.com/questions/37329/efficiently-delete-large-directory-containing-thousands-of-files">https://unix.stackexchange.com/questions/37329/efficiently-delete-large-directory-containing-thousands-of-files</a></p>
<!-- /wp:paragraph -->