# GitHub 上的顶级项目都是做什么的？（一）


ID: 622
Status: publish
Date: 2019-01-25 03:29:00
Modified: 2020-02-15 11:11:56


前一阵看到同事在用一个名叫 AirFlow 的工具，而我竟然素未耳闻，一番搜索之后发现这个
工具是 Apache 的顶级项目，而且在 GitHub 上有 1w+ 的 Star。震惊之余，感觉有必要
把 GitHub 上常用工具捋一遍，以避免以后发生重复造轮子的情况。计划是把 GitHub 上
5k+ Star 的项目都知道是做什么用的，每周看 50 个，数据来源是这里：https://gitstar-ranking.com/repositories 。

下面是本周的记录：

# 教程资源类

1. freeCodeCamp/freeCodeCamp

    免费代码训练营

2. EbookFoundation/free-programming-book

    免费编程图书

3. sindresorhus/awesome

    awesome 列表的列表。这个项目起源于某个人做了一个 awesome-php 的 php 优质资源
    列表，然后大家就做了 awesome-python，awesome-vue 等各种列表，这个项目又把
    各种 awesome 列表收集了起来。。

4. CyC2018/CS-Notes

    国人编写的计算机基础教程，中文

5. jwasham/coding-interview-university

    面试考点总结

6. h5bp/Front-end-Developer-Interview-Questions

    前端工程师面试问题

7. vinta/awesome-python

    Python 的一些优质资源. 前面提到的 awesome 系列列表，不再赘述

8. airbnb/javascript

    Airbnb 的 js 编码规范，值得参考。

9. github/gitignore

    GitHub 提供的各种项目的 gitignore 文件模板，省了自己写了

10. getify/You-Dont-Know-JS

    前端（JS）的一些坑的总结

11. vuejs/awesome-vue

    Vue 的一些优质资源. awesome 系列，不再赘述

# 前端 UI 框架/库

1. twbs/bootstrap

    Twitter 推出的前端 UI 框架，有网格系统和各种组件，曾经常年在 GitHub 上排名第一，可以说是后端工程师画界面的利器。

    竞品：Semantic UI, pure-css

2. FontAwesome/Font-Awesome

    字体和图标库，可以使用 SVG 和字体等等多种格式。

3. ant-design/ant-design

    蚂蚁金服出的 react/vue 组件库，前一阵大名鼎鼎的“圣诞彩蛋”就是这个库搞得。主要
    提供 React 的组件库，用于企业中后端的后台的建设。关于 React/Vue 和前端的组
    件化是一个很有意思的话题，可以查阅相关资料。

    和 Bootstrap 等的区别在于，Bootstrap 更偏向于 UI 方面，是 CSS 框架，而 antd
    则是完整的包括 UI 和功能在内的 React 组件。可以理解为 Bootstrap 只做了“皮”,
    而 antd 是 “皮” + “骨”。

4. Semantic-Org/Sematic-UI

    和 Bootstrap 类似的一个组件库。Semantic UI 更强调使用语义化的 class 来定义样式

5. google / material-design-icons

    Google 推出的 Material 风格图标库。

6. daneden/animate.css

    CSS 动画效果库

# 大前端框架和库

1. vuejs/vue

    Vue 是国人推出的一个前端框架，可以通过写不同的 Vue 组件来组成一个完整的应用，
    支持服务端渲染（SSR）。和 React 一样，Vue 也使用了 Virtual-DOM 技术来提高性能。

2. facebook/react

    facebook 推出的一个前端框架，特点是每个组件的 HTML/JS/CSS 组合在一起，使用
    Virtual-DOM 渲染。在 React 出现之前，前端框架普遍采用了后端广泛使用的 MVC
    模式，强调 HTML/JS/CSS 三者要分离，而 React 则反其道而行之，强调从组件构建，
    可以说 React 的出现是前端界的一场革命。

3. facebook/react-native

    使用 React 的语法来构建 native app，注意这里并不是使用一个 iOS 或者 Android
    的 WebView 中嵌套了一个 webapp，而是直接使用 JS 来操作原生组件。

4. angular/angular.js

    Google 推出的前端框架，没用过

5. reactjs/redux

    react.js 的一个组件，用来管理数据。

6. meteor/meteor

    前几年火过一阵，号称要统一前后端，然而我从来没搞明白到底是干啥的，如今热度已经
    大减了。HN 上甚至直接有人问 [Is meteor.js dead?](https://news.ycombinator.com/item?id=16782266)

7. webpack/webpack

    用于打包前端资源

8. chartjs/Chart.js

    前端数据可视化组件

9. electron

    可以使用前端的工具链来编写桌面应用，同时能够跨平台。

10. jQuery

    老牌的跨浏览器兼容库。随着浏览器的发展，现在使用 jQuery 的越来越少了。

11. create-react-app

    用来构造 react app 的辅助工具。

12. d3.js

    前端数据可视化组件

# 后端工具

1. elasticsearch

    使用 Java 编写的一个搜索工具，要实现全文搜索的话，选择 ES 就对了。

2. moby

    Docker 的内核. Docker 可以让你打包应用的所有环境, 像虚拟机一样隔离, 但是又不像虚拟机
    一样过多消耗资源.

# 库

1. ReactiveX/RxJava

    TODO 一种编程模式，现在还不是很了解。

# 机器学习

1. TensorFlow

    Google 推出的深度学习库, 目前占主流地位.

# 语言

1. Microsoft/TypeScript

    微软推出的一个 JavaScript 的超集。我们知道 JavaScript 是一个动态弱类型的语言，
    这种特性在小项目上很方便，然而随着前端项目越来越大，强类型对于程序正确性的保证
    就显得越来越重要了。TypeScript 重点就在于增强了类型，甚至名字都叫 TypeScript。

    强类型的语言是近年来语言的发展趋势，新语言诸如 Rust、Go、Swift 都是强类型的
    语言。而一些老语言，比如 Python 也加入了 Type Hint 的功能来增强类型支持。

2. Apple/swift

    Apple 推出的新语言，用来代替 Obj-C。

3. golang

    Google 推出的编程语言。特点是通过 Goroutine 支持高并发。

4. nodejs

    可以在服务器上运行的 js。

# 通用工具类

1. hakimel / reveal.js

    使用 js 来做 PPT 的一个框架或者说工具

2. GoogleChrome/puppeteer

    Google 推出的操作 Chrome 浏览器的 node.js API。可以用在自动化测试和爬虫等领域。
    官方 API 的推出基本上意味着第三方工具已经失去意义了。比如说 Phantom.js 直接宣
    布停止维护了。

3. atom

    GitHub 推出的一个代码编辑器。

4. oh-my-zsh

    zsh 的增强组件集，可以让你的 shell 异常强大, 建议刚学命令行的可以体验一下.

5. vscode

    微软推出的代码编辑工具，目前占据了市场优势地位。


# Web 框架

1. rails

    Ruby 的一个 MVC 模式的 web 框架，当年可谓大红大紫，现在似乎热度有所衰减了，
    可能是因为大家都不写 Web 应用了。

2. expressjs

    Node.js 的一个 Web 框架。

3. socket.io

    实现 WebSocket 的一个库，使用 node.js 编写。WebSocket 是在浏览器和服务器之间
    实现全双工通信的一个协议。

4. laravel

    一个比较现代的 PHP MVC web 框架，不过 PHP 这几年的热度衰减也很厉害，好多搞 PHP 的都直接转 Go 了。

# 内核

1. torvalds/linux

    这个不用说了吧。评论里提到 Linux 的贡献者在 GitHub 上显示为正无穷, 厉害了.


更新: 更正了一些错误
