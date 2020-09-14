# Mongodb 笔记

<!--
ID: 0e102910-a985-435f-8296-aaf38f66d30f
Status: draft
Date: 2020-08-24T16:23:43
Modified: 2020-08-24T16:23:43
wp_id: 1880
-->

MongoDB 和 关系型数据库的对比：

1. 集合 (collection) 对应表 (table)
2. 文档 (document) 对应行 (row)

数据库和集合不需要创建，直接插入就可以。


## 安装

mac

```
brew tap mongodb/brew
brew install mongodb-community@4.4
```

## 使用

```py

from pymongo import MongoClient

client = MongoClient("mongodb://localhost:27017/")

db = client["my_database"]  # 只需要像字典一样选择就行了，无需创建，就像 redis key 一样
col = db["my_collection"]  # 选择集合也一样，无需创建

doc = col.find_one()
```

如果你非要检测一下数据库是否存在的话

```py
"my_database" in myclient.list_database_names()
"my_collection" in db.list_collection_names()
```

插入数据，直接插入就行了。mongodb 会自动添加叫做 `_id` 的列。当然如果你指定了 `_id`, 就
不会插入了

```py
mydict = { "name": "John", "address": "Highway 37" }

r = col.insert_one(mydict)
print(r.inserted_id)

mylist = [
  { "name": "Amy", "address": "Apple st 652"},
  { "name": "Hannah", "address": "Mountain 21"},
]
r = col.insert_many(mylist)
r.inserted_ids
```

查询数据

```py
doc = col.find_one()  # 返回一个数据

for doc in col.find():  # 返回所有数据
  print(doc)

col.find().sort("age")  # 按某个键排序
col.find().limit(5)  # 只返回 5 个结果

from bson.objectid import ObjectId

coditions = {"_id": ObjectId("xxx")}  # 按照 _id 查询需要使用 objectid
conditions = {"name": "Ross"}  # 按照某个字段查询

fields = {"name": 1}  # 只取这个字段
fields = {"name": 0}  # 去掉这个字段

doc = col.find_one(conditions, fields)

col.count_documents(conditions)

col.delete_one({"name": "Ross"})
col.delete_many({"name": "Ross"})

col.drop()
```

添加索引

```py
col.create_index([('user_id', pymongo.ASENDING)], unique=True)
```

如果插入重复的就会抛出 DuplicateKeyError, 包括 insert_many 等方法，连不重复的数据都不能插入。

在使用 insert_many 的时候为了保证让不重复的数据能够插入，可以指定 `ordered=False` 来并行插入。但是依然还是会抛出错误。

## 高级使用



## 参考

1. https://juejin.im/entry/6844903677983981575
2. https://pymongo.readthedocs.io/en/stable/tutorial.html
