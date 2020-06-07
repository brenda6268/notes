# 用于替代ajax的 fetch API


ID: 758
Status: publish
Date: 2017-05-30 03:45:00
Modified: 2020-05-16 11:59:20

Date: 2019-12-08


fetch 对于 400 和 500 错误依然会正常返回而不会报错。只有在网络错误的时候才会抛出异常
fetch 默认只会携带同一个域名下的 cookies，也就是 same-origin。
fetch 不接受跨域的 Set-Cookie

# 基本用法

const response = await fetch('http://example.com/movies.json');
const myJson = await response.json(); // text() 返回纯文本
console.log(JSON.stringify(myJson));

response.ok 是否请求返回了 2XX 代码
response.status 返回的状态码

# 增加选项

fetch is the new and easy api for js to make request to the server, it replaces XMLHttpRequest.

## Objects:

fetch, Request, Reponse, Headers

## Usage:

```
fetch(&#039;/path/to/fetch&#039;,
    {method: &#039;GET&#039;}
).then(function (response) {
    // process response;
    return response.json(); // returns a json promise
    return response.text(); // returns a text promise


    return ret; // will be consumed in the next then funcion
}).then(function (data) {
    // data is a json or text
    // process
}).catch(function (err) {

    // error handling
});
```

notice, the useful method 


Advanced: