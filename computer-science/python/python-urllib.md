# Python urllib 模块


wp_id: 671
Status: publish
Date: 2018-05-01 14:36:00
Modified: 2020-05-16 11:38:16


YN：网络访问的时候一定要记得设置一个合理的超时

在 Python2 中，有两个urllib：urllib 和 urllib2，urllib基本只使用urllib.urlencode(), urllib.quote函数，其他功能都被对应的 urllib2中的函数替代了。

Python3 把这两个模块进行了合并并拆分成了子模块，只使用 urllib 就好了。

# 发送 http 请求

## 直接使用 urlopen

```
urllib.request.urlopen(url, data=None, [timeout, ] *, context) -> http.client.HTTPResponse
```

用于发送 GET 或者 POST 请求，如果有data，则发送的是 POST 请求.返回一个 file-like的http.client.HTTPResponse对象，这个对象也可以作为一个 context manager。

info() | 返回headers
gerurl() | 返回 url，常用于判定是否被重定向
getcode() | 
read()/readlines() | 返回文件内容

```
>>> import urllib.request
>>> with urllib.request.urlopen("http://www.python.org/") as f:
...     print(f.read(300))
...
b"<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN"
"http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">\n\n\n<html
xmlns="http://www.w3.org/1999/xhtml" xml:lang="en" lang="en">\n\n<head>\n
<meta http-equiv="content-type" content="text/html; charset=utf-8" />\n
<title>Python Programming "
```

## 使用 Request 对象

如果需要更改默认的 header 等数据或者使用 PUT、DELETE 等方法，urlopen 还可以接受一个 Request对象，可以在 Request 对象中更改。

Request 对象的定义：

```
class urllib.request.Request(url, data=None, headers={}, origin_req_host=None, unverifiable=False, method=None)
```

一个 request可以指定 method， url，可以使用 req.add_header添加header。

可以使用 add_header 方法再添加额外的header，但是实际上是 set_header，并不能添加重复的，不要被名字迷惑了。

## 使用 Opener
 
urilib2.build_opener 返回一个打开器(OpenerDirector)，用于设定发出请求要经过的一些处理，可以设定代理，处理 cookie 等。OpenerDirector有一个属性addheaders，把他设定为一个包含键值 tuple 的 list，这样使用 opener 发送的每一个请求都会添加上这个 header。

Then you could use opener.open instead of urllib2.urlopen

Typical usage:

```
import urllib2
import urllib
from cookielib import CookieJar
cj = CookieJar()
opener = urllib2.build_opener(urllib2.HTTPCookieProcessor(cj))
# input-type values from the html form
formdata = { "username" : username, "password": password, "form-id" : "1234" }
data_encoded = urllib.urlencode(formdata)
response = opener.open("https://page.com/login.php", data_encoded)
```

```
import urllib.request
opener = urllib.request.build_opener()
opener.addheaders = [("User-agent", "Mozilla/5.0")]
opener.open("http://www.example.com/")
```

From <http://stackoverflow.com/questions/3334809/python-urllib2-how-to-send-cookie-with-urlopen-request> 

# 异常：URLError HTTPError

URLError是 IOError 的子类, HTTPError.code is the http code 

# urllib.parse

urlparse and urlunparse is not as good as urlsplit

## urlsplit

return a five element tuple by scheme://netloc/path?query#fragment

Attribute	Index	Value	Value if not present
scheme	0	URL scheme specifier	scheme parameter
netloc	1	Network location part	empty string
path	2	Hierarchical path	empty string
query	3	Query component	empty string
fragment	4	Fragment identifier	empty string
username	 	User name	None
password	 	Password	None
hostname	 	Host name (lower case)	None
port	 	Port number as integer, if present	None

note，the netloc contains domain and port

```
>>> urlsplit("www.cwi.nl/%7Eguido/Python.html")
SplitResult(scheme="", netloc="", path="www.cwi.nl/%7Eguido/Python.html", query="", fragment="")
# notice the netloc will be wrong if "//" is missing
>>> urlsplit("//www.cwi.nl/%7Eguido/Python.html")
SplitResult(scheme="", netloc="www.cwi.nl", path="/%7Eguido/Python.html", query="", fragment="")
```

urlunsplit join the parse result。

```
parse_qs(qs, keep_blank_values=False, encoding="utf-8")
```

parse a query string to { key: [values] } pair, note without '?'

parse_qsl

return a list of k,v tuple

quote/quote_plus

unquote

urlencode