# Python 转义 html 实体字符

<!--
ID: c82d042c-d200-45f1-9552-db70ecc5651d
Status: publish
Date: 2018-06-22T10:21:00
Modified: 2020-05-16T11:13:43
wp_id: 687
-->

在网页中经常出现 `<`, `&amp;`, `&0x0026;` 这些特殊字符，这是 html 实体字符转义，用于防止 XSS 攻击。Python3 标准库中包含了 html.entities 模块，可以用于转义和反转义这些字符。

```py
html.entities.entitydefs 中包含了名称到符号的映射：比如{"amp": "&amp;"}
html.entities.name2codepoint 中包含了名称到数字的映射：比如 {"amp": 0x0026}
html.entities.codepoint2name 中包含了数字到名称的映射：比如 {0x0026: "amp"}
```