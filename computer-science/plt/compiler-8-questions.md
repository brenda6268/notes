# 必须理解编译器才能解决的 8 个问题

<!--
ID: 6ebaee23-46e1-484e-aca9-17f720d99ccc
Status: draft
Date: 2017-12-07T02:36:00
Modified: 2020-05-16T11:27:38
wp_id: 495
-->

From：http://steve-yegge.blogspot.com/2007/06/rich-programmer-food.html

1. 你是一个 Java 程序员，你的公司制定了严格的代码规范，并且没有讨价还价的余地，规范之细令人发指。你该如何配置你的编辑器，使得你的代码能够自动按照这个规范调整呢？

2. 你公司的代码大量使用了 ajax，js 代码库的增长几乎和其他的代码库一样快了。你决定使用从 javadoc 抄过来的 jsdoc 来最注释，并且实现自动抽取注释生成文档。结果你发现这个 jsdoc 非常坑爹，它是用 perl 写的，并且 50% 的情况下都会崩溃。但是你并不想再写 perl 了，你怎样实现一个自己的 jsdoc 抽取工具，这个工具肯定会需要一定程度上能够解析 js 代码。

3. 你的公司有一个很庞大的 C++ 代码库。在多年的发展之后已经不堪重负，你发现代码需要做一个很大的重构。比如说从 int32 升级到 int64，或者说改变你使用数据库事务的方式等等，甚至是你需要升级你的 C++ 编译器。

4. 你公司有个人写了一个非常酷炫的基于web的 code review 工具，大家都切换过去了。用了一段时间之后，你发现特别需要一个代码高亮的功能。你也没有多少时间，顶多一周的业余时间。

5. 你的项目遇到了新的挑战，你现在不得不使用一种新的硬件路由器。这些路由器有一个 IP 地址，一个 telnet 接口以及一个私有的控制语言。你发送命令，路由器返回结果。但是并没有一个用户手册，你可能需要逆向工程来破解这些指令，你该怎么办？

6. 你公司的项目快要黄了，工程师们讨论着要重构来解决问题，这已经是第 n 次重构了，但是这次重构规模非常大，说是要解决所有问题。那么你应该提供什么样的工具来解决这个问题。

7. 


为什么编译器很重要？

1. 它以一种很牢固的方式把计算机中的你所知道的所有东西都凝聚到了一起

You can't fully understand how compilers work without knowing machine architecture, because compilers emit machine code. It's more than just instructions; compilers need to understand how the underlying machine actually operates in order to translate your source code efficiently.

Incidentally, "machines" are just about anything that can do computations. Perl is a machine. Your OS is a machine. Emacs is a machine. If you could prove your washing machine is Turing complete, then you could write a compiler that executes C code on it.

Compilers take a stream of symbols, figure out their structure according to some domain-specific predefined rules, and transform them into another symbol stream.

Large Systems Suck

This rule is 100% transitive. If you build one, you suck.


It turns out that many compiler "experts" don't know compilers all that well, because compilers can logically be thought of as three separate phases -- so separate, in fact, that they constitute entirely different and mostly non-overlapping research domains.

The first big phase of the compilation pipeline is parsing. You need to take your input and turn it into a tree. So you go through preprocessing, lexical analysis (aka tokenization), and then syntax analysis and IR generation. Lexical analysis is usually done with regexps. Syntax analysis is usually done with grammars. You can use recursive descent (most common), or a parser generator (common for smaller languages), or with fancier algorithms that are correspondingly slower to execute. But the output of this pipeline stage is usually a parse tree of some sort.

You can get a hell of a lot farther as a professional programmer just by knowing that much. Even if you have no idea how the rest of the compilation works, you can make practical use of tools or algorithms that produce a parse tree. In fact, parsing alone can help you solve Situations #1 through #4 above.

If you don't know how parsing works, you'll do it badly with regular expressions, or if you don't know those, then with hand-rolled state machines that are thousands of lines of incomprehensible code that doesn't actually work.

Really.

In fact I used to ask candidates, as a standard interview question, how they'd find phone numbers in a tree of HTML files, and many of them (up to 30%) chose to write 2500-line C++ programs as their answer.

At some point, candidates started telling me they'd read that one in my blog, which was pretty weird, all things considered. Now I don't ask it anymore.

I ask variants of it occasionally, and it still gets them: you either recognize it as an easy problem or you get out the swiss army knife and start looking for a second to behead you before the pain causes you to dishonor your family.

C++ does that surprisingly often.

The next big phase is Type Checking. This is a group of zealous academics (and their groupies and/or grad students) who believe that they can write programs that are smart enough to figure out what your program is trying to do, and tell you when you're wrong. They don't think of themselves as AI people, though, oddly enough, because AI has (wisely) moved beyond deterministic approaches.

This camp has figured out more or less the practical limit of what they can check deterministically, and they have declared that this is the boundary of computation itself, beyond the borders of which you are crossing the outskirts of civilization into kill-or-be-killed territory, also occasionally known as The Awful Place Where People Make Money With Software.

## YN

其实分布式的系统就是一个操作系统和应用的不同部分被放到了不同的计算机，nothing more nothing less。

比如 redis 就是分布式系统的内存。