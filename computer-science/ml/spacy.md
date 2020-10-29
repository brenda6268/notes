# NLP 神器 Spacy

<!--
ID: 8415504c-625c-46f3-a851-4fa1332fc524
Status: draft
Date: 2020-10-17T22:28:28
Modified: 2020-10-17T22:28:28
wp_id: 2101
-->

2020 年的今天，spacy 已经官方支持中文了。

## 安装

```sh
pip install spacy
python -m spacy download zh_core_web_sm
```

## 简单使用

```py
import spacy
sp = spacy.load("zh_core_web_sm")
```

## 参考

1. https://www.biaodianfu.com/spacy.html