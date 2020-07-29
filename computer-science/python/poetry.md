# 无标题

<!--
ID: 32346a75-7d6b-4492-b942-64288706cdb1
Status: draft
Date: 2020-05-28T14:09:32
Modified: 2020-05-28T14:09:32
wp_id: 1280
-->

## 初始化

创建一个新的文件夹并初始化

```
poetry new PROJECT_NAME
```

在已有的项目文件夹中初始化

```
poetry init
```

这两个命令最重要的功能是创建了 `pyproject.toml` 文件：

```toml
[tool.poetry]
name = "poetry-demo"
version = "0.1.0"
description = ""
authors = ["Yifei Kong <kong@yifei.me>"]

[tool.poetry.dependencies]
python = "^3.6"

[tool.poetry.dev-dependencies]
pytest = "^3.5"
```

## 安装依赖

```
poetry add flask
poetry add --dev black  # 添加开发依赖
poetry add --optional black  # 添加可选依赖
```

同时会保存到 `pyproject.toml` 文件中

```
[tool.poetry.dependencies]
flask = "^1.1"
```

其中 `^1.1` 的意思是 `>=1.1, <2.0`。也就是大版本号相同，小版本号有最低要求。

或者你也可以现在 pyproject.toml 中定义，然后执行 `poetry install` 来安装。

poetry 在安装完成后，还会把使用的具体版本信息保存到 poetry.lock 文件中，这个文件也应该保存到版本管理系统中。但是如果你正在开发的是一个库的话，就没有必要了。如果你想要更新到最新版本的话，可以使用 poetry update 命令。

删除依赖

```
poetry remove flask
```

导出到 requirements.txt 格式：

```
poetry export -f requirements.txt > requirements.txt
```

## 发布到 PyPI

首先配置 PyPI.org 的账户名和密码

```
poetry config http-basic.pypi username password  // 使用账户名和密码
```

然后直接发布就行了，非常简单

```
poetry publish --build
```

## 配置

poetry 也有他奇葩的地方，比如说存储配置文件的地方：

```
```

poetry config --list 显示当前的配置

## 运行命令

在 pyproject.toml 中添加如下配置：

```
[tool.poetry.scripts]
my-script = "my_module:main"
```

就可以通过 peotry 执行：

```
poetry run my-script
```

如果你


https://levelup.gitconnected.com/how-to-publish-a-python-command-line-application-to-pypi-5b97a6d586f1

