# Python爬虫利器——lxml 和 xpath 表达式

<!--
ID: 73a837ea-70ed-443d-9747-fc90a8e15968
Status: publish
Date: 2018-06-02T16:29:00
Modified: 2020-05-16T11:39:33
wp_id: 445
-->

最近要做下微信爬虫，之前写个小东西都是直接用正则提取数据就算了，如果需要更稳定的提取数据，还是使用 xpath 定位元素比较可靠。周末没事，从爬虫的角度研究了一下 python xml/html 相关的库。

Python 标准库中自带了 xml 模块，但是性能不够好，而且缺乏一些人性化的 API。相比之下，第三方库 lxml 是用 Cython 实现的，而且增加了很多实用的功能，可谓爬虫处理网页数据的一件利器。

严格来说，html 并不是 xml 的一种，不过 lxml 对于 xml 和 html 都有很好的支持，分别使用 `lxml.etree` 和 `lxml.html`两个模块。

# 解析

网页下载下来以后是个 bytes 的形式，需要构造 DOM 树：

```

In [1]: html = """
   ...: <p>hello<span id="world">world</span></p>
   ...: """

In [2]: import lxml.html

In [3]: doc = lxml.html.fromstring(html)

In [4]: doc
Out[4]: <Element p at 0x1059aa408>

```

# Element 结构

生成的树是一个设计很精妙的结构，可以把它当做一个对象访问当前节点自身的文本节点，可以把他当做一个数组，元素就是他的子节点，可以把它当做一个字典，从而遍历它的属性，下面演示了 lxml 的常见用法：

```
In [5]: doc.text
Out[5]: "hello"

In [6]: doc.tag
Out[6]: "p"

In [7]: doc[0].tag
Out[7]: "span"

In [11]: for k, v in doc[0].items():
    ...:     print(k, v)
    ...:
id world

In [12]: doc[0].get("id")
Out[12]: "world"

In [13]: doc[0].attrib
Out[13]: {"id": "world"}
```

# 遍历树的方法

doc 是一个树形结构，可以通过一些方法访问树中的其他节点：
    
```
In [14]: doc.getroottree()  # 返回树
Out[14]: <lxml.etree._ElementTree at 0x105360708>

In [19]: doc.getroottree().getroot()  # 返回根节点，这里是 lxml 自动生成的 html 节点
Out[19]: <Element html at 0x10599da98>

In [20]: doc.getparent()  # lxml 自动生成的 body 节点
Out[20]: <Element body at 0x1059a87c8>

In [21]: doc.getprevious()

In [22]: doc.getnext()

In [23]: doc.text_content()
Out[23]: "helloworld"

In [25]: lxml.html.tostring(doc, pretty_print=True, encoding="utf-8")
Out[25]: b"<p>hello<span id="world">world</span></p>\n"

```
注意因为我们给的是一个 html 的片段（`<p>...</p>`），所以 lxml 自动生成了 html 和 body 等节点已构成完整的 html 文档。

如果需要显式地指定生成一个 html 片段文档还是完整文档，可以分别使用：lxml.html.fragment_fromstring 和 lxml.html.document_fromstring 两个方法。

lxml 还有其他一些方法，都列在下面了：

Element.tail	

* Element.append(Element)	添加一个子元素
* Element.set('attr', value) 设置属性
* Element.iter(tag_name) 遍历所有后系元素，可以使用 `*` 
* ElementTree.getelementpath(Element)	
* Element.getroottree()	返回对应的树
* ElementTree.getpath(Element)	返回一个元素的 xpath
* ElementTree.getroot()	返回根节点
* HtmlElement.drop_tree() 删除当前节点下的所有节点，但是保留text
* HtmlElement.drop_tag() 删除当前节点，但是保留它的子节点和text
* HtmlElement.classes 返回类
* HtmlElement.find_class(class_name) 按照 class 查找 tag
* HtmlElement.get_element_by_id(id, *default) 按照 id 查找元素
* HtmlElement.iterlinks() 遍历所有连接
* HtmlElement.make_links_absolute(base_url=None, resolve_base_href=True) 把所有连接变成绝对链接
* HtmlElement.resolve_base_href() 解析 base 标签
* HtmlElement.rewrite_links(link_repl_func) 替换所有的链接

# XPath

XPath 实在太强大了，在定位元素方面绝对是秒杀 CSS 选择器。在 lxml 中，节点和树分别具有xpath 函数。

lxml 中的 xpath 方法，对于 xpath 表达式应该返回元素，总是返回一个数组，即使只有一个元素

```
In [24]: doc.xpath("//span/text()")
Out[24]: ["world"]
```

lxml 中的 xpath 函数支持变量

```
print(root.xpath("$text", text = "Hello World!"))
Hello World!
```

xpath may return _ElementStringResult, which is not picklable, use xpath(smart_strings=False) to avoid this http://lxml.de/xpathxslt.html#xpath-return-values

lxml 还支持几个函数 `find/findall`，他们使用 ElementPath，是一种类似 xpath 的语言，感觉很是奇怪，lxml 的文档描述他是 xpath 的一个子集，暂时不看了。

# 常见问题

lxml 在遇到小于号的时候会出问题（按照标准，应该编码为 `<`），直接把后面的文档都丢了，但是浏览器兼容性比较好，不会有问题。

by default, the lxml parser is not very error-proof, the html5parser lib is behaves more like your web browser.

lxml.html.html5parser provides same interface with lxml.html

tricks and traps