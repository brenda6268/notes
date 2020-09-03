# Greenthread 的问题

<!--
ID: 49a39397-e4f2-4374-83b5-999f42bd0416
Status: draft
Date: 2020-03-14T00:00:00
Modified: 2020-07-08T12:11:58
wp_id: 1499
-->

没法进行复杂的 CPU 运算，可能会导致其他请求超时。
fork and load 相比 load and fork 来说更费内存。

所以 greenthread 也必须能够抢占式调度才行。

可以使用 --preload 来解决 fork and load 的问题，不过 Python 的引用计数还是会导致被复制。

instagram 的做法

1. 因为 Python 的 GC 会导致 CoW 失效，所以禁用了 GC
2. 因为内存还是降不下来，最后实现了能够共享内存的 GC，也就是 gc.freeze()


参考

1. https://instagram-engineering.com/copy-on-write-friendly-python-garbage-collection-ad6ed5233ddf
2. https://instagram-engineering.com/dismissing-python-garbage-collection-at-instagram-4dca40b29172
3. https://rachelbythebay.com/w/2020/03/07/costly/
