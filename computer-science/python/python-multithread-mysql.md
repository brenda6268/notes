# Python 中如何多线程使用 MySQL

<!--
ID: bf2e51fd-5a6c-4add-a793-30e5fd37d3cd
Status: draft
Date: 2019-06-16T17:53:39
Modified: 2020-05-16T10:54:28
wp_id: 185
-->

- MySQL 中没有 cursor 的概念,但是 Python的数据库 API 中规定了 cursor 的概念, 所以Python

    客户端中的 cursor 是本地的, 不会消耗服务器上的资源, 关不关闭没有问题.

- MySQL Connection 不能多线程共享



## 参考资料

1. https://stackoverflow.com/questions/45636492/can-mysqldb-connection-and-cursor-objects-be-safely-used-from-with-multiple-thre
2. https://stackoverflow.com/questions/8099902/should-i-reuse-the-cursor-in-the-python-mysqldb-module
3. https://stackoverflow.com/questions/5669878/when-to-close-cursors-using-mysqldb
4. https://stackoverflow.com/questions/34530940/why-arent-cursors-optional-in-mysqlclient