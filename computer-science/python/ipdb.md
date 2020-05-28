# 使用 ipdb 单步调试 Python 代码


wp_id: 266
Status: publish
Date: 2017-11-27 07:38:30
Modified: 2020-05-16 11:56:30


pdb 是 Python 标准库中自带的 debugger，ipdb 是基于 ipython 的增强版 pdb。

常用命令

* [n]ext 下一步
* [s]tep into 进入函数
* [r]eturn 跳出函数
* [b]reakpoint 打断点

pdb

pdb is fine, just don’t have so many features

Usage: import pdb; pdb.set_trace()

Ipdb is better

Usage: import ipdb; ipdb.set_trace()
n  next
p  print
pp pprint
s  setp into
c  continue to next breakpoint
b  breakpoint
a  args