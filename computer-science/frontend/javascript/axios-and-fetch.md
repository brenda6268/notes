# 浏览器用于替换 ajax/xhr 的 fetch api

<!--
ID: 5fbf26e0-4b50-4de0-8ac6-f8ebd9456a9b
Status: publish
Date: 2017-06-14T01:37:00
Modified: 2019-12-21T17:07:13
wp_id: 505
-->

fetch 是近年来浏览器实现的一个用于取代 xhr 的 API，相比于 xhr 来说更加简单易用安全且强大。主要区别有：

- fetch 基于 promise，可以使用 await 直接调用；
- fetch 对于 400 和 500 错误依然会正常返回而不会报错。只有在网络错误的时候才会抛出异常；
- fetch 默认只会携带同一个域名下的 cookies，也就是 same-origin，默认更安全；
- fetch 不接受跨域的 Set-Cookie。

## 基本用法

```javascript
const response = await fetch("http://example.com/movies.json");
const myJson = await response.json(); // text() 返回纯文本
console.log(JSON.stringify(myJson));
```

- response.ok 是否请求返回了 2XX 代码
- response.status 返回的状态码，比如 200, 404 等
- await response.blob() 返回二进制文件
- await response.text() 返回文本文件
- await response.json() 返回解析的 json

## 增加选项

```javascript
try {
  // Default options are marked with *
  const response = await fetch(url, {
    method: "POST", // *GET, POST, PUT, DELETE, etc.
    mode: "cors", // no-cors, *cors, same-origin
    cache: "no-cache", // *default, no-cache, reload, force-cache, only-if-cached
    credentials: "same-origin", // include, *same-origin, omit
    headers: {
      "Content-Type": "application/json"
      // "Content-Type": "application/x-www-form-urlencoded",
    },
    redirect: "follow", // manual, *follow, error
    referrer: "no-referrer", // no-referrer, *client
    body: JSON.stringify(data) // body data type must match "Content-Type" header
  });
  console.log(await response.json());
} catch (error) {
  console.error(error);
}
```

## 携带 cookies

fetch 的 credentials 有三个选项：

- `omit` 不携带任何 cookies
- `include` 携带所有 cookies
- `same-origin` 只有向当前网站的同源域名发送请求时才携带 cookies

其中 `same-origin` 是默认选项。

## 使用自定义 headers 和 request

```javascript
const headers = new Headers();
headers.append("Content-Type", "text/plain");
headers.append("Content-Length", content.length.toString());
headers.append("X-Custom-Header", "ProcessThisImmediately");

// 另一种方法是直接使用字典
const headers = new Headers({
  "Content-Type": "text/plain",
})

const init = {
  method: "POST",
  headers: headers,
  mode: "cors",
  cache: "default",
}

const request = new Request("flowers.jpg", init);
const rsp = await fetch(request);
```

## 参考

1. https://developer.mozilla.org/en-US/docs/Web/API/Fetch_API/Using_Fetch
2. https://stackoverflow.com/questions/34558264/fetch-api-with-cookie
3. https://developer.mozilla.org/en-US/docs/Web/API/Request/credentials
