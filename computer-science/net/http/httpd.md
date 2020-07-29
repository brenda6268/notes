# 编写 httpd 的计划

<!--
ID: 45237b0c-546c-433a-bb35-40e7b111bf18
Status: draft
Date: 2018-06-22T08:06:00
Modified: 2020-05-16T11:11:53
wp_id: 586
-->

阅读书籍/课程

CSAPP
TCP/IP Sockets编程
TCP/IP 详解
C专家编程
APUE


参考项目

tinyhttpd


参考文章/协议

http://stackoverflow.com/questions/176409/build-a-simple-http-server-in-c

RFC 7230,
RFC 7231 
RFC 7232,
RFC 7233,
RFC 7234,
RFC 7235


路线图

v0.1

blocking with` bind listen connect`
single threaded
only support GET method

+∞

support python wsgi

![](https://ws1.sinaimg.cn/large/006tNc79gy1fsk0qkwd8tj30k40f0t9u.jpg)