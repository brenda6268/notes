# Python functools 中有用的一些函数


wp_id: 636
Status: publish
Date: 2018-06-22 08:59:00
Modified: 2020-05-16 11:12:23


functools

partial(fn, *args, **kwargs)

# lru_cache

Decorator to wrap a function with a memoizing callable that saves up to the maxsize most recent calls. It can save time when an expensive or I/O bound function is periodically called with the same arguments.
Since a dictionary is used to cache results, the positional and keyword arguments to the function must be hashable.
If maxsize is set to None, the LRU feature is disabled and the cache can grow without bound. The LRU feature performs best when maxsize is a power-of-two.
If typed is set to true, function arguments of different types will be cached separately. For example, f(3) and f(3.0) will be treated as distinct calls with distinct results.
To help measure the effectiveness of the cache and tune the maxsize parameter, the wrapped function is instrumented with a cache_info() function that returns a named tuple showing hits, misses, maxsize and currsize. In a multi-threaded environment, the hits and misses are approximate.
The decorator also provides a cache_clear() function for clearing or invalidating the cache.

# singledispatch

To define a generic function, decorate it with the @singledispatch decorator. Note that the dispatch happens on the type of the first argument, create your function accordingly

```
@singledispatch
def fun()
    pass

@fun.register(int)
def fun_int()
    pass
```

to get the dispatched func. use fun.dispatch(type)
