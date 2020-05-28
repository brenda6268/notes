# 一些 vim 小技巧


wp_id: 731
Status: publish
Date: 2018-01-18 06:26:00
Modified: 2020-05-16 11:29:58


### 重新对齐文本到固定长度

```
gq<motion>
```

### check if mapping is replaced

`:verbose map <Key>`

using map may cause infinite recursion!


### force set syntax

`# vim: set filetype=javascript`

### exit

使用 Ctrl-C 而不是esc
使用ZZ而不是:wq

### window management

use ctrl-w r to swap pane

### folding

`{selection}zf` or `zf{motion}` for manual folding

### history

Ctrl-O to go back to files
Ctrl-I to go to new files

:%s/pattern//gn

### delete blank lines

:g/^$/d

### run python from vim

:w !python


### nerdtree的使用

使用i和s分别在split中打开文件


不要使用chardet来检测过长的网页，可以检测前一千个字符 chardet.detect(text[:1000])

### 交换两列

:%!awk '{print $2, $1}'

:set fileencoding=utf8
:w myfilename

### add utf-8 BOM
:set bomb  # add BOMB