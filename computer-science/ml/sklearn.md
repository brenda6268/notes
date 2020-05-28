# sklearn 入门笔记


wp_id: 481
Status: publish
Date: 2017-11-24 19:35:00
Modified: 2020-05-16 11:56:16


前一阵看了一个叫做 [莫烦Python][1] 的教程，还有 [sklearn的官方教程][2] 初步了解了一下 sklearn 的基本概念，不过教程毕竟有些啰嗦，还是自己记录一下关键要点备忘。

# 机器学习要解决的问题

## 什么是机器学习？

sklearn 给了一个定义

> In general, a learning problem considers a set of n samples of data and then tries to predict properties of unknown data. If each sample is more than a single number and, for instance, a multi-dimensional entry (aka multivariate data), it is said to have several attributes or features.

翻译过来：

总的来说，“学习问题”通过研究一组 n 个样本的数据来预测未知数据的属性。比如说，如果每个样本都不止包含一个数字，而是多维的向量，那么就称它为有多个feature属性。

## 问题

机器学习的方法不外乎这几类，现在自己用到的应该是分类比较多。

1. Classification 分类，也就是离散的
2. Regression 回归，也就是连续的
3. Clustering 聚类
4. Dimensionality reduction 数据降维

要实现上面几个目标，可能需要下面的步骤

1. Model Selection 模型选择
2. Preprocessing 数据预处理

要去判定自己的任务需要用哪种方法，优先参考 sklearn 官方推出的 [cheatsheet](http://scikit-learn.org/stable/tutorial/machine_learning_map/index.html)（小抄）

![sklearn-leanr cheatsheet](http://scikit-learn.org/stable/_static/ml_map.png)

# sklearn 的数据库

sklearn 为了方便学习自带了一些数据库，可以说是非常方便了。包括了 iris 花瓣数据库，手写数字数据库等。这些例子可以说相当于编程语言的 hello world 或者是图形学届的 utah teapot 了。

除了真实的数据集，还可以使用`datasets.make_*`系列函数来直接生成一些数据集用来测试。

代码：

```
>>> from sklearn import datasets
>>> iris = datasets.load_iris()          # iris 花瓣数据库
>>> digits = datasets.load_digits()      # 手写数字数据库
>>> print(digits.data)                   # 数据库的输入
[[  0.   0.   5. ...,   0.   0.   0.]
 [  0.   0.   0. ...,  10.   0.   0.]
 [  0.   0.   0. ...,  16.   9.   0.]
 ...,
 [  0.   0.   1. ...,   6.   0.   0.]
 [  0.   0.   2. ...,  12.   0.   0.]
 [  0.   0.  10. ...,  12.   1.   0.]]
>>> digits.target                        # 数据库的输出
array([0, 1, 2, ..., 8, 9, 8])
```

其中data属性是一个二维数组，格式是`(n_samples, n_features)`.

关于如何载入外部数据库，可以看这里，实际上我也还没看，科科

# 学习与预测

以识别手写数字为例，我们要做的是根据图像识别出数字是什么来。我们需要 *fit* （训练）出来一个 estimator，然后用来 *predict* （预测）未知数据的类型。在 sklearn 中，一个 `estimator` 就是一个实现了 `fit` 和 `predict` 方法的 object。estimator 常用的属性还有 `get_params`, `score` 等。

比如我们使用支持向量机模型：

```
>>> from sklearn import svm
>>> classifier = svm.SVC(gamma=0.001, C=100.)

>>> classifier.fit(digits.data[:-1], digits.target[:-1])  # 注意第一个参数是数据，第二个参数是结果
SVC(C=100.0, cache_size=200, class_weight=None, coef0=0.0,
  decision_function_shape="ovr", degree=3, gamma=0.001, kernel="rbf",
  max_iter=-1, probability=False, random_state=None, shrinking=True,
  tol=0.001, verbose=False)

# 现在我们开始预测最后一个数据
>>> classifier.predict(digits.data[-1:])
array([8])  # 得出的结果是 8

```

实际上的图像是

![last digit](http://scikit-learn.org/stable/_images/sphx_glr_plot_digits_last_image_001.png)

刚刚的例子是使用前面的数据做训练，然后识别了最后一个数字，其实我们还可以使用 sklearn 自带的 `train_test_split` 函数来分割数据

```
from sklearn.model_selection import train_test_split

X_train, X_test, y_train, y_test = train_test_split(
    iris_X, iris_y, test_size=0.3)

# 注意其中训练数据被sklearn打乱了. 在机器学习中, 数据比较乱是比较好的, 算法其实也一样, 数组是乱的最好.
```


完整的例子在这里：http://scikit-learn.org/stable/auto_examples/classification/plot_digits_classification.html

## 保存模型

训练模型还是很花费时间的，我们不可能每次都去训练一个模型，所以一般都是离线训练好了之后，保存下模型来，然后在线调用。保存模型可是直接使用 Python 内置的 pickle 模块，但是一般模型数据都比较大，pickle 对大文件支持不好，最好采用 sklearn 自带的 joblib.

```
>>> from sklearn.externals import joblib
>>> joblib.dump(classifier, "filename.pkl") 

>>> clf = joblib.load("filename.pkl") 
```

很简单吧

# 其他的一些技巧

## 一些约定

上面说到 sklearn 约定了 fit 和 predict 方法，还有一些其他的约定

1. 所有的输入都会被转化为 float64 类型
2. 一半习惯用 `X` 表示样本数据, `y` 表示预测结果

## 可视化

```
>>> X, y = datasets.make_regression(n_samples=100, n_features=1, n_targets=1, noise=10)
>>> plt.scatter(X, y)
>>> plt.show()
```

会有下面的图

![](https://morvanzhou.github.io/static/results/sklearn/2_3_3.png)

[1]: https://morvanzhou.github.io/tutorials/machine-learning/sklearn/1-1-why/
[2]: http://scikit-learn.org/stable/tutorial/basic/tutorial.html