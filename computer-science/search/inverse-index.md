# 什么是倒排索引？


ID: 453
Status: draft
Date: 2017-05-29 15:33:00
Modified: 2020-05-16 12:10:04


以英文为例，下面是要被索引的文本：

```
T0= &quot;it is what it is&quot;
T1= &quot;what is it&quot;
T2= &quot;it is a banana&quot;
```

我们就能得到下面的反向文件索引：

```
&quot;a&quot;:      {2}
&quot;banana&quot;: {2}
&quot;is&quot;:     {0, 1, 2}
&quot;it&quot;:     {0, 1, 2}
&quot;what&quot;:   {0, 1}
```

检索的条件"what", "is" 和 "it" 将对应这个集合：`{0, 1} ∩ {0, 1, 2} ∩ {0, 1, 2} = {0, 1}`