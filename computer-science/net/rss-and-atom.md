# RSS 和 Atom 协议详解和不足


ID: 420
Status: publish
Date: 2016-12-27 11:35:00
Modified: 2020-05-16 12:06:48


# 关于CDATA

CDATA stands for Character Data and it means that the data in between these strings includes data that could be interpreted as XML markup, but should not be.

So we could use CDATA to smuggle some HTML into the XML document, so that the HTML doesn't confuse the XML document structure, and then use XSLT later to pull it out and spit it into a HTML document that is being output.
 
*In short, you don't have to escape all the < and & in CDATA section*
 
# RSS 2.0

```
&lt;?xml version=&quot;1.0&quot; encoding=&quot;utf-8&quot;?&gt;
&lt;rss version=&quot;2.0&quot;&gt;
    &lt;channel&gt;
        &lt;title&gt;Example Feed&lt;/title&gt;
        &lt;description&gt;Insert witty or insightful remark here&lt;/description&gt;
        &lt;link&gt;http://example.org/&lt;/link&gt;
        &lt;lastBuildDate&gt;Sat, 13 Dec 2003 18:30:02 GMT&lt;/lastBuildDate&gt;
        &lt;managingEditor&gt;johndoe@example.com (John Doe)&lt;/managingEditor&gt;
        &lt;item&gt;
            &lt;title&gt;Atom-Powered Robots Run Amok&lt;/title&gt;
            &lt;link&gt;http://example.org/2003/12/13/atom03&lt;/link&gt;
            &lt;pubDate&gt;Sat, 13 Dec 2003 18:30:02 GMT&lt;/pubDate&gt;
            &lt;description&gt;Some text.&lt;/description&gt;
            &lt;source&gt;Shit News&lt;/source&gt;
        &lt;/item&gt;
        &lt;item&gt;...&lt;/item&gt;
    &lt;/channel&gt;
&lt;/rss&gt;
```

## RSS 协议的一些不足和改进方向

1. 没有标识文章重要度的字段
2. 没有途径把订阅数量等信息反馈给 RSS 提供方
3. 没有品牌特性
4. 没有机器推荐
5. 如果能够把 RSS 包装成像是 Amazon Prime 那样的服务，用户可能会很愿意付钱

实际上文章的增删改查是一套组合操作，而只使用一个 RSS 作为列表显然是不够的，必然要拓展。

现代的 RSS 阅读器需要做三个方面

1. 一个社区
2. 能够把所有服务都提供RSS，包括不提供RSS的站点
3. 评论服务
4. 转码。有的 RSS 只提供了文章的摘要，有的 RSS 有实效性，有的 RSS 有自己的字体


 
 
# Atom 1.0

```
&lt;?xml version=&quot;1.0&quot; encoding=&quot;utf-8&quot;?&gt;
&lt;feed xmlns=&quot;http://www.w3.org/2005/Atom&quot;&gt;
    &lt;title&gt;Example Feed&lt;/title&gt;
    &lt;subtitle&gt;Insert witty or insightful remark here&lt;/subtitle&gt;
    &lt;link href=&quot;http://example.org/&quot;/&gt;
    &lt;updated&gt;2003-12-13T18:30:02Z&lt;/updated&gt;
    &lt;author&gt;
        &lt;name&gt;John Doe&lt;/name&gt;
        &lt;email&gt;johndoe@example.com&lt;/email&gt;
    &lt;/author&gt;
    &lt;id&gt;urn:uuid:60a76c80-d399-11d9-b93C-0003939e0af6&lt;/id&gt;
 
    &lt;entry&gt;
        &lt;title&gt;Atom-Powered Robots Run Amok&lt;/title&gt;
        &lt;link href=&quot;http://example.org/2003/12/13/atom03&quot;/&gt;
        &lt;id&gt;urn:uuid:1225c695-cfb8-4ebb-aaaa-80da344efa6a&lt;/id&gt;
        &lt;updated&gt;2003-12-13T18:30:02Z&lt;/updated&gt;
        &lt;summary&gt;Some text.&lt;/summary&gt;
    &lt;/entry&gt;
 
&lt;/feed&gt;
```
 
# reference
 
[1] http://www.intertwingly.net/wiki/pie/Rss20AndAtom10Compared