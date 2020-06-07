# Python bottle 库的使用


wp_id: 701
Status: draft
Date: 2018-04-04 06:22:00
Modified: 2020-05-16 11:34:08


Yifei's Notes

By using bottle, you would like to do some small and easy-to-understand and easy-to-implement code, so just use
from bottle import *, if your code base grow to large, do refactor when so.

API design

* always prefix the api with a version such as /v1/users/create
* the outer most part of the json should be a dict
* html rendering endpoint should not be mixed with api endpoints, prefix api with /api/ or /v1/

Basic

In this section, we run bottle in default app mode, which means we do not make a Bottle instance explicitly

```
from bottle import *

@method("/path/<param:filter:config>/<more>")
def func(param, more):
    return template("<h1>{{ name }}</h1>", name=name)

if __name__ == "__main__":
    run(host="localhost", port=8080)
```

filter
param can be restrcited to specific filter, available filters are int float path re


error
error page is described by @error(code) decorator

```
@error(404)
def not_found(error): # error is an instance of HTTPError
    return ...
```

request

request data can be accessed by by the request object, suprisingly, the request object is thread safe

retrive single value

param	one value	multi value
cookies	request.cookies.key	request.cookies.getall('key')
POST	request.forms.key	request.forms.getall('key')
GET	request.query.key	request.query.getall('key')
headers	request.headers.get('Referer')	
files(by form)	request.files	
json	request.json....	Notes: must with application/json header

request.body contains the raw request body
if you are posting a binary directly, please set the right Content-Type header, you may not access it by the files attribute, just read request.body

response

bottle automatically generate proper headers and response by the value type you are returning

dict	json
string	normal html
file	file.read() as html
HTTPError	cause a error, like abort()

response.encoding and response.charset

Error and Redirect

instead of return, use the functions:

abort(error_code, body)
redirect(url, error_code)

headers request.set_header(header, value) and request.add_header(header, value)