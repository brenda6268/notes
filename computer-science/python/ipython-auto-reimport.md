# 在 IPython 中自动重新导入包


wp_id: 789
Status: publish
Date: 2019-10-23 10:23:52
Modified: 2020-05-16 10:48:02


在使用 IPython 交互性测试编写的函数的时候，可以打开自动重新导入包的功能，这样每次保存后就可以直接测试了。

```ipython
In [1]: %load_ext autoreload

In [2]: %autoreload 2
```

其中三个数字的含义是：

- %autoreload 0 - 关闭自动重新导入
- %autoreload 1 - 只在 import 语句重新导入
- %autoreload 2 - 调用的时候自动重新导入

如果想要在 IPython 中自动启用

```bash
$ ipython profile create
$ vim ~/.ipython/profile_default/ipython_config.py
```
```python
c.InteractiveShellApp.extensions = ["autoreload"]
c.InteractiveShellApp.exec_lines = ["%autoreload 2"]
```