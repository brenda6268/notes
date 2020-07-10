# SVM

Date: 2019-09-04

## sklearn

sklearn 中提供了三个 SVM 的分类方法：SVC、nuSVC 和 linearSVC。其中 SVC 和NuSVC 在数学上是等价的，并且都是基于 libsvm 的。唯一的区别是 SVC 使用参数 C，而 NuSVC 使用参数 Nu。

LinearSVC 基于 liblinear。Linear 大约等价于 SVC 加上 kernel='linear' 参数。但是 liblinear 提供了更多的惩罚和损失函数。

Scale 和 Normalize

In other words Normalizer acts row-wise and StandardScaler column-wise.

## 参考

1. https://datascience.stackexchange.com/questions/51813/what-are-the-differences-between-svc-nusvc-and-linearsvc
2. https://stackoverflow.com/questions/39120942/difference-between-standardscaler-and-normalizer-in-sklearn-preprocessing
3. http://benalexkeen.com/feature-scaling-with-scikit-learn/
4. https://towardsdatascience.com/scale-standardize-or-normalize-with-scikit-learn-6ccc7d176a02
5. https://juejin.im/post/5b7fd39af265da43831fa136
6. https://www.cnblogs.com/giserliu/p/4543457.html
7. https://zhuanlan.zhihu.com/p/39780508