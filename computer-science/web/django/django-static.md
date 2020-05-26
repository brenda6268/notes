# django 静态文件


ID: 713
Status: publish
Date: 2018-06-17 12:48:00
Modified: 2020-05-16 11:40:49


# settings.py 中的相关配置

```
STATIC_URL = &#039;/static/&#039;
STATIC_ROOT = os.path.join(BASE_DIR,&#039;static&#039;)
```

一般来说我们只要把静态文件放在 APP 中的 static 目录下，部署时用 `python manage.py collectstatic` 就可以把静态文件收集到（复制到） STATIC_ROOT 目录，但是有时我们有一些共用的静态文件，这时候可以设置 STATICFILES_DIRS 另外弄一个文件夹，如下：

```
STATICFILES_DIRS = (
    os.path.join(BASE_DIR, &quot;common_static&quot;),
    &#039;/var/www/static/&#039;,
)
```

这样我们就可以把静态文件放在 common_static 和 /var/www/static/中了，Django也能找到它们。


```
MEDIA_URL = &#039;/media/&#039;
MEDIA_ROOT = os.path.join(BASE_DIR,&#039;media&#039;)
```

media文件夹用来存放用户上传的文件

# nginx 部署时的配置

```
location /media  {
    alias /path/to/project/media;
}
 
location /static {
    alias /path/to/project/collected_static;
}
```

# 在模板中引入静态文件

```
{% load static %}
&lt;img src=&quot;{% static &quot;img/example.jpg&quot; %}&quot; alt=&quot;My image&quot;/&gt;
```