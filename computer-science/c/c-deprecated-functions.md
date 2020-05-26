# C语言中已经废弃的函数


ID: 400
Status: publish
Date: 2017-05-29 01:09:00
Modified: 2020-05-16 12:07:34


由于安全性原因，C 标准库中的不少函数已经被废弃了，同时增加了对应的替换函数。

```
sprintf --&gt; snprintf
gets --&gt; fgets
strcat --&gt; strncat
strcpy --&gt; strncpy
```

`strtok`函数用于分解字符串，需要一个变量保存内部分解进度
`strtok_r`是它的可重入版本