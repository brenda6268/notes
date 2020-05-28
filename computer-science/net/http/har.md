# HAR 格式解析


wp_id: 413
Status: publish
Date: 2018-11-15 20:29:00
Modified: 2020-05-16 11:07:06


HAR(HTTP Archive) 文件是一种常见的用来保存 HTTP 请求和响应的格式。本质上，HAR 文件其实就是一个 JSON 文件。

每一个 HAR Entry 都可以有以下记录存在：

- log
  - creator
  - browser
  - pages
      - pageTimings
  - entries
      - request
          - queryString
          - postData
          - params
      - response
          - cookies
          - headers
          - content
      - cache
      - timings

# log

这个是一个 HAR 文件的根字段，其他字段都是该字段的子字段

```
{
    "log": {
        "version" : "1.2",
        "creator" : {},
        "browser" : {},
        "pages": [],
        "entries": [],
        "comment": ""
    }
}
```

# creator

```
"creator": {
    "name": "Firebug",
    "version": "1.6",
    "comment": ""
}
```

# browser

同 creator 结构完全一样

# pages

```
"pages": [
    {
        "startedDateTime": "2009-04-16T12:07:25.123+01:00",
        "id": "page_0",
        "title": "Test Page",
        "pageTimings": {...},
        "comment": ""
    }
]
```

## pageTimings

```
"pageTimings": {
    "onContentLoad": 1720,
    "onLoad": 2500,
    "comment": ""
}
```

# entries

```
"entries": [
    {
        "pageref": "page_0",
        "startedDateTime": "2009-04-16T12:07:23.596Z",
        "time": 50,
        "request": {...},
        "response": {...},
        "cache": {...},
        "timings": {},
        "serverIPAddress": "10.0.0.1",
        "connection": "52492",
        "comment": ""
    }
]
```

## request

```
"request": {
    "method": "GET",
    "url": "http://www.example.com/path/?param=value",
    "httpVersion": "HTTP/1.1",
    "cookies": [],
    "headers": [],
    "queryString" : [],
    "postData" : {},
    "headersSize" : 150,
    "bodySize" : 0,
    "comment" : ""
}
```

### queryString

```
"queryString": [
    {
        "name": "param1",
        "value": "value1",
        "comment": ""
    },
    {
        "name": "param1",
        "value": "value1",
        "comment": ""
    }
]
```

### postData

```
"postData": {
    "mimeType": "multipart/form-data",
    "params": [],
    "text" : "plain posted data",
    "comment": ""
}
```

#### params

```
"params": [
    {
        "name": "paramName",
        "value": "paramValue",
        "fileName": "example.pdf",
        "contentType": "application/pdf",
        "comment": ""
    }
]
```

## response

```
"response": {
    "status": 200,
    "statusText": "OK",
    "httpVersion": "HTTP/1.1",
    "cookies": [],
    "headers": [],
    "content": {},
    "redirectURL": "",
    "headersSize" : 160,
    "bodySize" : 850,
    "comment" : ""
 }
```

### content

```
"content": {
    "size": 33,
    "compression": 0,
    "mimeType": "text/html; charset=utf-8",
    "text": "\n",
    "comment": ""
}
```

### cookies

```
"cookies": [
    {
        "name": "TestCookie",
        "value": "Cookie Value",
        "path": "/",
        "domain": "www.janodvarko.cz",
        "expires": "2009-07-24T19:20:30.123+02:00",
        "httpOnly": false,
        "secure": false,
        "comment": ""
    }
]
```

### headers

```
"headers": [
    {
        "name": "Accept-Encoding",
        "value": "gzip,deflate",
        "comment": ""
    },
    {
        "name": "Accept-Language",
        "value": "en-us,en;q=0.5",
        "comment": ""
    }
]
```

## cache

```
"cache": {
    "beforeRequest": {},
    "afterRequest": {},
    "comment": ""
}
```

### beforeRequest

```
"beforeRequest": {
    "expires": "2009-04-16T15:50:36",
    "lastAccess": "2009-16-02T15:50:34",
    "eTag": "",
    "hitCount": 0,
    "comment": ""
}
```

## timings

```
"timings": {
    "blocked": 0,
    "dns": -1,
    "connect": 15,
    "send": 20,
    "wait": 38,
    "receive": 12,
    "ssl": -1,
    "comment": ""
}
```

# 参考资料

1. http://www.softwareishard.com/blog/har-12-spec/#response