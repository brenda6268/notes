# Django Admin 后台教程

<!--
ID: b8dcc096-8b41-43c5-baa6-adf3b8fee76c
Status: publish
Date: 2017-06-07T08:07:00
Modified: 2020-05-16T12:05:50
wp_id: 699
-->

## 基础

`./manage.py startapp APP_NAME` would create an `admin.py` file, you should define your admin classes in that file.

`./manage.py createsuperuser` creates a user, so that you could login into the admin site at http://youdomain.com/admin

by default, the admin panel only contains user and group settings.

## how to create your own admin

1. subclass `django.contrib.admin.ModelAdmin` in `admin.py`
2. customize this class
3. register it to the admin site

### subclass

最简单的一个例子

```
from django.contrib import admin
from mysite.books.models import Publisher, Author, Book
	
class AuthorAdmin(admin.ModelAdmin):
    list_display = ("first_name", "last_name", "email")
    search_fields = ("first_name", "last_name")
    list_filter = ("publication_date",)
		
admin.site.register(Publisher)
```

customize the admin class by change class attributes:

1. `list_display` 控制列表页显示的属性, 其中可以包含 Model 的属性或者函数
2. `search_fields` 表示搜索框会搜索的属性
3. `list_filter` 表示的是在右边显示的过滤器
4. `fields` 表示的是在每一个object的详情页显示的属性, 更复杂的可以用fieldset. 注意这里面的属性如果是函数的话, 必须包含在 `readonly_fields` 中.
5. `readonly_fields` 表示的是详情页的只读字段

每一个属性都是一个 tuple 或者 list, 以 list_display 为例

### `list_display`

list_display 中的元素可以是:

* 模型中的一个字段
* 一个 callable
* A string representing a `ModelAdmin` attribute, obj is passed to the method.
* A string representing a model attribute

```
# example
class PersonAdmin(admin.ModelAdmin):
    list_display = ("upper_case_name",)

    def upper_case_name(self, obj):
        return ("%s %s" % (obj.first_name, obj.last_name)).upper()
    upper_case_name.short_description = "Name"
```

## 可以覆盖的方法

### 保存

可以覆盖 ModelAdmin.save_model 方法来在保存模型的时候添加删除一些额外的字段，其中 change 表示是在增加还是修改。注意需要调用父类的方法来最终保存这个模型

```
from django.contrib import admin

class ArticleAdmin(admin.ModelAdmin):
    def save_model(self, request, obj, form, change):
        obj.user = request.user
        super().save_model(request, obj, form, change)
```

### 删除

覆盖 ModelAdmin.delete_model 可以在删除模型的时候做一些额外的操作，注意同样需要调用父类的方法来最终删除模型。

```
ModelAdmin.delete_model(request, obj)
```

## 更改 admin 后台的界面

单独修改某个 Admin

```


    class MyModelAdmin(admin.ModelAdmin):
        class Media:
            js = ("js/admin/my_own_admin.js",)    
            css = {
                 "all": ("css/admin/my_own_admin.css",)
            }

```

修改所有的界面

从 `contrib/admin/templates/admin` 拷贝对应的模板文件到 app 的 templates 目录. 然后修改就可以了~