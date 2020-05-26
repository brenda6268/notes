# 如何调试 Python 的 Core Dump


ID: 627
Status: publish
Date: 2018-11-12 18:47:00
Modified: 2020-05-16 11:07:57


如果需要记录 Core Dump 的原因，首先需要使用 faulthandler 参数启动 Python

```
python -X faulthandler main.py
```

出 core 之后，可以使用 gdb 调试

```
gdb python core
```

参考

1. https://stackoverflow.com/questions/2663841/python-tracing-a-segmentation-fault/2664232#2664232