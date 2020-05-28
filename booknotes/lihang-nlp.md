# 李航：自然语言对话现状与未来


wp_id: 360
Status: draft
Date: 2017-12-23 22:01:00
Modified: 2020-05-16 11:29:03


我条周日大酱汤终于迎来了李航博士分享

# Language Understanding

有歧义的句子

* I ate ice-cream with chocolate.
* I ate ice-cream with a spoon.
* I saw a girl with a telescope.

YN: 计算机缺少人类的经验知识

相关的科学分支

* language and linguistics
* language and brain science (Broca's Area and Wernicke's Area)

人类的语言理解

7万年前突然人类突然掌握了语法


# NLP

|任务| IR | IR structure|
|---|---|---|
|Classification | yes | class
|Matching | no |
|Translation | no |
|Structural Prediction | yes | structure
|Sequential decision process |yes |state and action

## 单轮对话

基于分析|siri|命令式
基于检索|问答
基于生成|chatbot

### 基于分析的方法

```
Utterance --> Analyzer
                |
                v
User      <-- Executor  <-->  Knowledge Base
```

### 基于检索的方法

与搜索类似

### 基于生成的方法


## 多轮对话

用户表述不清楚，通过多轮问答来获取用户意图

# 前沿

* Google: Neural Symbolic Machines
* Huawei: Neural Enquirer and Symbolic Enquirer
* Google: Dialogue Management using Hierarchical Deep Reinforcement Learning