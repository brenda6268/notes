# Pandas 小技巧

<!--
ID: e1490912-3cb8-4b38-a14e-96e353c4f82d
Status: draft
Date: 2020-09-04T07:07:40
Modified: 2020-09-04T07:07:40
wp_id: 1972
-->

## 按某列值排序

基本语法是：`df.loc[CONDITIONS]`. 注意其中用的是中括号 `[]`, 而不是小括号，也就是 `loc` 不是一个函数。

```py
df.loc[df['column_name'] == some_value]
df.loc[(df['column_name'] >= A) & (df['column_name'] <= B)]  # 这里是单个的 `&`
df.loc[~df['column_name'].isin(some_values)]  # 用 ~ 表示否定
```

## 如何按照某列排序

```py
df.sort_values("2")
```

## 复制几列到新的 DataFrame

记得要 copy 一下，以免两个 df 之间冲突

```py
new = old[['A', 'C', 'D']].copy()
```

## 如何添加头部

读取时添加

```py
Cov = pd.read_csv("path/to/file.txt",
                  sep='\t',
                  names=["Sequence", "Start", "End", "Coverage"])
```

读取后添加

```py
Cov = pd.read_csv("path/to/file.txt", sep='\t', header=None)
Cov.columns = ["Sequence", "Start", "End", "Coverage"]
```


## 参考

1. https://stackoverflow.com/questions/34091877/how-to-add-header-row-to-a-pandas-dataframe
2. https://stackoverflow.com/questions/34682828/extracting-specific-selected-columns-to-new-dataframe-as-a-copy
3. https://stackoverflow.com/questions/37787698/how-to-sort-pandas-dataframe-from-one-column
