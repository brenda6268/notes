# nginx 内部实现

<!--
ID: 660f2589-9d4e-42c1-934e-2221c3888043
Status: draft
Date: 2020-07-29T19:51:32
Modified: 2020-07-29T19:51:32
wp_id: 1101
-->

使用了 epoll
可以使用 SO_REUSEPORT 避免惊群问题