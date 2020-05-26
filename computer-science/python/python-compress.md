# Python 中如何压缩文件


ID: 668
Status: publish
Date: 2018-06-22 14:02:00
Modified: 2020-05-16 11:14:01


basic usage

import gzip/bz2
with gzip.open('file.gz', 'rt') as f:
    text = f.read()

NOTE: the default mode is binary.