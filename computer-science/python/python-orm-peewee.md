# Python 微型ORM Peewee 教程


ID: 303
Status: publish
Date: 2019-08-17 08:54:32
Modified: 2020-05-16 10:51:32


Python 中最著名的 ORM 自然是 sqlalchemy 了，但是 sqlalchemy 有些年头了，体积庞大，略显笨重。Peewee 还比较年轻，历史包袱比较少，也仅仅支持 Postgres、MySQL、Sqlite 这三种互联网公司最常见的数据库，所以整体上来说是比较轻量的。

# 连接和创建数据库

```python
db.init(**args)
db.connect()
db.create_table([Person])
```

## 连接池



## 自动重连，保持连接

在长时间运行的后台脚本使用数据库的时候，可能会遇到连接丢失的问题。peewee 提供了一个 Mixin 可以在连接丢失时候重连，这点比 django 方便多了。

```python
from peewee import MySQLDatabase
from playhouse.shortcuts import ReconnectMixin

class ReconnectMySQLDatabase(ReconnectMixin, MySQLDatabase):
    pass

db = ReconnectMySQLDatabase(&#039;my_app&#039;, ...)
```

# 定义表

peewee 在创建模型的时候就设定了数据库链接，个人感觉这个设计似乎不是很好。不过好在可以先不指定参数，而在实际使用的时候再链接数据库。

```python
import peewee as pw

db = SqliteDatabase(None)  # 这里不配置数据库链接是为了之后方便更改不同环境

class Person(pw.Model):
    name = pw.CharField()
    birthday = pw.DateField()

    class Meta:
        database = db

class Pet(Model):
    owner = ForeignKeyField(Person, backref=&#039;pets&#039;)
    name = CharField()
    animal_type = CharField()

    class Meta:
        database = db
```

如果有自引用的外键，可以使用 `"self"` 来指定。如果有循环引用的外键，可以使用 DeferredForeignKey。
在 django 的 ORM 中，我们可以直接使用 FIELD_id 这样来访问一个外键的 id。这个在 peewee 中也是支持的。但是在设置的时候却不需要加上 `_id` 的后缀。在使用 where 语句的时候也不需要使用后缀。

```
event_id = ticket.event_id
ticket.event = new_event_id
Ticket.select().where(event == desired_event_id)
```

# 执行裸SQL

```python
database.execute_sql()
```

# 增删改查

## 读取数据

基本的语法是 `Model.select(fields).where(**coditions).get()`. 或者直接简写成 `Model.get()`。

```python
# peewee 只会查询一次数据库，不管迭代多少次。
query = Pet.select().where(Pet.animal_type == &#039;cat&#039;)
for pet in query:
    print(pet.name, pet.owner.name)  # 注意这里有 N+1 问题，N 指的是获取 owner.name

# 直接获取一条数据，select, where 全省略了
grandma = Person.get(Person.name == &#039;Grandma L.&#039;)

# 或者全写出来
grandma = Person.select().where(Person.name == &quot;Gramdma L.&quot;).get()

# in 查询使用 in_ 方法
Pet.select().where(Pet.id.in_([1,2]))

# 对于 id 可以直接使用 get_by_id

Person.get_by_id(100)

# 使用 get_or_none 阻止抛出异常

Person.get_or_none()

# 可以使用 join 解决 N+1 问题
query = (Pet
         .select(Pet, Person)
         .join(Person)
         .where(Pet.animal_type == &#039;cat&#039;))
         .order_by(Pet.name)  # 或者 Pet.name.desc() 逆序排列

for pet in query:
    print(pet.name, pet.owner.name)
```

可以直接使用 | 来作为查询条件，这个相比 django 需要使用 Q 来说，设计地非常优雅。

```python
d1940 = date(1940, 1, 1)
d1960 = date(1960, 1, 1)
query = (Person
         .select()
         .where((Person.birthday &lt; d1940) | (Person.birthday &gt; d1960)))

for person in query:
    print(person.name, person.birthday)

# prints:
# Bob 1960-01-15
# Grandma L. 1935-03-01

query.count()  #  返回记录的大小
```

### get_or_create

peewee 模仿 django 实现了 get_or_create 的方法。注意他的参数是 Django 风格的，而不是 peewee 的 model.attr == xxx 的风格。

```python
person, created = Person.get_or_create(
    first_name=first_name,
    last_name=last_name,
    defaults={&#039;dob&#039;: dob, &#039;favorite_color&#039;: &#039;green&#039;})
```

### iterator

对于返回结果过多的查询，可以使用 iterator 方法。

### 返回简单对象

## 插入数据

跟 django 的 ORM 貌似是一样的。使用 Model.create() 或者 Model.save() 或者 Model.insert()

```python
from datetime import date

# 使用 save
uncle_bob = Person(name=&#039;Bob&#039;, birthday=date(1960, 1, 15))
uncle_bob.save() # bob is now stored in the database

# 使用 create
grandma = Person.create(name=&#039;Grandma&#039;, birthday=date(1935, 3, 1))
bob_kitty = Pet.create(owner=uncle_bob, name=&#039;Kitty&#039;, animal_type=&#039;cat&#039;)  # 带有外键的宠物

# 使用 bulk_create
users = [User(username=&#039;u%s&#039; % i) for i in range(10)]
User.bulk_create(users, batch_size=100)

# 使用 insert
User.insert(username=&quot;mickey&quot;).execute()

# 使用 insert many。或者使用 tuple 也可以
data_source = [
    {&#039;field1&#039;: &#039;val1-1&#039;, &#039;field2&#039;: &#039;val1-2&#039;},
    {&#039;field1&#039;: &#039;val2-1&#039;, &#039;field2&#039;: &#039;val2-2&#039;},
    # ...
]

# Fastest way to INSERT multiple rows.
MyModel.insert_many(data_source).execute()

# We can INSERT tuples as well...
data = [(&#039;val1-1&#039;, &#039;val1-2&#039;),
        (&#039;val2-1&#039;, &#039;val2-2&#039;),
        (&#039;val3-1&#039;, &#039;val3-2&#039;)]

# But we need to indicate which fields the values correspond to.
MyModel.insert_many(data, fields=[MyModel.field1, MyModel.field2]).execute()
```

## 更新数据

可以使用 Model.update 或者 model.save 更新数据。

```python
# 使用 save 更新
herb_fido.owner = uncle_bob
herb_fido.save()

# 使用 update 更新
query = Tweet.update(is_published=True).where(Tweet.creation_date &lt; today)

# 批量更新数据
# First, create 3 users with usernames u1, u2, u3.
u1, u2, u3 = [User.create(username=&#039;u%s&#039; % i) for i in (1, 2, 3)]

# Now we&#039;ll modify the user instances.
u1.username = &#039;u1-x&#039;
u2.username = &#039;u2-y&#039;
u3.username = &#039;u3-z&#039;

# Update all three users with a single UPDATE query.
User.bulk_update([u1, u2, u3], fields=[User.username])
```

需要注意的是，在使用 update 的时候千万不要在 Python 中使用计算再更新，要使用 SQL 语句来更新，这样才能具有原子性。

错误做法
```python
&gt;&gt;&gt; for stat in Stat.select().where(Stat.url == request.url):
...     stat.counter += 1
...     stat.save()
```

正确做法

```
&gt;&gt;&gt; query = Stat.update(counter=Stat.counter + 1).where(Stat.url == request.url)
&gt;&gt;&gt; query.execute()
```

## 删除数据

可以使用 model.delete_instance 或者 Model.delete。

```python
# 使用 object.delete_instance
herb_mittens.delete_instance()

# 使用 Model.delete
Tweet.delete().where(Tweet.creation_date &lt; one_year_ago).execute()
```

# 一些有用的拓展

## 模型转换成字典

除了在查询的时候使用 model.dicts 以外，还可以使用 model_to_dict(model) 这个函数。

```python
&gt;&gt;&gt; user = User.create(username=&#039;charlie&#039;)
&gt;&gt;&gt; model_to_dict(user)
{&#039;id&#039;: 1, &#039;username&#039;: &#039;charlie&#039;}
```



## 从数据库生成模型

最后也是最牛逼的一点，可以使用 pwiz 工具从已有的数据库产生 peewee 的模型文件：

```
python -m pwiz -e postgresql charles_blog &gt; blog_models.py
```

# 参考

1. https://stackoverflow.com/questions/45345549/peewee-mysql-server-has-gone-away-error/57797698#57797698