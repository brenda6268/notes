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