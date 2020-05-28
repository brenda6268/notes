# Python 中的正则表达式


wp_id: 646
Status: draft
Date: 2018-06-22 09:00:00
Modified: 2020-05-16 11:12:29


最好的两篇文档

https://github.com/zeeshanu/learn-regex

https://stackoverflow.com/questions/22937618/reference-what-does-this-regex-mean


```py
re.sub(pattern, repl, string)
```

Notes: backreferencing is better with \g<number> not \number

re.match(pattern, string)

match returns match object or None, and always try to match from the beginning, but do not check the end,
match has methods group and groups

re.findall(pattern, string)

if there is no group, return a list of whole match
if there is one group, return a list of string of the group
if there is more than one group, return a list of tuple of all groups

Flags

use with flags=re.XXX
re.IGNORECASE


Unicode
\w will only match Chinese chars, if only re.UNICODE is set, the pattern is unicode, the string is unicode.



str.isalpha will match all characters including chinese. 

when matching Chinese characters, keep everything unicode, and set the re.UNICODE flag.
use unicode pattern, unicode string, unicode replacement, io.open(encoding='utf-8')

\b

all about groups

look behind requires fixed width pattern