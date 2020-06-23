# 搜索阅读笔记

wp_id: 361
Status: publish
Date: 2018-06-22 05:18:00
Modified: 2020-05-16 11:10:02

# 文档评分

## 索引的类型（参数化索引和域 zone 索引）

对于每个文档来说，除了一个字符串作为正文之外，还有其他的 metadata，比如一篇文章就会有 title publish_time author 等等。

其中 publish_time 这种是有取值范围的，我们称之为参数化索引。而对于 title 和 author 这种可以是任意的自有文本，因此我们也可以对它建立倒排。

在这里建立倒排有两种数据结构，目的都是把 term 和 zone 都标注到倒排上：

1. 把 term 和 zone 合起来作为新的 term

```
wiliam.abstrct -> [11], [122], [1441]
william.title -> [2], [4], [8]
william.author -> [2], [3], [5]
```
	
2. 把 zone 和 docID 一起记录

```
william -> [2.title, 2.author], [3.author], [4.title], ...
```
	
### 域加权评分

对每个域给定一个权重，然后使用每个域有没有出现相关关键词来求和评分

### 权重的设定

```
1. 专家设定
2. 由人工标注，然后使用机器学习来评分
```