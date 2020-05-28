# Get 和 Post 方法的选择和URL的设计


wp_id: 585
Status: publish
Date: 2018-07-10 08:59:00
Modified: 2020-05-16 11:15:14


HTTP 中常用的方法有 GET/POST/PUT/DELETE 等，在设计API或者表单的时候我们需要选择合适的方法。一般有两种方案：

1. 只使用 GET 和 POST，GET 主要用来读取数据，POST 用来创建或者更新数据。
2. RESTful的方法，GET/POST/PUT/DELETE 分别用来增删改查。

## URL 的设计

为了探讨两种方案，首先我们来看一下 URL 的设计。URL 是 Universal Resource Locator 的缩写，也就是一个 URL 表示的是唯一的一个资源，所以这个资源的 id 或者说主键应该是放在 URL 路径中的。

比如一个好的设计：

```
http://example.com/post/1234
```

不好的设计

```
http://example.com/post?id=1234
```

而控制这个资源展示方式的其他字段可以作为参数：

```
http://exmaple.com/post/1234?lang=zh&amp;utm_source=google
```

## HTTP 方法的含义

好多人对于 http 方法的理解是 GET 是参数在url里，而POST是参数在 body 里面，这样理解是不对的。

在上述的两种方案中，GET 都是用来读取资源的，一般来说不要对资源进行任何更新操作，也就是没有副作用。比如说

不好的设计：
```
GET http://example.com/post/1234?action=delete
```

上面的设计意图通过GET操作来删除一个资源，这样非常不好。比如说如果浏览器具有预缓存页面的功能，那么预先读取这个链接的时候就把对应的资源删掉了。

一般来说，GET 方法还要求幂等性，也就是无论多少次操作，最终结果和操作一次都是一样的。GET 操作的参数受到 url 长度的限制，当参数超过 1k 的时候，可以使用 POST 代替。不过这时候你首先应该想一下这么多参数是不是都有用，是不是设计有问题。

POST 方法可以用来创建资源，比如说：

```
POST http://example.com/post/

content=xxxxxxx&amp;author=xxxx&amp;date=xxxx
```

POST 操作具有副作用，也就是说会更改服务器上的状态。另外 POST 操作一般不是幂等的，每次 POST 操作都应该创建一个新的资源。

PUT 操作用来更新资源，也是幂等的。

```
PUT http://example.com/post/1234

content=yyyyyy
```

DELETE 用来删除资源，值得注意的是，根据规范 DELETE 方法不能带有 body。

```
DELETE http://example.com/post/1234
```