# [译] 用 Python 编写一个模板引擎


ID: 268
Status: publish
Date: 2018-04-17 15:11:45
Modified: 2020-05-16 11:36:17


一直对模板引擎的实现很好奇，正好看到了[这篇](http://alexmic.net/building-a-template-engine/)文章，翻译一下，供大家学习、参考。

我们编写一个最简单的模板引擎，并且探索一下它的底层实现。如果你想直接看代码的话，[GitHub](https://github.com/alexmic/microtemplates) 是你的好朋友

# 语言设计

这里设计的模板语言非常基础。使用两种标签，变量和块。

```
&lt;!-- 变量使用 &#x60;{{&#x60; 和 &#x60;}}&#x60; 作为标识--&gt;
&lt;div&gt;{{my_var}}&lt;/div&gt;

&lt;!-- 块使用 &#x60;{%&#x60; 和 &#x60;%}&#x60; 作为标识--&gt;
{% each items %}
    &lt;div&gt;{{it}}&lt;/div&gt;
{% end %}
```

大多数的块需要使用关闭标签，关闭标签使用`{% end %}`表示。

这个模板引擎能够处理基本的循环和条件语句，而且也支持在块中使用 callable。在我看来，能够在模板中调用任意的 Python 函数非常方便。

# 循环

使用循环可以遍历集合或者 iterable。

```
{% each people %}
    &lt;div&gt;{{it.name}}&lt;/div&gt;
{% end %}

{% each [1, 2, 3] %}
    &lt;div&gt;{{it}}&lt;/div&gt;
{% end %}

{% each records %}
    &lt;div&gt;{{..name}}&lt;/div&gt;
{% end %}
```

在上面的例子里面，people 是一个集合，`it` 指向了当前迭代的元素。使用点分隔的路径会被解析成字典属性。使用 `..` 可以访问外部上下文中的对象。

# 条件语句

条件语句不需要多解释。这个语言支持 if 和 else 结构，而且支持 `==`, `<=`, `>=`, `!=`, `is`, `<`, `>` 这几个操作符。

```
{% if num &gt; 5 %}
    &lt;div&gt;more than 5&lt;/div&gt;
{% else %}
    &lt;div&gt;less than or equal to 5&lt;/div&gt;
{% end %}
```

# 调用块

Callable 可以通过模板上下文传递，并且使用普通位置参数或者具名参数调用。调用块不需要使用 end 关闭。

```
&lt;!-- 使用普通参数... --&gt;
&lt;div class=&#039;date&#039;&gt;{% call prettify date_created %}&lt;/div&gt;
&lt;!-- ...使用具名参数 --&gt;
&lt;div&gt;{% call log &#039;here&#039; verbosity=&#039;debug&#039; %}&lt;/div&gt;
```

# 原理

在探索引擎是如何编译和渲染模板之前，我们需要了解下在内存中如何表示一个编译好的模板。

编译器使用抽象语法树（Abstract Syntax Tree, AST）来表示计算机程序。AST 是对源代码进行词法分析（lexical analysis）的结果。AST 相对源代码来说有很多好处，比如说它不包含任何无关紧要的文本元素，比如说分隔符这种。而且，树中的节点可以使用属性来添加更多的功能，而不需要改动代码。

我们会解析并分析模板来构造这样一棵树，并用它来表示编译后的模板。渲染的时候，遍历这棵树，传给它对应的上下文，然后输出 HTML。

# 模板切词（tokenize）

解析的第一步是把内容分隔成不同的片段。每个片段可以是任意的 HTML 或者是一个标签。这里使用正则表达式和 `split()` 函数分隔文本。

```
VAR_TOKEN_START = &#039;{{&#039;
VAR_TOKEN_END = &#039;}}&#039;
BLOCK_TOKEN_START = &#039;{%&#039;
BLOCK_TOKEN_END = &#039;%}&#039;
TOK_REGEX = re.compile(r&quot;(%s.*?%s|%s.*?%s)&quot; % (
    VAR_TOKEN_START,
    VAR_TOKEN_END,
    BLOCK_TOKEN_START,
    BLOCK_TOKEN_END
))
```

让我们来看一下 TOK_REGEX。可以看到这个正则的意思是 TOK_REGEX 要么是一个变量标签，要么是一个块标签，这是为了让变量标签和块标签都能够分隔文本。表达式的最外层是一个括号，用来捕获匹配到的文本。其中的 `?` 表示非贪婪的匹配。我们想让我们的正则表达式是惰性的，并且在第一次匹配到的时候停下来。

下面这个例子实际展示了一下上面的正则:

```
&gt;&gt;&gt; TOK_REGEX.split(&#039;{% each vars %}&lt;i&gt;{{it}}&lt;/i&gt;{% endeach %}&#039;)
[&#039;{% each vars %}&#039;, &#039;&lt;i&gt;&#039;, &#039;{{it}}&#039;, &#039;&lt;/i&gt;&#039;, &#039;{% endeach %}&#039;]
```

把每个片段封装成 Fragment 对象。这个对象包含了片段的类型，并且可以作为编译函数的参数。片段有以下四种类型：

```
VAR_FRAGMENT = 0
OPEN_BLOCK_FRAGMENT = 1
CLOSE_BLOCK_FRAGMENT = 2
TEXT_FRAGMENT = 3
```

# 构建 AST

一旦我们做好了分词，下一步就可以遍历每个片段并构建语法树了。我们使用 Node 类来作为树的节点的基类，然后创建对每一种节点类型创建子类。每个子类都必须提供 `process_fragment` 和 `render` 方法。`process_fragment` 用来进一步解析片段的内容并且把需要的属性存到 `Node` 对象上。`render` 方法负责使用提供的上下文转换对应的节点内容到 HTML。

子类也可以实现 `enter_scope` 和 `exit_scope` 钩子方法，这两个方法不是必须的。在编译器编译期间，会调用这两个钩子函数，他们应该负责进一步的初始化和清理工作。当一个 `Node` 创建了一个新的作用域（scope）的时候，会调用 `enter_scope`，当退出作用域时，会调用 `exit_scope。关于作用域`，下面会讲到。

Node 基类如下：

```
class _Node(object):
    def __init__(self, fragment=None):
        self.children = []
        self.creates_scope = False
        self.process_fragment(fragment)

    def process_fragment(self, fragment):
        pass

    def enter_scope(self):
        pass

    def render(self, context):
        pass

    def exit_scope(self):
        pass

    def render_children(self, context, children=None):
        if children is None:
            children = self.children
        def render_child(child):
            child_html = child.render(context)
            return &#039;&#039; if not child_html else str(child_html)
        return &#039;&#039;.join(map(render_child, children))
```

下面是变量节点的定义：

```
class _Variable(_Node):
    def process_fragment(self, fragment):
        self.name = fragment

    def render(self, context):
        return resolve_in_context(self.name, context)
```

为了确定 Node 的类型（并且进一步初始化正确的类），需要查看片段的类型和文本。文本和变量片段直接翻译成文本节点和变量节点。块片段需要一些额外的处理 —— 他们的类型是使用块命令来确定的。比如说：

```
{% each items %}
```

是一个 `each` 类型的块节点，因为块命令是 each。

一个节点也可以创建作用域。在编译时，我们记录当前的作用域，并且把新的节点作为作为当前作用域的子节点。一旦遇到一个正确的关闭标签，关闭当前作用域，并且从作用域栈中把当前作用域 pop 出来，使用栈顶作为新的作用域。

```
def compile(self):
    root = _Root()
    scope_stack = [root]
    for fragment in self.each_fragment():
        if not scope_stack:
            raise TemplateError(&#039;nesting issues&#039;)
        parent_scope = scope_stack[-1]
        if fragment.type == CLOSE_BLOCK_FRAGMENT:
            parent_scope.exit_scope()
            scope_stack.pop()
            continue
        new_node = self.create_node(fragment)
        if new_node:
            parent_scope.children.append(new_node)
            if new_node.creates_scope:
                scope_stack.append(new_node)
                new_node.enter_scope()
    return root
```

# 渲染

管线的最后一步就是把 AST 渲染成 HTML 了。这一步访问 AST 中的所有节点并且使用传递给模板的 context 参数调用 render 方法。在渲染过程中，render 不断地解析上下文变量的值。可以使用使用 `ast.literal_eval` 函数，它可以安全的执行包含了 Python 代码的字符串。

```
def eval_expression(expr):
    try:
        return &#039;literal&#039;, ast.literal_eval(expr)
    except ValueError, SyntaxError:
        return &#039;name&#039;, expr
```

如果我们使用上下文变量，而不是字面量的话，需要在上下文中搜索来找到它的值。在这里需要处理包含点的变量名以及使用两个点访问外部上下文的变量。下面是 resolve 函数，也是整个难题的最后一部分了~

```
def resolve(name, context):
    if name.startswith(&#039;..&#039;):
        context = context.get(&#039;..&#039;, {})
        name = name[2:]
    try:
        for tok in name.split(&#039;.&#039;):
            context = context[tok]
        return context
    except KeyError:
        raise TemplateContextError(name)
```

# 结论

我希望这个小小的学术联系能够让你对模板引擎是怎样工作的有一点初步的感觉。这个生产级别的代码还差得很远，但是也可以作为你开发更好的工具的基础。

你可以在 GitHub 上找到完整的代码，你也可以进一步在 Hacker News 上讨论。

> 感谢 Nassos Hadjipapas, Alex Loizou, Panagiotis Papageorgiou and Gearoid O’Rourke 审阅本文。