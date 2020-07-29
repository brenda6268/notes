# 什么是倒排索引？

<!--
ID: cdaf09e6-b855-4384-9eb4-2d9bf758ea6c
Status: draft
Date: 2017-05-29T15:33:00
Modified: 2020-05-16T12:10:04
wp_id: 453
-->

以英文为例，下面是要被索引的文本：

```
T0= "it is what it is"
T1= "what is it"
T2= "it is a banana"
```

我们就能得到下面的反向文件索引：

```
"a":      {2}
"banana": {2}
"is":     {0, 1, 2}
"it":     {0, 1, 2}
"what":   {0, 1}
```

检索的条件"what", "is" 和 "it" 将对应这个集合：`{0, 1} ∩ {0, 1, 2} ∩ {0, 1, 2} = {0, 1}`