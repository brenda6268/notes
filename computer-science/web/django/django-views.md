# Django views 视图

<!--
ID: 311ba8a9-e6a8-4281-9f21-7a59cdfe583a
Status: publish
Date: 2018-06-17T08:00:00
Modified: 2020-05-16T11:40:42
wp_id: 700
-->

django 使用正则指定路径，然后使用一个函数来处理对应的请求。

## 定义响应函数

响应函数如下：

```py
# views.py

from django.shortcuts import render
from django.http import HttpResponse
 
def add(request):
    a = request.GET["a"]
    b = request.GET["b"]
    c = int(a) + int(b)
    return HttpResponse(str(c))


def add2(request, a, b):
    c = int(a) + int(b)
    return HttpResponse(str(c))
```

注意每个函数都需要接受 request 作为第一个参数，GET参数和POST参数都可以从 request 中读取。另外还可以使用从 url path 中读取数据，这些参数作为形参传递给对应的函数。

## 定义 URL 路由

```py
# urls.py

from calc import views as calc_views
 
urlpatterns = [
    path("add/", calc_views.add, name="add"),  # new
    path("admin/", admin.site.urls),
    path("add/<int:a>/<int:b>/", calc_views.add2, name="add2"),  # django 2.0 的新语法，以前都是用正则分组
]
```

其中的 name 可以用在模板中，这样就不用写死 url 了。`<a href="{% url 'add2' 4 5 %}">link</a>`

## 设定响应的 headers

response 对象可以当做字典使用，向其中复制就可以设定响应的头部

```py
from django.http import HttpResponse

def add(request):
    a = request.GET["a"]
    b = request.GET["b"]
    c = int(a) + int(b)
    response = HttpResponse(str(c))
    response["Powered-By"] = "django"
    return response
```

## url reverse

在 urls.py 中可以设定 url 到具体函数的映射，但是 url 也是经常要随业务改动的，比如从 `add/` 变成了 `plus/`。当我们在某个网页中需要链接到某个页面的时候，不希望写死 url，这时候可以使用 url reverse 的功能，使用 name 反向获取 url。

```
# urls.py
path("add/<int:a>/<int:b>/", calc_views.add2, name="add2")

# other.py
from django.urls import reverse
url = reverse("add2")
```