# 关于 CDATA

<!--
ID: 419ff63e-a51a-4a01-a898-7f03931ade45
Status: publish
Date: 2016-12-27T11:35:00
Modified: 2020-05-16T12:06:48
wp_id: 420
-->

CDATA stands for Character Data and it means that the data in between these strings includes data that could be interpreted as XML markup, but should not be.

So we could use CDATA to smuggle some HTML into the XML document, so that the HTML doesn't confuse the XML document structure, and then use XSLT later to pull it out and spit it into a HTML document that is being output.
 
*In short, you don't have to escape all the < and & in CDATA section*
 
# RSS 2.0

```
<?xml version="1.0" encoding="utf-8"?>
<rss version="2.0">
    <channel>
        <title>Example Feed</title>
        <description>Insert witty or insightful remark here</description>
        <link>http://example.org/</link>
        <lastBuildDate>Sat, 13 Dec 2003 18:30:02 GMT</lastBuildDate>
        <managingEditor>johndoe@example.com (John Doe)</managingEditor>
        <item>
            <title>Atom-Powered Robots Run Amok</title>
            <link>http://example.org/2003/12/13/atom03</link>
            <pubDate>Sat, 13 Dec 2003 18:30:02 GMT</pubDate>
            <description>Some text.</description>
            <source>Shit News</source>
        </item>
        <item>...</item>
    </channel>
</rss>
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
2. 能够把所有服务都提供 RSS，包括不提供 RSS 的站点
3. 评论服务
4. 转码。有的 RSS 只提供了文章的摘要，有的 RSS 有实效性，有的 RSS 有自己的字体

 
# Atom 1.0

```
<?xml version="1.0" encoding="utf-8"?>
<feed xmlns="http://www.w3.org/2005/Atom">
    <title>Example Feed</title>
    <subtitle>Insert witty or insightful remark here</subtitle>
    <link href="http://example.org/"/>
    <updated>2003-12-13T18:30:02Z</updated>
    <author>
        <name>John Doe</name>
        <email>johndoe@example.com</email>
    </author>
    <id>urn:uuid:60a76c80-d399-11d9-b93C-0003939e0af6</id>
 
    <entry>
        <title>Atom-Powered Robots Run Amok</title>
        <link href="http://example.org/2003/12/13/atom03"/>
        <id>urn:uuid:1225c695-cfb8-4ebb-aaaa-80da344efa6a</id>
        <updated>2003-12-13T18:30:02Z</updated>
        <summary>Some text.</summary>
    </entry>
 
</feed>
```
 
# reference
 
[1] http://www.intertwingly.net/wiki/pie/Rss20AndAtom10Compared