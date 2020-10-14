# 短文本情感分析实战

<!--
ID: badec391-e157-47fd-91cd-c95f5dbe11bd
Status: draft
Date: 2020-10-03T22:38:59
Modified: 2020-10-03T22:38:59
wp_id: 2080
-->

文本的向量化自然是采用 Word2vec. word2vec 有两种表示方式，一种是 CBOW, 也就是用上下文来预测空缺的文本，另一种是 skipgram, 也就是用词来预测上下文。在这两种方法中，CBOW 可以很好地表示一词多义，比如说 Apple 可能指一个水果，也可能指一家公司，有些时候还会用来指 iPhone.

fasttext 是 facebook 出品的另一个文本向量化的工具，从原理上来说和 word2vec 相比没有啥突破，但是在工程上完爆传统的 word2vec 了。

## 参考

- [一文看懂 NLP 中的文本情感分析任务](https://www.infoq.cn/article/XGoSsRfZRSupblTGGJCM)
- https://medium.com/district-data-labs/modern-methods-for-sentiment-analysis-694eaf725244
- https://github.com/linanqiu/word2vec-sentiments/blob/master/word2vec-sentiment.ipynb
- [word2vec 词向量中文语料处理 (python gensim word2vec 总结）](https://blog.csdn.net/shuihupo/article/details/85162237)
- https://towardsdatascience.com/sentiment-analysis-using-albert-938eb9029744
- https://towardsdatascience.com/updated-text-preprocessing-techniques-for-sentiment-analysis-549af7fe412a
- https://monkeylearn.com/blog/aspect-based-sentiment-analysis/