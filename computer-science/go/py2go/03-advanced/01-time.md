# 无标题

<!--
ID: f2f3de94-ba8e-4ce9-a044-d523d307c494
Status: draft
Date: 2019-11-25T00:00:00
Modified: 2020-05-28T14:09:32
wp_id: 1146
-->

这简直是 golang 人为制造的一个坑。在这里我不花时间去看奇葩的标准库了，直接用第三方的库好了。

第三方时间解析库

1. https://github.com/jinzhu/now 用来生成当前时间段的开始或者结束，比如当前月的第一天，当前月的最后一天等。
2. https://github.com/araddon/dateparse 解析任意时间格式，无需指定时间 Layout。
3. https://github.com/jehiah/go-strftime 类似所有其他语言的 strftime 包。