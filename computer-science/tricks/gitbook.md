# 使用 gitbook 创建一本书

<!--
ID: f8b4454c-bc31-4ac5-8569-b311fad7248e
Status: publish
Date: 2017-05-30T07:50:00
Modified: 2019-10-12T11:19:04
wp_id: 750
-->

Summary.md 这个文件相对于是一本书的目录结构。比如SUMMARY.md :

```markdown
# Summary
* [Introduction](README.md)
* [基本安装](howtouse/README.md)
   * [Node.js安装](howtouse/nodejsinstall.md)
   * [Gitbook安装](howtouse/gitbookinstall.md)
   * [Gitbook命令行速览](howtouse/gitbookcli.md)
* [图书项目结构](book/README.md)
   * [README.md 与 SUMMARY编写](book/file.md)
   * [目录初始化](book/prjinit.md)
* [图书输出](output/README.md)
   * [输出为静态网站](output/outfile.md)
   * [输出PDF](output/pdfandebook.md)
* [发布](publish/README.md)
   * [发布到Github Pages](publish/gitpages.md)
* [结束](end/README.md)
```

SUMMARY.md基本上是列表加链接的语法。链接中可以使用目录，也可以使用。