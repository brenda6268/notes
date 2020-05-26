# HAR 格式解析


ID: 413
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
    &quot;log&quot;: {
        &quot;version&quot; : &quot;1.2&quot;,
        &quot;creator&quot; : {},
        &quot;browser&quot; : {},
        &quot;pages&quot;: [],
        &quot;entries&quot;: [],
        &quot;comment&quot;: &quot;&quot;
    }
}
```

# creator

```
&quot;creator&quot;: {
    &quot;name&quot;: &quot;Firebug&quot;,
    &quot;version&quot;: &quot;1.6&quot;,
    &quot;comment&quot;: &quot;&quot;
}
```

# browser

同 creator 结构完全一样

# pages

```
&quot;pages&quot;: [
    {
        &quot;startedDateTime&quot;: &quot;2009-04-16T12:07:25.123+01:00&quot;,
        &quot;id&quot;: &quot;page_0&quot;,
        &quot;title&quot;: &quot;Test Page&quot;,
        &quot;pageTimings&quot;: {...},
        &quot;comment&quot;: &quot;&quot;
    }
]
```

## pageTimings

```
&quot;pageTimings&quot;: {
    &quot;onContentLoad&quot;: 1720,
    &quot;onLoad&quot;: 2500,
    &quot;comment&quot;: &quot;&quot;
}
```

# entries

```
&quot;entries&quot;: [
    {
        &quot;pageref&quot;: &quot;page_0&quot;,
        &quot;startedDateTime&quot;: &quot;2009-04-16T12:07:23.596Z&quot;,
        &quot;time&quot;: 50,
        &quot;request&quot;: {...},
        &quot;response&quot;: {...},
        &quot;cache&quot;: {...},
        &quot;timings&quot;: {},
        &quot;serverIPAddress&quot;: &quot;10.0.0.1&quot;,
        &quot;connection&quot;: &quot;52492&quot;,
        &quot;comment&quot;: &quot;&quot;
    }
]
```

## request

```
&quot;request&quot;: {
    &quot;method&quot;: &quot;GET&quot;,
    &quot;url&quot;: &quot;http://www.example.com/path/?param=value&quot;,
    &quot;httpVersion&quot;: &quot;HTTP/1.1&quot;,
    &quot;cookies&quot;: [],
    &quot;headers&quot;: [],
    &quot;queryString&quot; : [],
    &quot;postData&quot; : {},
    &quot;headersSize&quot; : 150,
    &quot;bodySize&quot; : 0,
    &quot;comment&quot; : &quot;&quot;
}
```

### queryString

```
&quot;queryString&quot;: [
    {
        &quot;name&quot;: &quot;param1&quot;,
        &quot;value&quot;: &quot;value1&quot;,
        &quot;comment&quot;: &quot;&quot;
    },
    {
        &quot;name&quot;: &quot;param1&quot;,
        &quot;value&quot;: &quot;value1&quot;,
        &quot;comment&quot;: &quot;&quot;
    }
]
```

### postData

```
&quot;postData&quot;: {
    &quot;mimeType&quot;: &quot;multipart/form-data&quot;,
    &quot;params&quot;: [],
    &quot;text&quot; : &quot;plain posted data&quot;,
    &quot;comment&quot;: &quot;&quot;
}
```

#### params

```
&quot;params&quot;: [
    {
        &quot;name&quot;: &quot;paramName&quot;,
        &quot;value&quot;: &quot;paramValue&quot;,
        &quot;fileName&quot;: &quot;example.pdf&quot;,
        &quot;contentType&quot;: &quot;application/pdf&quot;,
        &quot;comment&quot;: &quot;&quot;
    }
]
```

## response

```
&quot;response&quot;: {
    &quot;status&quot;: 200,
    &quot;statusText&quot;: &quot;OK&quot;,
    &quot;httpVersion&quot;: &quot;HTTP/1.1&quot;,
    &quot;cookies&quot;: [],
    &quot;headers&quot;: [],
    &quot;content&quot;: {},
    &quot;redirectURL&quot;: &quot;&quot;,
    &quot;headersSize&quot; : 160,
    &quot;bodySize&quot; : 850,
    &quot;comment&quot; : &quot;&quot;
 }
```

### content

```
&quot;content&quot;: {
    &quot;size&quot;: 33,
    &quot;compression&quot;: 0,
    &quot;mimeType&quot;: &quot;text/html; charset=utf-8&quot;,
    &quot;text&quot;: &quot;\n&quot;,
    &quot;comment&quot;: &quot;&quot;
}
```

### cookies

```
&quot;cookies&quot;: [
    {
        &quot;name&quot;: &quot;TestCookie&quot;,
        &quot;value&quot;: &quot;Cookie Value&quot;,
        &quot;path&quot;: &quot;/&quot;,
        &quot;domain&quot;: &quot;www.janodvarko.cz&quot;,
        &quot;expires&quot;: &quot;2009-07-24T19:20:30.123+02:00&quot;,
        &quot;httpOnly&quot;: false,
        &quot;secure&quot;: false,
        &quot;comment&quot;: &quot;&quot;
    }
]
```

### headers

```
&quot;headers&quot;: [
    {
        &quot;name&quot;: &quot;Accept-Encoding&quot;,
        &quot;value&quot;: &quot;gzip,deflate&quot;,
        &quot;comment&quot;: &quot;&quot;
    },
    {
        &quot;name&quot;: &quot;Accept-Language&quot;,
        &quot;value&quot;: &quot;en-us,en;q=0.5&quot;,
        &quot;comment&quot;: &quot;&quot;
    }
]
```

## cache

```
&quot;cache&quot;: {
    &quot;beforeRequest&quot;: {},
    &quot;afterRequest&quot;: {},
    &quot;comment&quot;: &quot;&quot;
}
```

### beforeRequest

```
&quot;beforeRequest&quot;: {
    &quot;expires&quot;: &quot;2009-04-16T15:50:36&quot;,
    &quot;lastAccess&quot;: &quot;2009-16-02T15:50:34&quot;,
    &quot;eTag&quot;: &quot;&quot;,
    &quot;hitCount&quot;: 0,
    &quot;comment&quot;: &quot;&quot;
}
```

## timings

```
&quot;timings&quot;: {
    &quot;blocked&quot;: 0,
    &quot;dns&quot;: -1,
    &quot;connect&quot;: 15,
    &quot;send&quot;: 20,
    &quot;wait&quot;: 38,
    &quot;receive&quot;: 12,
    &quot;ssl&quot;: -1,
    &quot;comment&quot;: &quot;&quot;
}
```

# 参考资料

1. http://www.softwareishard.com/blog/har-12-spec/#response