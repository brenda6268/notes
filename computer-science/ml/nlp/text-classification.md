# NLP 文本分类初探

<!--
ID: 2f9de484-2132-40e9-988b-3b3b76c577d9
Status: draft
Date: 2020-10-14T11:38:07
Modified: 2020-10-14T11:38:07
wp_id: 2091
-->

手头的机器学习的任务大概分为两类：分类和聚类。本文首先研究下分类的方法。

按照使用的方法不同，分类方法无非分为两类：传统的机器学习方法和基于神经网络的深度学习方法。我们首先来看下传统的机器学习方法。

## 处理过程

1. 收集数据
2. 探索与标注数据
3. 标注数据
4. 选择模型
5. 预处理数据
6. 训练和评估模型
7. 调节超参数

## 收集数据

1. 数据越多越好
2. 样本不要过分不平衡，也就是说最好每一类的数量最好是相等的。
3. 确保你的样本能够覆盖到所有的可能输入，而不是只有常见输入。

## 探索与标注数据

当我们拿到数据之后，首先需要对数据进行一些简单的探索，获得一些感性的认知，然后再去做其他操作。可以查看如下这些指标：

1. 样本的数量
2. 分类的数量
3. 每一个分类样本的数量
4. 每一个样本有多少词
5. 词频分布
6. 样本长度分布

标注数据

要标注数据还是需要一个标注的平台，这里我们先使用命令行标注了一下。大概只标注了 1000 多个，先测试下。

## 使用 fastText 分类

看了下网上关于 fastText 的教程，基本上要么在讲原理，要么很简单，甚至过时了。还不如看官方文档。

### 分词

分词采用 jieba 分词工具，然后参考中文停用词表，去掉停用词。

```
pip install jieba
wget https://raw.githubusercontent.com/goto456/stopwords/master/cn_stopwords.txt
```

## 结论

本文中，我们折腾了半天，发现 fastText 一把梭就挺好用的，如果没啥特别需求的话，建议直接上 fastText, 多快好省！

## 参考

### 基础概念

1. [Google 的文本分类教程](https://developers.google.com/machine-learning/guides/text-classification)
2. [文本分类基础概念](https://monkeylearn.com/text-classification/)
4. [Text Classification: A Survey](https://github.com/kk7nc/Text_Classification)
5. https://freecontent.manning.com/sentence-classification-in-nlp/
6. https://towardsdatascience.com/text-classification-in-python-dd95d264c802
7. https://salt.agency/blog/nlp-and-stuff/

### 工具

1. https://github.com/fxsjy/jieba
2. https://github.com/goto456/stopwords

### FastText

1. [fastText 原理及实践](https://zhuanlan.zhihu.com/p/32965521)
2. [fastText supervised tutorial](https://fasttext.cc/docs/en/supervised-tutorial.html)
3. [Python3 使用 fastText 进行新闻分类](https://blog.csdn.net/asd136912/article/details/80068241)
4. https://towardsdatascience.com/word-embedding-with-word2vec-and-fasttext-a209c1d3e12c
5. https://medium.com/@ravindraprasad/build-your-own-text-classification-in-less-than-25-lines-of-code-using-fasttext-dae7229f80f9
6. https://fasttext.cc/docs/en/python-module.html

### 深度学习

1. [一文读懂深度学习文本分类方法](https://mp.weixin.qq.com/s?__biz=MjM5ODkzMzMwMQ==&mid=2650409973&idx=1&sn=d013228832006e553d312b3df50986dd)
3. https://github.com/yongzhuo/Keras-TextClassification
4. https://github.com/gyunggyung/ALBERT-Text-Classification
5. [卷积神经网络应用于文本分类原理简介](https://zhuanlan.zhihu.com/p/34558743)