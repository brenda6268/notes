# 使用 Python 提取字幕文件


wp_id: 659
Status: publish
Date: 2018-06-13 01:07:00
Modified: 2020-05-16 11:40:02


最近打算做一个字幕相关的 app，需要从字幕文件中提取出单词。对比了几个库之后，发现 PySubs2 还不错，主要原因是他支持三种主流的字幕文件 `.srt`, `.ass`, `.ssa`。而其他的库往往只支持其中一个，实际使用还需要两个库配合，所以不如直接使用 PySubs 2.

## 用法

因为我的需求主要是解析提取字幕文件，所以这里只讨论相关问题。对于字幕时间轴和样式的编译，可以查看 pysubs2 的官方文档。

因为字幕文件本身结构也比较简单，PySubs2 使用也非常简单，核心只有两个类： SSAFile 和 SSAEvent。其中 SSAFile 指的是一个字幕文件，它像一个数组一样，包含了多个 SSAEvent。下面直接看代码吧：

## 安装

使用 pip

```
pip install pysubs2
```

比如我们有一个srt格式的字幕文件 subtitles.srt：

```
>>> SIMPLE_FILE = """\
... 1
... 00:00:00,000 --> 00:01:00,000
... Once upon a time,
...
... 2
... 00:01:00,000 --> 00:02:00,000
... there was a SubRip file
... <i>with</i> two subtitles.
... """
>>> with open("subtitles.srt", "w") as fp:
...      fp.write(SIMPLE_FILE)
```

可以使用 SSAFile.load 或者 from_string 加载

```
from pysubs2 import SSAFile, SSAEvent, make_time
subs = SSAFile.load("subtitle.srt")
# 或者从字符串中读取
# subs = SSAFile.from_string(字幕数据)
```

可以把 SSAFile 当做数组使用，每个元素都是一个 SSAEvent，也就是一条字幕。SSAEvent 提供了不少方便的属性用于读取。

```
subs[0].text  字幕文字，包含了样式
subs[0].start 字幕开始时间，单位毫秒
subs[0].end   字幕结束时间
subs[0].plaintext 纯文本

>>> for line in subs:
...     print(line.text)
"Once upon a time,"
"there was a SubRip file\\N<i>with</i> two subtitles."
```

注意其中 text 中包含各种格式信息，换行是使用 \N 表示的。如果需要提取纯文本，可以使用 plaintext。