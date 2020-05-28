# HTTP 缓存介绍


wp_id: 587
Status: publish
Date: 2017-05-30 02:37:00
Modified: 2020-05-16 11:57:16


和缓存相关的 header 共有如下几种

* `Pragma`
* `Cache-Control`
* `Expires`
* `Last-Modified`
* `Etag`
* `If-Modified-Since`
* `If-Non-Match`


Expires 由服务器返回，用于指定当前页面过期时间，使用绝对时间表示。

Cache-Control 指定了相对过期的时间，由当前时间多久后过期的秒数表示。

```
Cache-Control: max-age=86400
```

Last-Modified 是由服务器给出了文档的过期时间，当第二次请求该文档的时候，浏览器可以使用 If-Modified-Since 头部指定该过期时间，如果文档还没有过期，那么服务器应该返回 304，否则返回 200 和新文档。

Etag 是由服务器给出的文档的哈希值，当第二次请求该文档的时候，浏览器可以使用 If-None-Match 头部指定该哈希值，如果文档没有变动，那么服务器应该返回 304，如果有变动，那么哈希值也变了，应该返回 200 和新文档。

可以看出 Etag 相比 Last-Modified 更准确一些，所以两个头部都有的前提下，应该是 Etag 优先。

实际使用中，为了兼容性考虑，应该把这几种头部都结合起来使用。


## 参考

1. https://www.mnot.net/cache_docs/
2. http://stackoverflow.com/questions/499966/etag-vs-header-expires