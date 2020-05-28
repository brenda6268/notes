# 学习 Django ORM


wp_id: 224
Status: publish
Date: 2017-06-07 13:04:57
Modified: 2020-05-16 12:05:45


## 定义模型

继承 `models.Model` 并使用 `models.XXXField`

```Python
from django.db import models

class Book(models.Model):
    title = models.CharField(max_length=100, blank=True)
    authors = models.ManyToManyField(Author)  # 定义了多对多外键
    publisher = models.ForeignKey(Publisher, on_delete=models.DO_NOTHING)  # 定义了多对一外键
    publication_date = models.DateField(null=True, blank=True)

    def __str__(self):
        return f"<Book {self.title}>"

    class Meta:
        ordering = ["name"]
        db_table = ""
```

### 外键-多对多映射和多对一映射

注意其中的 `ManToManyField` and `ForeignKey` 字段。关于多对多关系，还需要详细参考[文档](https://docs.djangoproject.com/en/2.2/topics/db/examples/many_to_many/)

注意 `ForeignKey` 字段必须添加 on_delete 参数，参考[这里](https://stackoverflow.com/questions/38388423/what-does-on-delete-do-on-django-models)。

个人认为，on_delete 最好使用 models.DO_NOTHING，虽然会造成数据库的完整性缺失，但是没有丢失任何信息。如果需要在删除的时候删除其他关联模型的话，还是自己实现比较稳妥。另外，对于数据库来说，尽量少删除数据，而是用一个字段标记为已删除。

当使用 manytomanyfield 的时候，django 会自动创建一张关联表，可以通过 `through` 来指定关联关系对应的模型，在其中指定对应的表。

manytomanyfield 和 foreinkey 其中的第一个参数（也就是模型）也可以使用对应模型的名字的字符串，避免引用未定义的类型。

如果需要指向自己的外键，可以用 `models.ForeignKey('self')`。


### 字段的选项

* `null` 是否可以为 nullable. 默认 False.
* `blank` 是否可以留空, 注意不是 null，这个是 django 的验证，不会反应在数据库 DDL 中, 默认 False.
* `db_index` 是否为该字段建立索引, default False.
* `choices` 用来在 django admin 中限制字段的选项，必须是回一个 list of tuple `choices = ((1, 'male'), (0, 'female'))`
* `default` 默认值，可以为值或 callable，如果默认要是动态的值，最好是一个 callable.
* `help_text` 帮助文本
* `verbose` 长名字
* `unique` 是否应该是 unique 字段
* `primary_key` 是否设置为主键

####  null 与可以留空的字段

to make string field optional, just add `blank = True` if you want to allow blank values in a date field (e.g., DateField, TimeField, DateTimeField) or numeric field (e.g.,IntegerField, DecimalField, FloatField), you’ll need to use both `null=True` and `blank=True`.

#### 自动生成的 ID 字段

by default, django gives each model a primary key field. if primary_key=True is set on any other field, django will not generate this.

### class Meta

* `db_table`, 建表对应的表名，默认是 `<APPNAME>_<MODEL>`
* `ordering`, 数组，admin 中用来排序的依据
* `unique_together`, 字段组合作为 unique 索引: `unique_together = (("driver", "restaurant"),)`
* `index_together`, 字段组合作为索引, `index_together = [["pub_date", "deadline"],]`

### 抽象基类

比如说有时候我们对于每一个模型都需要创建 `create_time`, `modify_time` 字段，那么可以把这些字段定义成一个抽象基类，就不需要在每个模型里面定义了，在基类的 meta 中设定 abstract 为 true 即可。

```
from django.db import models

class CommonInfo(models.Model):
    name = models.CharField(max_length=100)
    age = models.PositiveIntegerField()

    class Meta:
        abstract = True  # 注意这里

class Student(CommonInfo):
    home_group = models.CharField(max_length=5)
    # 这个模型就自动拥有了 name 和 age 了
```

### 为什么要尽量不用外键

当应用变大以后以后，你的数据表可能要分库，这时候就没法再使用外键了，毕竟要跨库。所以可以在 django 中使用 ForeignKey，但是最好不要再数据库定义中使用数据库的外键。

### 其他

如果你想覆盖 __init__ 方法, 记得调用父类的方法

```
def __init__(self, *args, **kwargs):
    super().__init__(self, *args, **kwargs)
    # your code here
```

## 使用模型

上面讲完了模型的定义，下面我们来看下模型的使用。

### 创建

```
Model.objects.create(**kwargs)
```

### 保存模型

```
model = Model()
model.save() # note that all of the fields will be updated, not just the ones that have been changed
model/queryset.update()
model/queryset.delete()
```

### 查询

查询会返回一个 QuerySet 对象，也就是查询的结果，表现出来类似于一个模型实例的数组。

```
Model.objects.get(**kwargs)  # returns one object, may raise DoesNotExist or MultiOjbectsReturned
Model.objects.all()
Model.objects.filter(**kwargs) # returns a query set
Model.objects.order_by(*colnames) # 可以使用 - 表示反向排序
```

#### 查询条件

查询语法是：

```
<field>__<lookuptype>=value
```

其中 lookuptype 可以是：

```
empty/exact/iexact  # 是否为空、是否是某个值
contains/icontains  # 包含、忽略大消息包含
(i)startswith/(i)endswith  # 开头结尾
range  # 在某个范围内
in  # 在给定的元素中，相当于 sql 的 in
gt/gte/lt/lte  # 大于小于
year/month/day/week_day/hour/minute/second  # 时间
isnull  # 是否为 null
regex/iregex  # 正则匹配
```

### 复杂查询，使用 F 和 Q

https://docs.djangoproject.com/en/2.2/topics/db/queries/#complex-lookups-with-q

上面提到的查询条件在 SQL 层面会形成“与”的关系，那么怎么表示“或”的查询呢？可以使用 Q 对象

#### F 表达式

what if you want to compare the value of a model field with another field on the same model?
use F(colname) to reference the column value

#### Q 表达式

Q 表达式封装了一个查询条件，可以是会用 `|` 和 `&` `~`组合来表达“或”和“与”“非”的关系，通过两个运算符会得到一个新的 Q 表达式。

比如说，以 Who 或者 What 开头的问题：
```
Q(question__startswith="Who") | Q(question__startswith="What")
```

可以在查询中这样使用：

```
Poll.objects.get(
    Q(question__startswith="Who"),
    Q(pub_date=date(2005, 5, 2)) | Q(pub_date=date(2005, 5, 6))
)
```

### QuerySet 分片

查询的分片会对应到数据库的 limit 和 offset 语句，所以需要注意的是不要使用较大的索引，另外不支持负数索引，也就是不能直接访问最后一个元素。

通常来说，对于 QuerySet 的切片会返回一个新的切片，使用切片的过程并不会去从数据库加载数据，只有到最后需要访问数据的时候才会去真正访问数据库。

```
>>> Entry.objects.all()[:10:2]
```

上面的这个查询可能会引起 IndexError

对于需要访问最后一个元素来说，通常可以采用反向排序，访问第一个元素解决。

```
>>> Publisher.objects.order_by("name")[-1]
Traceback (most recent call last):
  ...
AssertionError: Negative indexing is not supported.

>>> # This is easy to get around, though. Just change the order_by() statement, like this:
>>> Publisher.objects.order_by("-name")[0]
```

**删除一个QuerySet**

```
Model.objects.get().delete()
```


### QuerySet 操作

```
filter(**kwargs)
exclude(**kwargs)
count
create
get_or_create
update
delete
iterate
exists
iterator
```

### 模型的懒加载

Each QuerySet contains a cache to minimize database access. Understanding how it works will allow you to write the most efficient code. In a newly created QuerySet, the cache is empty. The first time a QuerySet is evaluated – and, hence, a database query happens – Django saves the query results in the QuerySet’s cache and returns the results that have been explicitly requested (e.g., the next element, if the QuerySet is being iterated over). Subsequent evaluations of the QuerySet reuse the cached results.

#### Using iterator vs directly

A QuerySet typically caches its results internally so that repeated evaluations do not result in additional queries. In contrast, iterator() will read results directly, without doing any caching at the QuerySet level (internally, the default iterator calls iterator() and caches the return value). Using iterator would probably save your memory.

Keep this caching behavior in mind, because it may bite you if you don’t use your QuerySets correctly. For example, the following will create two QuerySets, evaluate them, and throw them away:

```
>>> print([e.headline for e in Entry.objects.all()]) # two querysets created and evaluated and thrown
>>> print([e.pub_date for e in Entry.objects.all()])
```

That means the same database query will be executed twice, effectively doubling your database load. Also, there’s a possibility the two lists may not include the same database records, because an Entry may have been added or deleted in the split second between the two requests.
To avoid this problem, simply save the QuerySet and reuse it:

```
>>> queryset = Entry.objects.all()        # store the queryset to a variable
>>> print([p.headline for p in queryset]) # Evaluate the query set.
>>> print([p.pub_date for p in queryset]) # Re-use the cache from the evaluation.
```

#### When querysets are not cached?

Querysets do not always cache their results. When evaluating only part of the queryset, the cache is checked, but if it is not populated then the items returned by the subsequent query are not cached. Specifically, this means that limiting the queryset using an array slice or an index will not populate the cache.

For example, repeatedly getting a certain index in a queryset object will query the database each time:
```
>>> queryset = Entry.objects.all()
>>> print queryset[5] # Queries the database
>>> print queryset[5] # Queries the database again 
```

However, if the entire queryset has already been evaluated, the cache will be checked instead:

```
>>> queryset = Entry.objects.all()
>>> [entry for entry in queryset] # Queries the database
>>> print queryset[5] # Uses cache
>>> print queryset[5] # Uses cache 
Here are some examples of other actions that will result in the entire queryset being evaluated and therefore populate the cache:
>>> [entry for entry in queryset]
>>> bool(queryset)
>>> entry in queryset
>>> list(queryset)
```

if you want to add extra check in model save, just override the defualt save method aorr add post save handlers

fat models is not all that good, it may cause god object problem

使用 only 来指定需要的字段。

如果只需要一个或者几个值，可以使用 values_list 方法

```
In [6]: authors = Author.objects.values_list("name", "qq")

In [7]: authors

Out[7]: <QuerySet [(u"WeizhongTu", u"336643078"), (u"twz915", u"915792575"), (u"wangdachui", u"353506297"), (u"xiaoming", u"004466315")]>

In [8]: list(authors)

Out[8]: [(u"WeizhongTu", u"336643078"),

 (u"twz915", u"915792575"),

 (u"wangdachui", u"353506297"),

 (u"xiaoming", u"004466315")]
```

如果只需要 1 个字段，可以指定 flat=True

```
In [9]: Author.objects.values_list("name", flat=True)

Out[9]: <QuerySet [u"WeizhongTu", u"twz915", u"wangdachui", u"xiaoming"]>

In [10]: list(Author.objects.values_list("name", flat=True))

Out[10]: [u"WeizhongTu", u"twz915", u"wangdachui", u"xiaoming"]
```

## 其他技巧

### 查看执行的 sql 语句和执行时间

```
from django.db import connection
print(connection.queries)
```


### 如何在 django 外部单独使用模型

```
import os
from django.conf import settings
from django.apps import apps

conf = {
    "INSTALLED_APPS": [
        "Demo"
    ],
    "DATABASES": {
        "default": {
            "ENGINE": "django.db.backends.sqlite3",
            "NAME": os.path.join(".", "db.sqlite3"),
        }
    }
}

settings.configure(**conf)
apps.populate(settings.INSTALLED_APPS)
```

> https://stackoverflow.com/a/46050808/1061155