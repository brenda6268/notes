# django auth and user


wp_id: 714
Status: publish
Date: 2018-01-17 22:53:00
Modified: 2018-01-17 22:53:00


# 激活

django 自带的 auth 模块需要收先创建数据库才能够使用：

```
python manage.py migrate auth
python manage.py migrate
```


request.user.is_anonymous 检查用户是否

django comes with login/logout forms and views

```
from django.conf.urls import url
from django.contrib import admin
from django.contrib.auth import views as auth_views
urlpatterns = [
    url(r'^login/$', auth_views.login, name='login'),
    url(r'^logout/$', auth_views.logout, name='logout'),
    url(r'^admin/', admin.site.urls),
]
```

By default, the django.contrib.auth.views.login view will try to render the registration/login.html template.  and will redirct to the /accouts/profile page

```
{% extends 'base.html' %}
 {% block title %}Login{% endblock %} 
{% block content %}
 <h2>Login</h2> 
<form method="post"> 
{% csrf_token %} 
{{ form.as_p }}
 <button type="submit">Login</button>
 </form> 
{% endblock %}
```

You can change what django renders

`url(r'^login/$', auth_views.login, {'template_name': 'core/login.html'}, name='login'),`

You can change where django redirects

`LOGIN_REDIRECT_URL = 'home' # in settings.py`


logout

by default, renders the registration/logged_out.html

`url(r'^logout/$', auth_views.logout, {'template_name': 'logged_out.html'}, name='logout'),`

`url(r'^logout/$', auth_views.logout, {'next_page': '/'}, name='logout'),`

Note the difference, you don't have to do anything when visiting /logout, the system will just log you out and send you to another page or render a logged out page

~~Side notes: why changing the redirect url is different with login? find it out later~~