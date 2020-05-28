# readline library


wp_id: 620
Status: publish
Date: 2017-05-30 12:51:00
Modified: 2017-05-30 12:51:00


readline is widely used input lib, all the key bindings are from emacs

GNU readline key bindings

```
key	action	note
^a	moves the cursor to the beginning of the line	 a 是第一个字母
^b	moves it one position to the left	 b 是 back 的缩写
^c	send SIGINT or KeybordInterrupt	
^d	send eof on empty line	
^d	erase next char	
^e	to the end	 e 表示 end
^f	 把光标向前移动一格	 f 表示 forward
^h	 把光标向前删除	 h 表示 histroy?
^i	自动补全, 和 tab 功能一样	
^k	删除到行尾	 k表示kill
^y	粘贴删除的字符	 y 表示 yank
^_	undo	
^p	previous	
^n	next	
^r	reverse search	r for reverse
^s	search	s for search
```

Using readline in python

actually the input function is just readline enabled, the missing functionality is history support