# C语言中已经废弃的函数

<!--
ID: 160dece2-0e48-4ea1-b25e-c618c4767110
Status: publish
Date: 2017-05-29T01:09:00
Modified: 2020-05-16T12:07:34
wp_id: 400
-->

由于安全性原因，C 标准库中的不少函数已经被废弃了，同时增加了对应的替换函数。

```
sprintf --> snprintf
gets --> fgets
strcat --> strncat
strcpy --> strncpy
```

`strtok`函数用于分解字符串，需要一个变量保存内部分解进度
`strtok_r`是它的可重入版本