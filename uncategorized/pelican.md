# 使用 Pelican 写作

<!--
ID: c4fabefc-6353-4fa9-b66f-94d8592a0e58
Status: draft
Date: 2019-03-08T10:20:00
Modified: 2020-05-16T11:04:05
wp_id: 397
-->

开始使用 Pelican 作为写作工具.

Pelican 中每篇文章可以配置的属性有

- Title
- Tags
- Date
- Modified
- Status
- Category
- Author
- Authors
- Slug
- Summary
- Template
- Save_as
- Url

除了 title 属性之外, 其他的属性都是可选的, 比如说 Date 会根据文章的 mtime 来计算.
Category 会根据文章的路径来计算.

可以在 content 目录中新建一个 pages 文件夹, 那么这个文件夹中的文件会被用来做静态页面, 而
不是普通文章, 比如 about 页面.

如果想要作为草稿发布的话, 可以指定 `status: draft`. 能够发表的时候再把 status 改为
publihsed

# 参考

1. [Pelican 文档](http://docs.getpelican.com/en/stable/index.html)
