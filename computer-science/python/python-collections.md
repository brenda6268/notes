# Python 标准库中的容器

<!--
ID: e7cf9864-8975-40dd-9449-3d9d53b597ba
Status: publish
Date: 2017-05-30T04:09:00
Modified: 2020-05-16T11:59:33
wp_id: 649
-->

## namedtuple

a class template to generated memory efficient class

`MyClass = namedtuple('MyClass', [attrib_foo, attrib_bar, ...])`

keys and items of a dict can be used as a set.

## deque

deque is implemented as deque, it can be created with maxlen=N

appendleft, popleft, append, pop

## defaultdict

multidict = defaultdict(list) # builds a multidict using list
multidict = defaultdict(set) # builds a multidict using set

## OrderedDict

it perserves the order as insertion, implemented with a linked list

## Counter

words_count = Counter(words)

Counter.most_common(N)	returns tuple
Counter.update(more)	add more words

counter even supports +/-