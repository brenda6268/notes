# 使用 Chardet 自动检测文本编码

<!--
ID: 42d2fc8f-467c-4ebb-a50b-8345fb9238d2
Status: publish
Date: 2017-06-02T06:23:00
Modified: 2020-05-16T12:03:56
wp_id: 642
-->

python 中的 chardet 库可以用来猜测文件的编码

## usage

```
pip install cchardet
```

```ipython
In [1]: import cchardet as chardet

In [2]: chinese_bytes = "中文".encode("utf-8")

In [3]: chardet.detect(chinese_bytes)
Out[3]: {"confidence": 0.7524999976158142, "encoding": "UTF-8"}
```
