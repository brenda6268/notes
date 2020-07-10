# Greenthread 的问题

Date: 2020-03-14

没法进行复杂的CPU运算，可能会导致其他请求超时。
fork and load 相比 load and fork 来说更费内存。

所以 greenthread 也必须能够抢占式调度才行。

可以使用 --preload 来解决 fork and load 的问题，不过 Python 的引用计数还是会导致被复制。

instagram 的做法

1. 因为Python的 GC 会导致 CoW 失效，所以禁用了GC
2. 因为内存还是降不下来，最后实现了能够共享内存的 GC，也就是 gc.freeze()


参考

1. https://instagram-engineering.com/copy-on-write-friendly-python-garbage-collection-ad6ed5233ddf
2. https://instagram-engineering.com/dismissing-python-garbage-collection-at-instagram-4dca40b29172
3. https://rachelbythebay.com/w/2020/03/07/costly/
