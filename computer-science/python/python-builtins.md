# Python 的内置类型和函数


wp_id: 682
Status: publish
Date: 2018-06-18 00:16:00
Modified: 2020-05-16 11:41:27


# 内置类型

Python的内置类型按照类来分，包括了 numerics, sequences, mappings, files, classes, instances 和 exceptions。对用户自定义类型的实例，如果__nonzero__或者__len__返回是 0 或 False 会被认为是假。

## 注意浅拷贝

```py
>>> lists = [[]] * 3
>>> lists
[[], [], []]
>>> lists[0].append(3)
>>> lists
[[3], [3], [3]]
```

## 字典的一些方法

```py
keys()/values()
iterkeys()/itervalues()
items()/iteritems()
update()
get(key, default)
```

可能会抛出

read/readline/readlines
write/writelines

## 字符串方法

```py
str.capitalize() 	首字母大写
center/ljust/rjust(width, filled_char) 	扩充并使得原字符串居中
decode(codecsm, how_to_handle_erroe) 	throws UnicodeError
encode(codecs, how_to_handle_error) 	throws UnicodeError
startswith(string or tuple)	
endswith(seq, start, end)	
find(seq, start, end)	
isalnum/isalpha/isdigit/islower/isupper/isspace	
lower()/upper()/title()	
strip/lstrip/rstrip(chars)	
partition(seq) 	返回一个三元组前半部分，seq，后半部分
replace(old, new, count)	
split(seq, count)	
splitlines(keepends)	
zfill(width) 	左边填零
```

# 内置函数

## 函数式编程对应的内置函数

```
all
any
callable
filter
iter
map
next
reduce(fn, iter, init)
reload
```

## 操作属性的函数

```
delattr	
dir	return a object"s attributes
getattr(object, name, default)	when default supplied, no exception thrown
hasattr	
globals	
locals
```	

## 内置数学库

```
compile	
complex	
bin	Convert an integer number to a binary string
abs	
divmod	
enumerate	
eval	
execfile	
file	
hex  	
max/min	
oct	
pow
```	

## 类型

```
frozenset	
bool	
dict	
float	note float("NaN"), float("-inf")     
int(x, base=10)	
list	
long	
object
```	

* bytearray可以认为是一个可变的 string
* frozenset是一个immutable, hashable的 set



## 其他函数

```
format
enumerate
id
input/raw_inoput
isinstance(object, class/class_tuple)
insubclass(class, class)
len
open
print
range/xrange(start, stop, step)
```