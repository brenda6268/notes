# Python 中如何压缩文件

<!--
ID: 0ba3d847-2f51-424b-b43f-bcaf5e02e13e
Status: publish
Date: 2018-06-22T14:02:00
Modified: 2020-05-16T11:14:01
wp_id: 668
-->

basic usage

```py
import gzip/bz2
with gzip.open('file.gz', 'rt') as f:
    text = f.read()
```

NOTE: the default mode is binary.