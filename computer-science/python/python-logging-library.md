# 在 Python 中打印日志


wp_id: 643
Status: publish
Date: 2017-05-30 03:54:00
Modified: 2019-10-09 14:02:13


## 日志的作用

 - 记录程序的运行情况，比如是否发生错误等。
 - 记录业务相关的信息，可以用于后续分析。

## 基础用法

日志应该看作是事件流, 不要自己管理日志, 把日志输出到 stdout。如果使用 systemd 来运行程序的话, 直接把所有日志打印到stdout就可以了。

logging模块是thread safe的, 至少理论上来说是的...

直接使用 logging 的方法来打印日志

```py
# basicConfig 只能在主线程中调用一次
logging.basicConfig(level=level, format=fmt_string, filename=xxx, datefmt=datefmt)

logging.debug("%string", args)  # send to format string as message
```

生成 logger 再打日志

```py
import logging

log = logging.getLogger(__name__)

log.setLevel(logging.INFO)  # 设置logger的级别

handler = logging.NullHandler()
handler.setLevel(logging.INFO)  # 设置handler的级别

formatter = logging.Formatter("%(asctime)s - %(name)s - %(levelname)s - %(message)s")
handler.setFormatter(formatter)

log.addHandler(handler)

if __name__ == "__main__":
    main()
```

如果需要打印异常的话，一定要用 `logging.exception`，不要用 `logging.error`，这样还可以打印出异常堆栈。

## 进阶教程

logging 模块提供了四种不同的模块

* Loggers 打日志
* Handlers 把 logger 的日志发送到该处理的地方
* Filters filter 过滤出需要的日志
* Formatters 确定需要打印的日志的格式

logger 是一棵树，默认的logger 是 root logger，logging 模块的方法也都是在调用这个logger

## 在日志中添加额外信息

可以使用 `logging.LoggerAdapter`。

```python
class CustomAdapter(logging.LoggerAdapter):
    """
    This example adapter expects the passed in dict-like object to have a
    "connid" key, whose value in brackets is prepended to the log message.
    """
    def process(self, msg, kwargs):
        return "[%s] %s" % (self.extra["connid"], msg), kwargs

logger = logging.getLogger(__name__)
adapter = CustomAdapter(logger, {"connid": some_conn_id})
```


## 在编写的库中打印日志

库只应该定义自己的日志的格式, 而不应该定义自己的日志如何输出, 日志输出应该由最终的使用程序来定义。

### get Logger

You should use the factory method logging.getLogger(name) to instaniate a logger object, the name is supposed to be foo.bar.baz, so the recommnend value is `__name__`，That’s because in a module, `__name__` is the module’s name in the Python package namespace.

### in lib.py

```
logger = logging.getLogger(__name__)
logger.addHandler(logging.NullHandler())

logger.debug("")
```

### in app.py

```
logging.basicConfig()  # seems like logging.start... must be called to enable logging
```

## 关闭第三方日志

```
logging.getLogger("requests").setLevel(logging.WARNING)
```

## 参考

1. http://docs.python-guide.org/en/latest/writing/logging/
2. https://docs.python.org/3/howto/logging-cookbook.html#using-loggeradapters-to-impart-contextual-information