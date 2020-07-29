# dabeaz：Python 中 asyncio 的另一种实现

<!--
ID: 61a76a6a-b514-427a-9698-5bd6680c6df1
Status: draft
Date: 2018-06-23T02:28:00
Modified: 2020-05-16T11:14:20
wp_id: 661
-->

Python 中异步编程的发展历史

```
Polling -> callback -> Futures/Deferred -> Generators -> Inlined Callbacks
-> Coroutine -> yield from -> asyncio -> async/await
```

或许我们不需要中间这些步骤，可以直接在 polling 的基础上实现 async/await. async 也不应该是一个实现、一个库、或者 asyncio，而应该是一个接口。