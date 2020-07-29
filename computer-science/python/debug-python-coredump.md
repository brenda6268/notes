# 如何调试 Python 的 Core Dump

<!--
ID: 6c8a9607-3a94-4f3f-a75e-951aadcde883
Status: publish
Date: 2018-11-12T18:47:00
Modified: 2020-05-16T11:07:57
wp_id: 627
-->

如果需要记录 Core Dump 的原因，首先需要使用 faulthandler 参数启动 Python

```
python -X faulthandler main.py
```

出 core 之后，可以使用 gdb 调试

```
gdb python core
```

## 参考

1. https://stackoverflow.com/questions/2663841/python-tracing-a-segmentation-fault/2664232#2664232