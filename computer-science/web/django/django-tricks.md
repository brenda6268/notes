# django 小技巧

<!--
ID: 9944d29d-6155-4fde-b048-ba2360ca4747
Status: publish
Date: 2017-06-26T02:24:00
Modified: 2020-05-16T11:44:14
wp_id: 706
-->

## 运行开发服务器

```
python manage.py runserver [host:]port
```

可以指定绑定的IP

## 创建用户和更改密码

```
python manage.py createsuperuser  # 创建超级用户
```

```
python manage.py changepassword username
```

## 进入当前项目的shell

在这个 python shell 中，可以直接使用 django 的model

```
python manage.py shell
```


## timezone aware time

在向数据库中保存datetime字段的时候，经常会遇到 django 报警缺少时区信息，可以使用 django 自带的 timezone.now()

```
from django.utils import timezone
now_aware = timezone.now()
```