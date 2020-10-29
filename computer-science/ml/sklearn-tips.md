# sklearn 小技巧

<!--
ID: acfb166b-60ab-4eed-8d71-30e8c0223418
Status: draft
Date: 2020-10-15T19:29:26
Modified: 2020-10-14T20:06:09
wp_id: 2100
-->

## 切分数据

```py
from sklearn.model_selection import train_test_split

train, test = train_test_split(samples, test_size=0.2)
X_train, X_test, y_train, y_test = train_test_split(X, y, test_size=0.2)
```

## 参考

1. http://scikit-learn.org/stable/modules/generated/sklearn.model_selection.train_test_split.html