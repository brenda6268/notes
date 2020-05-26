# Golang 网络相关库


ID: 779
Status: draft
Date: 2019-10-19 12:42:51
Modified: 2020-05-16 10:49:24


# net/http

# golang/x/net/html

主要包括了两部分 Tokenizer 和 Parser。和其他所有的包一样，html包只处理utf-8编码的字符串。

## Parse/Render...

Node，代表 HTML 中的一个节点，可以是标签、注释、文本等等。NodeType 表示了不同的类型。

```
type Node struct {
    Parent, FirstChild, LastChild, PrevSibling, NextSibling *Node
    Type      NodeType
    DataAtom  atom.Atom
    Data      string
    Namespace string
    Attr      []Attribute
}
```

需要注意其中的DataAtom属性是一个uint32属性，每个枚举值代表了一个标签值，使用数字比使用字符串要快而且省空间。可以使用atom.Atom 的 Lookup(String) 两个方法来转换字符串和atom

```
type Attribute struct {
    Namespace, Key, Val string
}
const (
    ErrorNode NodeType = iota
    TextNode
    DocumentNode
    ElementNode
    CommentNode
    DoctypeNode
)
```


func Parse(r io.Reader) (*Node, error) 从 io.Reader 构建节点树，返回根节点。如果不是完整的树，可以采用 ParseFragment

func Render(w io.Writer, n *Node) error 从根节点渲染树，并把结果放到 io.Writer 中。

func (n *Node) AppendChild(c *Node) 添加一个子节点

func (n *Node) AppendChild(c *Node) 在前面插入一个节点

func (n *Node) RemoveChild(c *Node) 删除子节点

注意这三个函数没有返回错误值，如果发生错误就会 panic。

```
doc, err := html.Parse(r)
if err != nil {
	// ...
}
var f func(*html.Node)
f = func(n *html.Node) {
	if n.Type == html.ElementNode &amp;&amp; n.Data == &quot;a&quot; {
		// Do something with n...
	}
	for c := n.FirstChild; c != nil; c = c.NextSibling {
		f(c)
	}
}
f(doc)
```

## Tokenize

除了把文档整个解析成一颗树之外，另一个中处理方式就是迭代地处理，每次处理一个token。主要通过 Tokenizer 和相关的函数来处理。

```
z := html.NewTokenizer(r)
depth := 0
for {
	tt := z.Next()
	switch tt {
	case html.ErrorToken:
		return z.Err()
	case html.TextToken:
		if depth &gt; 0 {
			// emitBytes should copy the []byte it receives,
			// if it doesn&#039;t process it immediately.
			emitBytes(z.Text())
		}
	case html.StartTagToken, html.EndTagToken:
		tn, _ := z.TagName()
		if len(tn) == 1 &amp;&amp; tn[0] == &#039;a&#039; {
			if tt == html.StartTagToken {
				depth++
			} else {
				depth--
			}
		}
	}
}
```


net/url
