# simhash

<!--
ID: 74c134d8-2025-4f26-8137-ee41e6da5966
Status: draft
Date: 2017-07-05T09:09:00
Modified: 2017-07-05T09:09:00
wp_id: 487
-->

## shingling

n-shingling 就是把一个句子或者文章分成 n 个连续单词的组合，然后去重。

比如： the cat sat on the cat

第一步，分组： the cat, cat sat, sat on, on the, the cat
第二步，去重： the cat, cat sat, sat on, on the


simhash 计算过程

生成 shingle


要判断两篇文章是否相同，我们可以使用文章的 md5 来判断。但是，一般那情况下，文章可能只是改动了一小部分，在搜索引擎中，这种情况是非常常见的，所以需要一种算法来检测相似的文章（near-duplicate)。Simhash 是一个相似度散列算法，也就是说内容相似的文本会产生近似的哈希值。Google 就使用 simhash 作为网页判重的标准。

Simhash 通常采用 64-bit 的数字来作为一个文章的代表，而当两个文章的哈希值差异小于等于 3 位的时候，也就是汉明距离小于等于 3 的时候。

文章相似度的检测主要分为两个部分：

1. 哈希值的构建，也就是 simhash 的算法
2. 查询系统，给定一篇文章，我们需要查询与他hash值类似的文章。

## Reference

[1] http://matpalm.com/resemblance/jaccard_coeff/
[2] http://blog.csdn.net/c289054531/article/details/8082952  中文解释
