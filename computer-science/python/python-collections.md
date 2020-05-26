# Python 标准库中的容器


ID: 649
Status: publish
Date: 2017-05-30 04:09:00
Modified: 2020-05-16 11:59:33


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