# Django 中使用多个数据库


ID: 710
Status: publish
Date: 2018-08-22 04:20:00
Modified: 2020-05-16 11:23:12


有时候我们的表并不都在一个数据库中，需要使用多个数据库，django 支持配置并使用多个数据库。

# 定义多个数据库

首先，在 DATABASES 中定义需要使用的多个数据库：

```
DATABASES = {
    &#039;default&#039;: {},
    &#039;users&#039;: {
        &#039;NAME&#039;: &#039;user_data&#039;,
        &#039;ENGINE&#039;: &#039;django.db.backends.mysql&#039;,
        &#039;USER&#039;: &#039;mysql_user&#039;,
        &#039;PASSWORD&#039;: &#039;superS3cret&#039;
    },
    &#039;customers&#039;: {
        &#039;NAME&#039;: &#039;customer_data&#039;,
        &#039;ENGINE&#039;: &#039;django.db.backends.mysql&#039;,
        &#039;USER&#039;: &#039;mysql_cust&#039;,
        &#039;PASSWORD&#039;: &#039;veryPriv@ate&#039;
    }
}
```

注意其中 `default` 是必须的，不过用不到的话，留空也行。

在使用 `manage.py` 的时候可以使用 `--database=xxx` 里指定数据库。

# 数据库路由

可以通过实现 Database Router 来让 django 自动选择应该使用的数据库。

DB router 需要实现下面四个方法，用来指定不同的 Model 对应的模型。

1. `db_for_read(model, **hints)` 用来读取表时，查找对应的数据库。返回数据库配置名（DATABASES中定义的）
2. `db_for_write(model, **hints)` 用来写入表时，查找对应的数据库。
3. `allow_relation`
4. `allow_migrate`

最后使用 `DATABASE_ROUTERS` 安装对应的路由：

```
DATABASE_ROUERS = [&#039;path.to.router&#039;]
```