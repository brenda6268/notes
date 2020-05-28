# 面向对象的思考


wp_id: 333
Status: draft
Date: 2017-05-30 03:39:00
Modified: 2020-05-16 11:58:57


## inheritance vs composition vs aggregation

优先考虑组合，当很复杂时考虑聚合，然后是继承。聚合与组合的区别，在于聚合的对象实现了一个接口，便于 pipeline 调用。

组合用于想在新类中使用现有class的功能，而不是实现接口时。可以问自己是否需要向上转型，如果向上转型，那么继承是必须的


## 面向对象的实现

面向对象不一定要用类来实现，比如在C中也需要用到很多面向对象的思想，js，lua也没有实现类的完整机制，lua有实现方法调用的语法糖，通过编写一个new方法，把自身的__index设置为

sometimes, especially for single method classes, a closure might be a better solution:

```
    class Fetch:
        def __init__(self):
            self.proxy = proxy
            self.cookie_jar = cookie_jar
        def fetch(self)
            urlopen(url, self.proxy, self.cookie_jar)

    def build_fetcher(proxy, cookie_jar):
        def fetch(url):
            urlopen(url, proxy, cookie_jar)
        return fetch
```

## OOP vs FP
