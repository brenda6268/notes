# 用于替代ajax的 fetch API


ID: 758
Status: publish
Date: 2017-05-30 03:45:00
Modified: 2020-05-16 11:59:20


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