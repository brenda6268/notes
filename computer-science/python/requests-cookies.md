# requests cookies 为空的一个坑


wp_id: 676
Status: publish
Date: 2018-09-27 19:10:00
Modified: 2020-05-16 11:24:18


有时候，requests 返回的 cookies 会为空，原因是链接发生了 301/302 跳转，而 cookies 是跟着第一个响应返回的，第二个响应没有返回 Set-Cookie header。所以直接读取 r.cookies 是空的，而在 session.cookies 中是有数据的。

解决方法是直接读 s.cookies。

```
s = requests.Session()
r = s.get("http://httpbin.org/cookies/set?foo=bar")
cookies = requests.utils.dict_from_cookiejar(s.cookies)
s.cookies.clear()
```

不过需要注意的是如果在多线程环境中使用 session 需要注意锁的问题，建议把 session 设置成 thread local 的类型。