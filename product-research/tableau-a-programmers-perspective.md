# 从程序员的角度看 Tableau（未完待续）

Tableau 是最流行的一款 BI 软件（没有之一）。本文从程序员的角度主要讨论 Tableau 的使用和可能的实现原理。因为 Tableau 是一款商业闭源软件，所以这里的实现原理只是猜测。

## 从 Excel 说起

Tableau 可以理解为数据透视表（pivot table）的超级增强版。

相比 Excel 来说，BI 软件解决的是一个更加 Clean room 的问题。Excel 作为一个通用的表格软件，能够处理的问题更加宽泛，对数据的约束也更少。在 Excel 中，你可以从任意一个位置开始输入任意的数据。而在 Tableau 中，不可能有空着的数据位置，也就是说，数据总是从 A1 位置开始的。从编程的角度来说，我们可以说 Tableau 中的每一个行或者列是强类型的。

Excel 中的很多函数在 Tableau 中都是有对应的，比如 MAX(), ABS() 等，毕竟两个处理的都是表格数据。

Tableau 还很智能，会识别出日期字段，城市字段等等。Tableau 也是一个简单的 GIS 可视化系统。

## 从实现上来说

Tableau 是一个只读工具，不管是使用它的 Live Connection 还是 Extract 功能复制一份数据，它并不能改变数据源。

Tableau 在你拖拽的时候生成对应的 SQL 语句或者在自己内部运算数据。它的大致组件如下：

![](https://tva1.sinaimg.cn/large/00831rSTly1gcvhcbi47zj308c05vmxu.jpg)

### 数据库驱动

这部分实际上就是针对不同的 SQL dialect 的一个 Adapter。Tableau 在这部分做的挺好的，支持的特别多，毕竟每多支持一个数据库就是多一批客户，都是钱啊。

### VizQL

Tableau 的表达式叫做 VizQL，是有专利的，这也是 Tableau 的安身立命之本。当我们在 Tableau 界面上操作的时候，比如说：

把一个维度拖到行上，把一个度量拖到标签上，那么就相当于

```
SELECT Region, Sum(Sales) FROM Orders GROUP BY Region
```

把另一个维度拖到过滤器上，会添加一个 Where 子句，排序会增加 ORDER BY 子句，等等。

除此之外，计算字段和 LOD 表达式也都是编译到 SQL 执行的，如果后端数据源支持的话。但是表计算是在 Tableau 内部的。

### 绘制（Data Viz）

Tableau 自然有他自己的绘制库，这部分应该没有什么外部实现不了的。调研了 20 几个开源库，echarts 应该是最完善的，应该是 Tableau 图表的一个 superset，但是可能有性能问题和内存泄漏之 yu。另外 echarts 不是基于 D3 的，似乎和其他的图标库相比，比较另类一些。

### Memeory Cache

Tableau 会在内存中生成一个缓存表，作为进一步计算的基础。这部分可能会涉及到他在官网提到的 Hyper 技术。按照 Hyper 的介绍，也不一定只在内存中，可能需要一个列存储的数据库，以便进行一些高性能的并行计算。

## 核心技术

Tableau 提到自己的核心优势有两个：Hyper 和 VizQL。

### 计算与表达式（VizQL）

Table 中的计算分为 3 种。计算字段、LOD 计算、表计算。

计算字段会保存在 tableau 的本身的数据存储中，但是并没有存储到原始数据源中。

另外有个意思的东西是，Tableau 提供了日期字面量：#xxx#

在进行表计算的时候，维度字段会被分成两类。一类叫做 partition field，也就是分区字段，另一类叫做 addressing field，也就是寻址字段。在做表计算的过程中，首先按照分区字段把表分成更小一些的子分区或者叫子表，然后按照寻址字段和给定的方向在当前子表中计算。当使用 tableau 内置的选项时，实际上 tableau 内部也是转化成了对应的 partition 和 addressing。

tableau 的表达式中并没有包含 partition 和 addressing 的信息，还需要额外指定，这也太垃圾了。

总的来说是这样子的：

> ![](https://tva1.sinaimg.cn/large/00831rSTgy1gcvog3rdvnj313c0ce0xr.jpg)

> 1. 代表 Tableau 基于视图上的内容产生 query 发到数据库中
> 2. 数据库基于 query 的内容算出相应的计算结果。我们的聚合计算、LOD 的计算发生在这里。
> 3. Tableau 会产生一个临时表，该临时表记录了视图数据内会使用的维度和度量信息。
> 4. 步骤 3 的内容加载到 Tableau 后，基于该数据再进行表计算
> 5. 呈现可视化视图

一个值得注意的细节是，实现 VizQL 的函数的时候需要考虑两种情况，以 ABS() 为例：

1. 如果是计算字段的 ABS 函数，那么需要生成对应的 SQL 语句；
2. 如果是在表计算之后的 ABS 函数，那么需要自己实现 ABS 函数。

<small>查看更多：关于 VizQL 的更多想法已经放在 wiki 上了，虽然没写完呢。</small>

整体上来说：Tableau VizQL 是一门比较简单的 DSL，需要关注的重点在于后端实现。

### Hyper

从官网上的介绍来看，这部分就是 Tableau 的计算引擎。用的也都是现在已经公开发表的技术，细节还没看。待续。

## Tableau 的优势和缺点

Tableau 可以说是 BI 界的标杆性产品，但是 Tableau 并不是完美的。作为一个从 2003 年开始开发的软件，Tableau 只能利用当时已有的工具和算法，或者自己开发。在 17 年后的今天，已经有了很多更优雅、性能更好的组件。如果我们现在从头来开发一个 Tableau，那么可能是事半功倍的，也就是拥有「后发者优势」。由于年代久远，可能有一些当时做的好的折中，在现在已经不是最佳实践了，但是也不好修正了，这也是一种「先发者劣势」。

举一个例子来说，SAP 从上世纪七十年代开始做企业级软件，当时没有数据库，甚至没有操作系统，SAP 就只好自己去做数据库。而开创了 SaaS 模式的后期之秀 Salesforce 却可以充分利用互联网时代的各种技术。这里并不是说 Salesforce 超过了 SAP 或者怎样，但是至少 Salesforce 也在 toB 市场中占有了一席之地。Salesforce(CRM) 现在也是 Tableau(DATA) 的母公司。

除此之外，很明显的一点，相比其他一些 SaaS 化的工具，比如说 POPSQL 来说，Tableau 对于 SQL 和其他一些更硬核的自定义功能支持比较弱。

## Beyond Tableau

广义的来说，BI 并不只是 Tableau。一般来说，大企业内部都是有一套 BI Stack 的，从数据收集，存储，转换到最后的可视化分析，做出商业决策，这才是完整的一个链条。

这里有一个非常好的帖子，讲自己厂里的 BI stack 是什么样子：[What is your BI stack](https://news.ycombinator.com/item?id=21513566)

BI 工具至少包括了几个核心组件：

- 数据接入端，一般来说需要支持 xslx，csv，sql 数据库这些数据来源
- 数据存储运算，一般来说是一个分析性数据库，采用列存储
- 数据后置运算，Tableau 可以算是
- 数据展示绘制，Tableau

### 商业版

- Fine BI 没仔细看
- MS Power BI 没仔细看
- imply druid 开发者做的商业版工具
- Looker

### 开源工具

- metabase 试用了下，有点太简单了
- superset 和 druid 完全绑定的

### 列数据库

- Apache kylin。Kylin 是 ebay 开发的一个分析数据库。
- Apache druid
- Kylin on Druid。美团做的工具
- clickhouse。老毛子用 C++ 写得，直觉上来说，性能应该更加强悍。

clickhouse 的 UI：https://github.com/tabixio/tabix 也可以理解为一个简单的 BI 工具

### 绘制库

太多了，不展开说了。单独再写文档。

另外，上面的帖子其中提到的工具：

- http://redash.io
- https://www.snowflake.com/
- https://github.com/spotify/luigi 类似 Airflow
- https://looker.com/ （已被 Google 收购）
- https://popsql.com/
- https://app.forestadmin.com/signup
- https://www.periscopedata.com/
- https://aws.amazon.com/redshift/ AWS 的服务
- https://dataform.co/

## 参考资料

- [5 Pointers for Excel Users Who are Learning Tableau](https://unilytics.com/5-pointers-for-excel-users-who-are-learning-tableau/)
- [Expression in druid](https://druid.apache.org/docs/latest/misc/math-expr.html)
- [Group by in pandas](https://stackoverflow.com/questions/43930189/calculating-ytd-totals-in-pandas)
- https://www.thedataschool.co.uk/aude-cazein/tableau-behind-the-scenes/
- https://www.theinformationlab.co.uk/2013/01/28/5-things-i-wish-i-knew-about-tableau-when-i-started/
- https://www.jianshu.com/p/ec957648eac7
- https://www.tableau.com/products/technology
https://www.tableau.com/products/new-features/hyper
- https://www.softwaretestinghelp.com/best-olap-tools/
- https://drive.tmaas.eu/2018/11/26/six-software-tools-for-constructing-a-data-platform/