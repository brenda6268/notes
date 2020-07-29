# python-readability 源码阅读

<!--
ID: 6c0740dd-7ffd-427f-b344-10272fcd003b
Status: publish
Date: 2017-07-09T11:26:06
Modified: 2020-05-16T11:45:34
wp_id: 307
-->

readability 是一个可以从杂乱无章的网页中抽取出无特殊格式，适合再次排版阅读的文章的库，比如我们常见的手机浏览器的阅读模式很大程度上就是采用的这个库，还有 evernote 的 webclipper 之类的应用也都是利用了类似的库。readability 的各个版本都源自readability.js这个库，之前尝试阅读过js版本，无关的辅助函数太多了，而且 js 的 dom api 实在称不上优雅，读起来晦涩难通，星期天终于有时间拜读了一下python-readability的代码。

readability核心是一个Document类，这个类代表了一个 HTML 文件，同时可以输出一个格式化的文件

# 几个核心方法和概念

## summary

summary 方法是核心方法，可以抽取出一篇文章。可能需要对文章抽取多次才能获得符合条件的文章，这个方法的核心思想是：

1. 第一次尝试抽取设定 ruthless，也就是强力模式，可能会误伤到一些标签
2. 把给定的 input 解析一次并记录到 self.html，并去除所有的 script，sytle 标签，因为这些标签并不贡献文章内容
3. 如果在强力模式，使用remove_unlikely_candidates去掉不太可能的候选
4. transform_misused_divs_into_ps把错误使用的 div 转换成 p 标签，这样就不用考虑 div 标签了，其实这步挺关键的。其实还有一些其他的处理需要使用。
5. 使用score_paragraphs给每段（paragraph）打分
6. 使用select_best_candidates获得最佳候选（candidates）
7. 选出最佳候选，如果选出的话，调用 get_article 抽取文章
8. 如果没有选出，恢复到非强力模式再试一次，还不行的话就直接把 html 返回
9. 清理文章，使用 sanitize 方法
10. 如果得到的文章太短了，尝试恢复到非强力模式重试一次

强力模式和非强力模式的区别就在于是否调用了 remove_unlikely_candidates

对于以上的核心步骤, 已经足够应付大多数比较规范的网页. 但是还是会有不少识别错误. 公司内部的改进做法在于：

此处省略1000个字。

<!--
1. transform那一步修正了更多的错误。
2. 在得到best node之后记录了xpath，方便抽取下一页内容。
3. 抽取后检查文章长度。
4. 如果抽取失败，不是返回文章，而是返回空
5. 分页文章的合并
6. 更多地文章抽取相关正则
-->

下面按照在 summary 出场顺序依次介绍~

## remove_unlikely_candidates

匹配标签的 class 和 id，根据unlikelyCandidatesRe和okMaybeItsACandidate这个两个表达式删除一部分节点。

    unlikelyCandidatesRe：combx|comment|community|disqus|extra|... 可以看出是一些边缘性的词汇
    okMaybeItsACandidateRe: and|article|body|column|main|shadow... 可以看出主要是制定正文的词汇

## transform_misused_divs_into_paragraphs

1. 对所有的 div 节点，如果没有 divToPElementsRe 这个表达式里的标签，就把他转化为 p
2. 再对剩下的 div 标签中，如果有文字的话，就把文字转换成一个 p 标签，插入到当前节点，如果子标签有 tail节点的话，也把他作为 p 标签插入到当前节点中
3. 把 br 标签删掉

## socore_node

1. 按照tag、 class 和 id 如果符合负面词汇的正则，就剪掉25分，如果符合正面词汇的正则，就加上25分
2. div +5 分， pre、td、backquote +3 分
3. address、ol、ul、dl、dd、dt、li、form -3分
4. h1-h6 th -5 分

## score_paragraphs

1. 首先定义常量，MIN_LEN 最小成段文本长度
2. 对于所有的 p，pre，td 标签，找到他们的父标签和祖父标签，文本长度小于 MIN_LEN 的直接忽略
3. 对父标签打分（score_node），并放入排序队列
4. 祖父标签也打分，并放入排序队列
5. 开始计算当前节点的内容分（content_socre) 基础分1分，按照逗号断句，每句一分，每100字母+1分，至少三分
6. 父元素加上当前元素的分，祖先元素加上1/2
7. 链接密度 链接 / (文本 + 链接)
8. 最终得分 之前的分 * （1 - 链接密度）

注意，当期标签并没有加入 candidates，父标签和祖父标签才加入
累计加分，如果一个元素有多个 p，那么会把所有子元素的content score都加上

## select_best_candidate

就是 ordered 中找出最大的

## get_article

对于最佳候选周围的标签，给予复活的机会，以避免被广告分开的部分被去掉，阈值是10分或者最佳候选分数的五分之一。如果是 p 的话，node_length > 80 and link_density < 0.25 或者 长度小于80，但是没有连接，而且最后是句号


# 思考

readability之所以能够work的原因，很大程度上是基于html本身是一篇文档，数据都已将在html里了，然后通过操作DOM获得文章。而在前端框架飞速发展的今天，随着react和vue等的崛起，越来越多的网站采用了动态加载，真正的文章存在了页面的js中甚至需要ajax加载，这时在浏览器中使用readability.js虽然依然可以（因为浏览器已经加载出了DOM），但是如果用于抓取目的的话，需要执行一遍js，得到渲染过的DOM才能提取文章，如果能够有一个算法，直接识别出大段的文字，而不是依赖DOM提取文章就好了~