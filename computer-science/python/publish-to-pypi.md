# 如何发布 Python 代码到 PyPI 上（2018）


ID: 637
Status: publish
Date: 2018-05-19 11:01:00
Modified: 2020-05-16 18:39:15


PyPI 是 Python 的集中仓库。通过把代码上传到 PyPI，其他人就可以使用使用 `pip install xxx` 安装代码了。

Python 的安装工具一直在不断演变，PyPI 的地址也从 pypi.python.org 变到了 pypi.org，因此网上的教程大多数都过时了，官方文档更新比较及时，但是也略过繁琐，这里写一篇简要的教程以飨读者。

本文以作者的库 [aioify](https://github.com/yifeikong/aioify) 为例

# 文件结构

```
.
├── LICENSE.txt
├── MANIFEST.in
├── README.md
├── aioify
│   └── __init__.py
├── setup.cfg
└── setup.py
```

## LICENSE.txt

库的开源协议，建议使用 Apache、MIT 等

## MANIFEST.in

打包要包含的文件，Python 文件会自动包括在内，但是 README.md 不包含在内，所以需要特别注明：

```
include *.md
include LICENSE.txt
```

具体语法参见

## README.md

说明文件，不多数了

## aioify

这个是具体的代码的仓库

## setup.cfg

用于指定 setup.py 的默认参数

```
[metadata]
description-file = README.md
```

## setup.py

这个文件是整个打包过程的关键所在了。请参考下面的注释

```
import os
from distutils.core import setup

# 可选，读取 README 作为下面的 long_description
here = os.path.abspath(os.path.dirname(__file__))

with open(os.path.join(here, &#039;README.md&#039;)) as f:
    long_description = f.read()


setup(
    name = &#039;aioify&#039;,   # 包的名字
    packages = [&#039;aioify&#039;],   # 同上
    version = &#039;0.1.3&#039;,    # 当前版本
    description = &#039;Make every python function async/await&#039;,  # 描述
    long_description = long_description,  # 长描述，会显示在 PyPI 主页上
    long_description_content_type = &#039;text/markdown&#039;,  # 长描述的格式，不过好像markdown支持还不是很好
    author = &#039;Yifei Kong&#039;,  # 作者
    author_email = &#039;kongyifei@gmail.com&#039;,  # 作者邮件
    url = &#039;https://github.com/yifeikong/aioify&#039;,  # 项目地址
    download_url = &#039;https://github.com/yifeikong/aioify/archive/0.1.3.tar.gz&#039;,  # 下载链接，可选
    keywords = [&#039;async&#039;, &#039;await&#039;, &#039;wrap&#039;],  # 关键词
    # 分类器，可以认为是 PyPI 的一些栏目，建议参考文档填写，可选
    classifiers = [
    &#039;Development Status :: 3 - Alpha&#039;,
    &#039;Intended Audience :: Developers&#039;,
    &#039;License :: OSI Approved :: MIT License&#039;,
    &#039;Programming Language :: Python :: 3&#039;,
    &#039;Programming Language :: Python :: 3.5&#039;,
    &#039;Programming Language :: Python :: 3.6&#039;,
    &#039;Programming Language :: Python :: 3.7&#039;,
    ],
    python_requires=&#039;&gt;=3.5&#039;  # 最低 Python 版本
)
```

# 上传

## 本地测试

在项目的根目录，可以使用 pip 安装测试一下，看 setup.py 等文件是否有问题

```
pip install -e .
```

## 注册账户

在 pypi.org 注册一个账户。另外，在 test.pypi.org 再注册一个测试账户，因为两个站之间是独立的，所以得注册两次。

## 配置 .pypirc 文件

打开 ~/.pypirc 输入一下内容：

```
[distutils]
index-servers =
  pypi
  testpypi

[pypi]
username: 你的用户名
password: 密码

[testpypi]
repository:https://test.pypi.org/legacy/
username: 同上
password: 同上
```

## 上传到 test.pypi.org

test.pypi.org 是专门用来在正式上传前测试的服务器，以免操作失误。

打包

```
python setup.py sdist
```

然后可以看到多出了 dist/ 目录

上传

```
pip install twine  # 现在官方推荐使用twine工具
twine upload dist/* --repository testpypi
```

然后到 test.pypi.org/projects/xxx 就可以看到你的代码了~

## 上传到 pypi

一切验证无误之后，就可以上传到 PyPI 了：

```
twine upload dist/*
```

更多细节介绍请参见官方文档：

1. https://packaging.python.org/tutorials/distributing-packages/
2. https://packaging.python.org/guides/using-testpypi/