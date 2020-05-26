# uwsgi 和 wsgi 协议


ID: 640
Status: publish
Date: 2017-06-21 15:37:00
Modified: 2020-05-16 11:43:56


uWSGI is a web server than runs python web frameworks. uwsgi(lower case) is the protocol it communicates with front end web servers(nginx)

# wsgi 协议

YN:

值得注意的是, wsgi实际上定义了一个同步的模型, 也就是每一个客户请求会调用一个同步的函数, 这样也就无法发挥异步的特性.

# 两个最简单的例子

其中实现 simple_app 函数也就是实现了wsgi协议.需要注意的有一下三点:

1. environ字典中包含的变量
2. start_response的参数
3. simple_app的调用次序和返回值

```
HELLO_WORLD = b&quot;Hello world!\n&quot;

def simple_app(environ, start_response):
    &quot;&quot;&quot;Simplest possible application object&quot;&quot;&quot;
    status = &#039;200 OK&#039;
    response_headers = [(&#039;Content-type&#039;, &#039;text/plain&#039;)]
    start_response(status, response_headers)
    return [HELLO_WORLD]

class AppClass:
    &quot;&quot;&quot;Produce the same output, but using a class
    (Note: &#039;AppClass&#039; is the &quot;application&quot; here, so calling it
    returns an instance of &#039;AppClass&#039;, which is then the iterable
    return value of the &quot;application callable&quot; as required by
    the spec.
    If we wanted to use *instances* of &#039;AppClass&#039; as application
    objects instead, we would have to implement a &#039;__call__&#039;
    method, which would be invoked to execute the application,
    and we would need to create an instance for use by the
    server or gateway.
    &quot;&quot;&quot;
    def __init__(self, environ, start_response):
        self.environ = environ
        self.start = start_response
    def __iter__(self):
        status = &#039;200 OK&#039;
        response_headers = [(&#039;Content-type&#039;, &#039;text/plain&#039;)]
        self.start(status, response_headers)
        yield HELLO_WORLD
```

而对于server/gateway来说, 每接收到一个http客户端, 都会调用一次这个 application callable

```
import os, sys
enc, esc = sys.getfilesystemencoding(), &#039;surrogateescape&#039;
def unicode_to_wsgi(u):
    # Convert an environment variable to a WSGI &quot;bytes-as-unicode&quot; string
    return u.encode(enc, esc).decode(&#039;iso-8859-1&#039;)
def wsgi_to_bytes(s):
    return s.encode(&#039;iso-8859-1&#039;)
def run_with_cgi(application):
    environ = {k: unicode_to_wsgi(v) for k,v in os.environ.items()}
    environ[&#039;wsgi.input&#039;]        = sys.stdin.buffer
    environ[&#039;wsgi.errors&#039;]       = sys.stderr
    environ[&#039;wsgi.version&#039;]      = (1, 0)
    environ[&#039;wsgi.multithread&#039;]  = False
    environ[&#039;wsgi.multiprocess&#039;] = True
    environ[&#039;wsgi.run_once&#039;]     = True
if environ.get(&#039;HTTPS&#039;, &#039;off&#039;) in (&#039;on&#039;, &#039;1&#039;):
        environ[&#039;wsgi.url_scheme&#039;] = &#039;https&#039;
    else:
        environ[&#039;wsgi.url_scheme&#039;] = &#039;http&#039;
headers_set = []
    headers_sent = []
def write(data):
        out = sys.stdout.buffer
if not headers_set:
             raise AssertionError(&quot;write() before start_response()&quot;)
elif not headers_sent:
             # Before the first output, send the stored headers
             status, response_headers = headers_sent[:] = headers_set
             out.write(wsgi_to_bytes(&#039;Status: %s\r\n&#039; % status))
             for header in response_headers:
                 out.write(wsgi_to_bytes(&#039;%s: %s\r\n&#039; % header))
             out.write(wsgi_to_bytes(&#039;\r\n&#039;))
out.write(data)
        out.flush()
def start_response(status, response_headers, exc_info=None):
        if exc_info:
            try:
                if headers_sent:
                    # Re-raise original exception if headers sent
                    raise exc_info[1].with_traceback(exc_info[2])
            finally:
                exc_info = None     # avoid dangling circular ref
        elif headers_set:
            raise AssertionError(&quot;Headers already set!&quot;)
headers_set[:] = [status, response_headers]
# Note: error checking on the headers should happen here,
        # *after* the headers are set.  That way, if an error
        # occurs, start_response can only be re-called with
        # exc_info set.
return write
result = application(environ, start_response)
    try:
        for data in result:
            if data:    # don&#039;t send headers until body appears
                write(data)
        if not headers_sent:
            write(&#039;&#039;)   # send headers now if body was empty
    finally:
        if hasattr(result, &#039;close&#039;):
            result.close()
```

# 参考资料

1. https://bottlepy.org/docs/dev/async.html
2. http://uwsgi-docs-cn.readthedocs.io/zh_CN/latest/WSGIquickstart.html
3. https://www.digitalocean.com/community/tutorials/how-to-deploy-python-wsgi-applications-using-uwsgi-web-server-with-nginx