# Python 2 中的编码问题


wp_id: 633
Status: draft
Date: 2017-05-30 02:59:00
Modified: 2020-05-16 11:57:56


to represent a text, we use a array of characters. we use numbers to represent characters. unicode use the range of 0 - Inf, while ascii use 0-127

str is text representation in bytes, unicode is text representation in characters.
You decode text from bytes to unicode and encode a unicode into bytes with some encoding.
That is:

```py
>>> "abc".decode("utf-8")  # str to unicode
u"abc"
>>> u"abc".encode("utf-8") # unicode to str
"abc" 
```

Python2's problem is:

the default encoding method is ascii! even worse, python throws a error when no ascii byte found!