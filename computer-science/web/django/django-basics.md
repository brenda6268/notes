# django basics


wp_id: 704
Status: draft
Date: 2018-04-29 13:19:00
Modified: 2020-05-16 11:37:35


# Philosophy

每个应用应该紧紧围绕他的任务，如果一个应用不能用一句话解释清楚是做什么的，那么就应该分成多个应用

# Naming

如果可能的话，使用一个单词。并且让他的你的url是配套的。

# settings

use a settings dir, and put all the settings in the dir
use --settings option or the DJANGO_SETTINGS_MODULE variable
keep everyone's dev settings in the settings dir in version control
secrets should be in env
the `django-admin diffsettings` command

# Workflow

## start a project

```
% django startproject <project_name>
```

## start an app

to use django models, you have to create django apps, a bundle of Django code, including models and views, that live together in a single Python package and represent a full Django application.

```
./manage.py startapp <app_name>
```

register in the settings.py INSTALLED_APPS


NOTE: django project name and app name can NOT be the same, weird...

start development server

```
./manage.py runserver [bind_address:port]
```

## adding views

1. add a function in <project>/views.py
2. import it in the urls.py
3. add one line in the `urlpatterns` list url(regex, func, name)
	
views.py 

```
from django.http import HttpResponse

def hello(request):
    return HttpResponse("hello world")
```

if you want parameters, capture them in the url regex and pass them as parameters along with request to handler functions

Template

```
from django.template import Template
t = Template(temp_str)
c = Context(context_dict)
t.render(context)
```


you can omit the parentheses for method call, however basically, the template engine is like jinja2

the forloop variable

forloop.counter	1 based value
forloop.counter0	0 based value
forloop.first	bool to indicate whether is first
forloop.last	

render

from django.shortcuts import render
render(request, template_file, context_dict)

block/include are all the same with jinja2 template

HttpRequest & HttpResponse

request.path	full path
request.get_host	hostname + port
reuqest.is_secure	True or False
request.META	headers in ALL_CAPS
request.GET	dict like object
request.POST