# ES 最新版本到底是怎样的？

<!--
ID: 95b84e2c-aa67-4ba9-9918-24d000de6631
Status: draft
Date: 2018-06-22T08:00:00
Modified: 2020-05-16T11:11:41
wp_id: 766
-->

ES家的几个产品版本不太统一，有的在2.x，有的在4.x，为了打包在一起卖，ES家把ES、kibana、beats的版本统一成了 5.0 版本。

![](https://ws2.sinaimg.cn/large/006tNc79gy1fsk0l4proij313a0lwdmh.jpg)

- 关系型数据库：Databases -> Tables -> Rows -> Columns
- ElasticSearch：Indices -> Types  -> Documents -> Fields

ElasticSearch 集群可以包含多个索引(indices)（数据库），每一个索引可以包含多个类型(types)（表），每一个类型包含多个文档(documents)（行），然后每个文档包含多个字段(Fields)（列）。

- 索引（名词） 如上文所述，一个索引(index)就像是传统关系数据库中的数据库，它是相关文档存储的地方，index的复数是indices 或indexes。
- 索引（动词） 「索引一个文档」表示把一个文档存储到索引（名词）里，以便它可以被检索或者查询。这很像SQL中的INSERT关键字，差别是，如果文档已经存在，新的文档将覆盖旧的文档。
- 倒排索引 传统数据库为特定列增加一个索引，例如B-Tree索引来加速检索。Elasticsearch和Lucene使用一种叫做倒排索引(inverted index)的数据结构来达到相同目的。

在Elasticsearch中，每一个字段的数据都是默认被索引的。也就是说，每个字段专门有一个反向索引用于快速检索。而且，与其它数据库不同，它可以在同一个查询中利用所有的这些反向索引，以惊人的速度返回结果。

一个文档不只有数据。它还包含了元数据(metadata)——关于文档的信息。三个必须的元数据节点是：

```
节点	说明	
_index	文档存储的地方	类似于数据库
_type	文档代表的对象的类	类似于表
_id	文档的唯一标识	类似于id
_version	用于控制冲突	可以由外部指定，采用乐观锁
```

检索返回_source，可以使用_update API局部更新文档，_mget总会返回200

搜索

GET /_search 返回

返回

```
   {
   "hits" : {
      "total" :       14,
      "hits" : [
        {
          "_index":   "us",
          "_type":    "tweet",
          "_id":      "7",
          "_score":   1,
          "_source": {
             "date":    "2014-09-17",
             "name":    "John Smith",
             "tweet":   "The Query DSL is really powerful and flexible",
             "user_id": 2
          }
       },
        ... 9 RESULTS REMOVED ...
      ],
      "max_score" :   1
   },
```

# Python 客户端

ingore

An API call is considered successful (and will return a response) if elasticsearch returns a 2XX response. otheriwse an TransportError is raised. use ignore to ignore errors

es.indices.create(index='test-index', ignore=400)
es.indices.delete(index='test-index', ignore=[400, 404])

response filtering 

filter_path parameter to filter response, typically es returns response['hits']['hits'], which is quite cumbersome.

es.search(index='test-index', filter_path=['hits.hits._id', 'hits.hits._type']) # returns the _id and _type
es.search(index='test-index', fitler_path=['hits.hits._*']) # returns all fileds in hits

bulk and helpers

for bulk request

Methods

common pattern

es.method(index='', doc_type='', id='', zbody='', _source=True/False...)

count		query must be ecasulterd in query
create	add document to es	
delete	delete document by id	
delete_by_query		
exists	exists by id	
get	get by id	
index		
mget	by body	
search	by body	
update		
helpers.bulk		

Exceptions

TransportError	4XX
NotFound	404
Conflict	409
BadRequest	400

参考：

1. http://www.tianshangkun.com/2018/05/15/ElasticSearch%E7%9A%84%E6%90%AD%E5%BB%BA%E4%B8%8E%E6%95%B0%E6%8D%AE%E7%BB%9F%E8%AE%A1/