# Python 环境变量的一个坑

<!--
ID: fe647494-c555-487d-92b7-2274f771d664
Status: publish
Date: 2018-11-13T19:26:00
Modified: 2020-05-16T11:07:25
wp_id: 639
-->

Python 中可以使用 os.environ 操作环境变量，前几天看到了其他几个函数 os.getenv 和 os.putenv。然而 os.putenv 是一个大坑，os.putenv 之后，在后面的 os.getenv 中并不能读出来。囧

## 参考

1. https://mail.python.org/pipermail/python-list/2013-June/650294.html