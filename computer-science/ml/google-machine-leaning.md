# Google 关于Machine Leaning 的笔记


wp_id: 475
Status: publish
Date: 2017-12-16 19:09:00
Modified: 2020-05-16 11:28:17


前几天看了 Google 的一个关于 Machine Learning 的[slides][1]，感觉不错，整理一下学习笔记

# ML 的定义

> An approach to achieve artificial intelligence through systems that can learn from experience to find patterns in that data

> ML teaches a computer to recognise patterns by examples, rather than programming it with specific rules.

一个例子：

![](https://ws1.sinaimg.cn/large/006tNc79gy1fmjv6ugbr4j31jw0mo4qp.jpg)

# feature

一般来说，几个属性就代表了几个维度。

<img width=300 src=https://ws3.sinaimg.cn/large/006tNc79gy1fmjllksmxfj30ma0omwg0.jpg />

有时候更多的维度，更容易做出分类：参考[这里](http://www.visiondummy.com/2014/04/curse-dimensionality-affect-classification/)

<img width=300 src=https://ws2.sinaimg.cn/large/006tNc79gy1fmjnimu1pyj30qw0uaqe7.jpg />

<img width=300 src=https://ws3.sinaimg.cn/large/006tNc79gy1fmjnptevb6j30mk0gkwhb.jpg />

# 机器学习的分类

## 监督学习

数据是标注过的

## 无监督的学习

从没有标注的数据中学习

<img width=300 src=https://ws3.sinaimg.cn/large/006tNc79gy1fmjnt7mzroj30os0nowg1.jpg />

## 强化学习

通过带有激励的试错来学习

# 例子

## 线性回归（Linear Regression）

<img width=300 src=https://ws1.sinaimg.cn/large/006tNc79gy1fmjo16iq86j30hy0b4gmc.jpg />

## 聚类

<img width=300 src=https://ws4.sinaimg.cn/large/006tNc79gy1fmjo292bd4j30nu0o475r.jpg />

## KNN

<img width=300 src=https://ws4.sinaimg.cn/large/006tNc79gy1fmjo31w9wnj30nm0iuq3r.jpg />

## 神经网络

<img src=https://ws2.sinaimg.cn/large/006tNc79gy1fmjo8g08s2j31ie0h07b4.jpg />

## fully-connected 神经网络

<img src=https://ws3.sinaimg.cn/large/006tNc79gy1fmjo81ka29j31kw0l9wr1.jpg />

## 深度神经网络（DNN）

深度的意思就是有很多的层。比如说，对于人脸识别，其中某些层可能会识别出线条，然后有的层会识别出眼睛等等

## 卷积神经网络（CNN）

CNN 可以用来处理图片数据，以及可以表示为图片的数据。要确定一组数据可不可以表示为图片，可以尝试交换任意两行，或者任意两列，如果交换后对数据没有影响，那么就不可以被认为是图片数据。更多细节参看这个 [Video][2]



# 算法的分类

详细讲解请看[这里][1]

## Regression

回归首先要有一个评价误差的方法，然后迭代的求出模型。回归是一类从统计中得出的方法，比如上面说到的 线性回归（用最小二乘法），还有逻辑回归等等。

<img width=300 src=https://ws3.sinaimg.cn/large/006tNc79gy1fmjq0fm7qsj30fa0euabi.jpg />

## Instance Based

Instance Based 是一个决策方法。通过相似度计算找出最接近的实例。比如KNN

<img width=300 src=https://ws2.sinaimg.cn/large/006tNc79gy1fmjpzyw85ej30f40h2dhc.jpg />

## Decision Tree

自定向下，做出决策

<img width=300 src=https://ws2.sinaimg.cn/large/006tNc79gy1fmjpzktongj30ho0guwg1.jpg />

## Bayesian

<img width=300 src=https://ws2.sinaimg.cn/large/006tNc79gy1fmjq298126j30fs0fe404.jpg />


## clustering

<img width=300 src=https://ws1.sinaimg.cn/large/006tNc79gy1fmjsnszjsnj30ea0fajsp.jpg />

## association rules

<img width=300 src=https://ws3.sinaimg.cn/large/006tNc79gy1fmjsp79sk7j30eo0h4abg.jpg />

## Artificial Neural Network

模拟人的神经系统，比如感知机

<img width=300 src=https://ws4.sinaimg.cn/large/006tNc79gy1fmjsqfb0uij30ge0hejsj.jpg />

## 深度学习

其实就是很多层的神经网络，比如CNN

<img width=300 src=https://ws2.sinaimg.cn/large/006tNc79gy1fmju4bxxz6j30fs0goq5h.jpg />

## 降维 (Dimensionality Reduction)

找到数据的内在属性，然后缩减维度，以便能够使用监督学习方法

<img width=300 src=https://ws1.sinaimg.cn/large/006tNc79gy1fmju5kon3tj30fu0hc3zm.jpg />

还有一个ensemble没看懂

# 机器学习的输出

## 连续输出

比如拟合好的线性回归跟定一个数值，可以预测另一个数值

## 概率预测

## 分类

比如分辨出小猫小狗，或者是识别数字


[1]: https://docs.google.com/presentation/d/1kSuQyW5DTnkVaZEjGYCkfOxvzCqGEFzWBy4e9Uedd9k/preview
[2]: https://youtu.be/FmpDIaiMIeA
[3]: https://machinelearningmastery.com/a-tour-of-machine-learning-algorithms/