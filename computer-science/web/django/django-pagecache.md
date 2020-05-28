# django 页面缓存


wp_id: 711
Status: publish
Date: 2018-06-17 15:08:00
Modified: 2020-05-16 11:41:02


django 作为一个动态的网站系统，在并发访问量大的时候会遇到性能问题，这时候可以使用缓存来显著提高性能。

settings.py 中的配置

可以使用 django-redis 来使用redis作为缓存。

```
pip install django-redis
```

```
CACHES = {
    "default": {
        "BACKEND": "django_redis.cache.RedisCache",
        "LOCATION": "redis://127.0.0.1:6379/1",
        "OPTIONS": {
            "CLIENT_CLASS": "django_redis.client.DefaultClient",
        }
    }
}
```

配置需要缓存的函数

```
from django.views.decorators.cache import cache_page
 
@cache_page(60 * 15) # 秒数，这里指缓存 15 分钟，不直接写900是为了提高可读性
def index(request):
    # 读取数据库等 并渲染到网页
    return render(request, "index.html", {"queryset":queryset})
```