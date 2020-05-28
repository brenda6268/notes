# Go 语言和爬虫


wp_id: 461
Status: publish
Date: 2018-04-09 08:10:00
Modified: 2020-05-16 11:34:41


# 爬虫的算法

## 广度遍历

如果把每一个页面看做一个节点，把每个链接看做一个有向边，那么网页之间就构成了一个有向图。爬虫的核心就是对这个图做一个广度优先的遍历：

```
func breadthFirst(visit func(item, string) []string, worklist []string) {
    seen := make(map[string]bool)
    for len(worklist) > 0 {
        items := worklist
        worklist = nil
        for _, items := range items {
            if !seen[item] {
                seen[item] = true
                worklist = append(worklist, visit(item)...)
            }
        }
    }
}
```

## 终止条件

如果我们面对的是一个有限的图，那么用广度遍历一定可以停下来。但是对于互联网来说，甚至于对于某个网站来说，页面的数量都可能是无限的，或者说没必要爬遍所有页面。那么需要考虑以下几个限制条件：

- 边界限制，比如说限定下爬去的域名
- 深度，比如说限定下爬取的深度
- 并发，比如说开多少个goroutine？以及如何控制并发
- 如何终止，终止条件是什么，限制抓取的深度还是什么？
- 等待所有进程终止，当程序退出的时候，有没有 wait 子过程退出

# 抽取数据

## 使用 CSS 定位元素，而不是 XPath

之前还在用 Python 写爬虫的时候喜欢用 XPath，主要是选择路径比 CSS 表达式看起来更清晰，而且 Python 有一个强大的 lxml 库，对于 xpath 的操作非常便捷。不过也有些缺点，xpath 的坏处就是没有办法按照类选择，而只能按照 class 当做一个属性来选择。而现在的布局之类的好多都是按照类来的，所以可能还是使用 CSS 表达式比较好。举个例子：

```
<div class="title col-sm-6">Hello World</div>
```

比如说网站采用了上面的标签来表示标题，其中的`col-sm-6`可能是用于页面布局的一个类，很有可能经常改变，所以我们想要按照 title 这个属性来定位这个元素，如果使用 xpath 的话，需要这样写：

```
//div[contains(concat(" ", normalize-space(@class), " "), " title ")]
```

而 CSS 天生就是为了布局而生的，所以要选择这个元素，直接这样就可以了：

```
.title
```

当然 CSS 也有一些不方便的时候，比如 XPath 使用 `//nav/span[2]` 就能表达清楚的逻辑，CSS 需要使用 `nav>span:nth-child(2)`。略显长，但是还好不像 XPath 表达类（class）的时候那么 trick。

另外，XPath 不光可以选择元素，还可以选择属性，比如 `//a/@href`，可以直接拿到`a` 的链接，而CSS则只能选择标签。


## goquery

在 Go 语言中，可以使用 goquery 来选取元素，他实现了类似于 jQuery 的语法。

goquery 提供了两个类型，Document 和 Selector，主要通过这两个对象的方法来选择元素。

```
type Document struct {
	*Selection
	Url *url.URL
	rootNode *html.Node // 文档的根节点
}
```

Document 内嵌了 Selection，因此可以直接使用Selection 的方法。

```
type Selection struct {
	Nodes []*html.Node
	document *Document
	prevSel *Selection
}
```

其中 Selection 的不少方法都是和 jQuery 中类似的，再次不再赘述，只列出来可能和抓取相关的一些函数。

1. 生成文档

    1. `NewDocumentFromNode(root *html.Node) *Document`: 传入 *html.Node 对象，也就是根节点。
    2. `NewDocument(url string) (*Document, error)`: 传入 URL，内部用 http.Get 获取网页。
    3. `NewDocumentFromReader(r io.Reader) (*Document, error)`: 传入 io.Reader，内部从 reader 中读取内容并解析。
    4. `NewDocumentFromResponse(res *http.Response) (*Document, error)`: 传入 HTTP 响应，内部拿到 res.Body(实现了 io.Reader) 后的处理方式类似 NewDocumentFromReader.

2. 查找节点

    1. `Find()` 根据 CSS 查找节点

3. 循环遍历选择的节点

    1. `Each(f func(int, *Selection)) *Selection`: 其中函数 f 的第一个参数是当前的下标，第二个参数是当前的节点
    2. `EachWithBreak(f func(int, *Selection) bool) *Selection`: 和 Each 类似，增加了中途跳出循环的能力，当 f 返回 false 时结束迭代
    3. `Map(f func(int, *Selection) string) (result []string)`: f 的参数与上面一样，返回一个 string 类型，最终返回 []string.

4. 获取节点的属性或者内容

    1. `Attr()`: 获得某个属性的值
    2. `Html()`: 获得当前节点的 html
    3. `Length()`: 
    4. `Text()`:


（未完待续）


# ref

1. http://liyangliang.me/posts/2016/03/zhihu-go-insight-parsing-html-with-goquery/
2. http://blog.studygolang.com/2015/04/go-jquery-goquery/