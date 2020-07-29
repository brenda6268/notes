# Python and JavaScript for asyncio

<!--
ID: 02109919-fc18-4333-9eff-26f66411e982
Status: draft
Date: 2017-06-16T12:25:00
Modified: 2020-05-16T11:43:19
wp_id: 663
-->

# Python asyncio
## how to run tasks parallelly
python uses aio.ensure_future

an async function in python is called a coroutine function, by calling it, returns a coroutine object.
an async funciont in javascript is called an async function

in python, you await on a Future,
in javascript, you await on a Promise

aio.Task is a Future and it wraps a coroutine
aio.ensure_future(coro) wraps a coroutine in a Task/Future and returns it

aio.ensure_future and loop.create_task are almost the same, you should use aio.ensure_future

aio.gather wait and gathers the results
aio.wait wait for the coroutines to finish. 1. you have to mannually collect them, 2. you can specify the behavior, not wait for all




# promise and future
promise and future both represent a object that it's return value will be set in the future.

```
JavaScript

Promise.resolve
```

```
# Python
Future.set_result
```