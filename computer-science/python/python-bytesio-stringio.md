# Python 中的 bytesio/stringio


ID: 656
Status: publish
Date: 2017-05-30 01:46:00
Modified: 2020-05-16 12:10:49


Python 中的io 包提供了 BytesIO 和 StringIO，分别可以把一个对象作为一个内存中的二进制文件和文本文件，除了文件的read/write/readline等操作外，支持 getvalue 操作。


```
import io
f = io.BytesIO()
f.write(b&#039;hello&#039;)  # 二进制文件只能写 b&#039;xxx&#039;
f.getvalue()
f.read(4)
```