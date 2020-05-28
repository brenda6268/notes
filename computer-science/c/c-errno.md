# C语言中的 errno


wp_id: 409
Status: draft
Date: 2017-05-29 15:04:00
Modified: 2020-05-16 12:09:27


在c的最初定义中errno是一个全局变量，但是在实际的实现中errno是一个线程本地的变量threadlocal
通常的使用模式是：

函数返回0表示成功，返回非0表示失败，同时设置errno变量