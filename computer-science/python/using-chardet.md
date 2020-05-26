# 使用 Chardet 自动检测文本编码


ID: 642
Status: publish
Date: 2017-06-02 06:23:00
Modified: 2020-05-16 12:03:56


python 中的 chardet 库可以用来猜测文件的编码



# usage

```
pip install cchardet
```

```
In [1]: import cchardet as chardet

In [2]: chinese_bytes = &#039;中文&#039;.encode(&#039;utf-8&#039;)

In [3]: chardet.detect(chinese_bytes)
Out[3]: {&#039;confidence&#039;: 0.7524999976158142, &#039;encoding&#039;: &#039;UTF-8&#039;}
```