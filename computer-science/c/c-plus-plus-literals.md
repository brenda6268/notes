# C++ 字面量


ID: 403
Status: publish
Date: 2017-11-12 02:20:00
Modified: 2020-05-16 11:52:24


# C++中的字典字面量

You can actually do this:

```cpp
std::map&lt;std::string, int&gt; mymap = {{&quot;one&quot;, 1}, {&quot;two&quot;, 2}, {&quot;three&quot;, 3}};
```

What is actually happening here is that std::map stores an std::pair of the key value types, in this case `std::pair<const std::string,int>`. This is only possible because of c++11's new uniform initialization syntax which in this case calls a constructor overload of `std::pair<const std::string,int>`. In this case std::map has a constructor with an `std::intializer_list` which is responsible for the outside braces.

So unlike python's any class you create can use this syntax to initialize itself as long as you create a constructor that takes an initializer list (or uniform initialization syntax is applicable)

https://stackoverflow.com/a/20230177/1061155