# Python 中的 iterator 和 generator


wp_id: 628
Status: publish
Date: 2018-05-01 06:19:00
Modified: 2020-05-16 11:38:12


这篇文章里面有不少概念都是错的，需要改进


## 迭代器

In Python, iterable and iterator have specific meanings.

An iterable is an object that has an __iter__ method which returns an iterator, or which defines a __getitem__ method that can take sequential indexes starting from 0 (and raises an IndexError when the indexes are no longer valid). So an iterable is an object that you can get an iterator from.

calling iter(iterable) will return a iterator

An iterator is an object with a next (Python 2) or __next__ (Python 3) method. 
Whenever you use a for loop, or map, or a list comprehension, etc. in Python, the next method is called automatically to get each item from the iterator, thus going through the process of iteration.

## Generators

Generators are iterators, but you can only iterate over them once. It's because they do not store all the values in memory, they generate the values on the fly. 

```py
def generator_function():
    for i in [0, 1, 2]:
        yield i * 2
for item in generator_function():
    print(item)
# Output: 0
# 2
# 4
```

as you can see, generators are typically a filter or mapper between sequences

```py
def fib(n):
    a = b = 1
    for i in range(n):
        yield a
        a, b = b, a + b
```


From <http://book.pythontips.com/en/latest/generators.html>

## 迭代器协议

```py
with open('file') as f:
    try:
        while True:
            value = next(f)
            print value
    except StopIteration:        pass
```

The word “generator” is confusingly used to mean both the function that generates and what it generates. In this chapter, I’ll use the word “generator” to mean the genearted object and “generator function” to mean the function that generates it.

Can you think about how it is working internally?

When a generator function is called, it returns a generator object without even beginning execution of the function. When next method is called for the first time, the function starts executing until it reaches yield statement. The yielded value is returned by the next call.
The following example demonstrates the interplay between yield and call to next method on generator object.