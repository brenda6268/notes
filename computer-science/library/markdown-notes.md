# markdown notes

<!--
ID: 1b09e105-ab90-4779-bf36-c55811471009
Status: publish
Date: 2017-05-30T12:52:00
Modified: 2017-05-30T12:52:00
wp_id: 623
-->

## Table

```
| Tables        | Are           | Cool  |
| ------------- |:-------------:| -----:|
| col 3 is      | right-aligned | $1600 |
| col 2 is      | centered      |   $12 |
| zebra stripes | are neat      |    $1 |
```
There must be at least *3 dashes* separating each header cell. The outer pipes (|) are optional, and you don't need to make the raw Markdown line up prettily. You can also use inline Markdown.

```
Markdown | Less | Pretty
--- | --- | ---
*Still* | `renders` | **nicely**
1 | 2 | 3
```

可以使用冒号来对齐单元格

## 图片

```
Inline-style: 
![alt text](https://github.com/adam-p/markdown-here/raw/master/src/common/images/icon48.png "Logo Title Text 1")
Reference-style: 
![alt text][logo]
[logo]: https://github.com/adam-p/markdown-here/raw/master/src/common/images/icon48.png "Logo Title Text 2"
```

## 横线

```
Three or more...
---
Hyphens
***
Asterisks
___
Underscores
```