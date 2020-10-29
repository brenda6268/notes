# Elasticsearch 上手教程

<!--
ID: 95b84e2c-aa67-4ba9-9918-24d000de6631
Status: publish
Date: 2018-06-22T08:00:00
Modified: 2020-05-16T11:11:41
wp_id: 766
-->

ES 家的几个产品版本不太统一，有的在 2.x，有的在 4.x，为了打包在一起卖，ES 家把 ES、Kibana、Logstash 的版本统一成了 5.0 版本。现在的版本是 7.x

![版本](https://tva1.sinaimg.cn/large/006tNc79gy1fsk0l4proij313a0lwdmh.jpg)

- 关系型数据库：Databases -> Tables -> Rows -> Columns
- ElasticSearch：Indices -> Types -> Documents -> Fields

ElasticSearch 集群可以包含多个索引 (indices)，每一个索引可以包含多个类型 (types)，每一个类型包含多个文档 (documents)，然后每个文档包含多个字段 (Fields)。

但是需要**特别注意**的是：在 SQL 中，不同表中的列都是毫不相关的，而在 ES 中，同一个索引内，不同 type 的**同名字段就是同一个字段**。

- 索引（名词）如上文所述，一个索引 (index) 就像是传统关系数据库中的数据库，它是相关文档存储的地方，index 的复数是 indices 或 indexes。
- 索引（动词）「索引一个文档」表示把一个文档存储到索引（名词）里，以便它可以被检索或者查询。这很像 SQL 中的 INSERT 关键字，差别是，如果文档已经存在，新的文档将覆盖旧的文档。
- 倒排索引，传统数据库为特定列增加一个索引，例如 B-Tree 索引来加速检索。Elasticsearch 和 Lucene 使用一种叫做倒排索引 (inverted index) 的数据结构来达到相同目的。

在 Elasticsearch 中，每一个字段的数据都是默认被索引的。也就是说，每个字段专门有一个反向索引用于快速检索。一个文档不只有数据。它还包含了元数据 (metadata)——关于文档的信息。三个必须的元数据节点是：

```
_index	文档所在的索引
_type	文档代表的对象的类
_id	文档的唯一标识
_version	用于控制冲突，可以由外部指定，采用乐观锁
```

检索返回 `_source`，可以使用 `_update` API 局部更新文档，`_mget` 总会返回 200

## 安装

因为 AWS 这些云厂商一直在吸开源血，所以 ES 默认产品现在需要使用自己的 brew tap 安装：

```
brew tap elastic/tap
brew install elastic/tap/elasticsearch-full
```

## 创建索引和插入数据

Mapping 用来定义 ES 中文档的字段类型，如果使用 dynamic mapping, ES 就会在第一次见到某个字段的时候推断出字段的类型。这时候就会有问题了，比如说时间戳可能被推断成了 long 类型。

所以，一般我们会在创建索引的时候指定 mapping 的类型。

```json
PUT http://localhost:9200/company

{
  "settings": {
    "number_of_shards": 1,
    "number_of_replicas": 1,
    // 指定文本分词
    "analysis": {
      "analyzer": {
        "analyzer-name": {
          "type": "custom",
          "tokenizer": "keyword",
          "filter": "lowercase"
        }
      }
    },
  },
  // 指定字段的类型
  "mappings": {
    "properties": {
      "age": {
        "type": "long"
      },
      "experienceInYears": {
        "type": "long"      
      },
      "name": {
        "type": "text",
        "analyzer": "analyzer-name"  // 或者直接指定 ik_smart
      }
    }
  }
}
```

ES 中的类型有：boolean, binary, long, double, text, date 等。

- 如果需要存储 enum 类型的话，直接在 text 类型中指定 {"index": False} 就好了
- date 类型可以自动识别一些日期格式，比如时间戳，YYYY-mm-dd 等，也可以使用 `format` 指定，`epoch_millis`, `epoch_second ` 用来指时间戳。
- 使用 analyzer 指定分词器

插入文档

```json
POST http://localhost:9200/company/employee/?_create

{
  "name": "Andrew",
  "age" : 45,
  "experienceInYears" : 10
}
```

## Text Analyzer

众所周知，倒排索引的第一步就是要对文本进行一些预处理，尤其是分词。英文还好说，天然就是分好的，而中文则需要一些特殊的处理。虽然英文分词比较简单，但是因为会有词形的变化，所以还需要归一化。在 ES 中负责这些工作的部分叫做 Text Analyzer.

Text Analyzer 一般分为三个部分：

1. Char Filter, 也就是处理一些字符
2. Tokenizer, 也就是分词器
3. Token Filter, 也就是处理一些词。添加同义词，抽取词干也会在这里进行

当文件被添加到索引和查询索引的时候都会调用 text analyzer.

为某个字段指定 text analyzer:

```json
PUT my-index-000001
{
  "mappings": {
    "properties": {
      "title": {
        "type": "text",
        "analyzer": "whitespace"
      }
    }
  }
}
```

为某个索引指定 text analyzer:

```json
PUT my-index-000001
{
  "settings": {
    "analysis": {
      "analyzer": {
        "default": {
          "type": "simple"
        }
      }
    }
  }
}
```

### 使用 IK 分词

最常用的中文分词工具就是 IK 分词了，在 GitHub 上已经有一万个 Star 了，应该还是值得信任的。

```
elasticsearch-plugin install https://github.com/medcl/elasticsearch-analysis-ik/releases/download/v7.8.1/elasticsearch-analysis-ik-7.8.1.zip
```

其中的版本号需要替换成对应的 ES 的版本号。

IK 为 Elasticsearch 增加了两个分词器：`ik_smart`, `ik_max_word`. 其中 `ik_smart` 会分出较少的词，而 `ik_max_word` 会穷尽每一种方法分出尽量多的词。

比如说：`今天天气真好`.

- `ik_smart` 会分成：`今天天气`, `真好`.
- `ik_max_word` 会分成：`今天天气`, `今天`, `天天`, `真好`.

## 搜索

GET /_search

```json
GET /bank/_search
{
  "query": { "match_all": {} },  // 查询的条件
  "sort": [
    { "account_number": "asc" }  // 排序条件
  ],
  "from": 10,  // 用于分页
  "size": 10   // 每页大小
}
```

返回

```json
{
  "took" : 63,  // 检索花费的时长
  "timed_out" : false, // 是否超时
  "_shards" : {  // 关于检索的分片的信息
    "total" : 5,
    "successful" : 5,
    "skipped" : 0,
    "failed" : 0
  },
  "hits" : {  // 命中结果
    "total" : {  // 命中结果数量
        "value": 1000,
        "relation": "eq"
    },
    "max_score" : null,
    "hits" : [ {
      "_index" : "bank",
      "_type" : "_doc",
      "_id" : "0",
      "sort": [0],
      "_score" : null,
      // 检索到的文档内容
      "_source" : {"account_number":0,"balance":16623,"firstname":"Bradshaw","lastname":"Mckenzie","age":29,"gender":"F","address":"244 Columbus Place","employer":"Euron","email":"bradshawmckenzie@euron.com","city":"Hobucken","state":"CO"}
    }, {
      "_index" : "bank",
      "_type" : "_doc",
      "_id" : "1",
      "sort": [1],
      "_score" : null,
      "_source" : {"account_number":1,"balance":39225,"firstname":"Amber","lastname":"Duke","age":32,"gender":"M","address":"880 Holmes Lane","employer":"Pyrami","email":"amberduke@pyrami.com","city":"Brogan","state":"IL"}
    }, ...
    ]
  }
}
```

搜索中有很多参数可以调节：

1. `track_total_hits`. 默认情况下只有小于 10000 的时候结果才是精确的，因为统计有多少结果是一个 O(n) 的操作。
2. `filter`. 按照某些条件过滤结果。比如电商中，搜索衣服时候的尺码颜色等
3. `highlighter`. 在搜索结果中节选出包含关键词的部分
4. `_source`. 通过一个数组指定返回的字段。默认情况下是返回所有字段的。

### 查询字段

最简单的查询：

```json
GET /_search
{
  "query": {
    "match": {
      "message": "this is a test"
    }
  }
}
```

默认情况下，查询的字段是使用 `OR` 关系的，显然这不是我们想要的，可以指定为 `and`

```json
GET /_search
{
  "query": {
    "match": {
      "message": {
        "query": "this is a test",
        "operator": "and"
      }
    }
  }
}
```

match_all 用来读取所有文档：

```json
GET /_search
{
    "query": {
        "match_all": {}
    }
}
```

### 搜索结果翻页

使用 from 和 size 两个参数可以翻页，但是这两个参数就和 SQL 里面的 limit 和 offset 一样，页码越大，性能越低，因为他们其实就是傻乎乎的弄出所有结果来然后取中间。

除此之外，还可以使用 scroll api, 也就是让 ES 缓存住这个查询结果，每次都取一段。显然对于 ad hoc 的用户搜索来说也是不适用的。

最后一种方法是使用 search_after, 其实就相当于 SQL 中使用 where id > $id, 然后每次查询都用上次的最大 ID 就可以了。在 ES 中自然是取 sort 字段中每次查询的最大（最小）值。

```json
GET my-index-000001/_search
{
  "size": 10,
  "query": {
    "match" : {
      "message" : "foo"
    }
  },
  "search_after": [1463538857, "654323"],  // 对应 sort 中的字段
  "sort": [
    {"@timestamp": "asc"},
    {"tie_breaker_id": "asc"}
  ]
}
```

### 搜索结果排序

默认情况下，搜索结果会按照计算出来的 `_score` 也就是和搜索 query 的相关度来排序，我们也可以通过自定义 `sort` 字段来指定排序规则。

```json
GET /my-index-000001/_search
{
  "sort" : [
    { "post_date" : {"order" : "asc"}},
    "user",
    { "name" : "desc" },
    { "age" : "desc" },
    "_score",
    "_doc",
  ],
  "query" : {
    "term" : { "user" : "kimchy" }
  }
}
```

### 查询 DSL

ES 用 JSON 实现了自己的一套查询语句，基本上就是个 AST, 直接写就行了。子句分成两个：

1. 查询子句
2. 复合子句

## 设置密码

首先确保你安装的是 ES 的完全版，而不是 OSS 版本，不然是没有 xpack 的。然后在 elasticsearch.yml 中增加：

```
xpack.security.enabled: true
```

如果是在 Mac 上，可以通过 `brew info elasticsearch-full` 来查看配置文件的路径。

然后执行 `bin/elasticsearch-keystore add "bootstrap.password"` 和 `elasticsearch-setup-passwords interactive`

这时候只有再使用密码才能够接着访问：

```
curl --user elastic:123456 localhost:9200
```

## Python 客户端

### 基础使用

```
pip install elasticsearch
```

需要注意的是大版本要和使用的 elasticsearch 服务器对应。

```py
from elasticsearch import Elasticsearch

hosts = ['https://user:secret@localhost:443']
es = Elasticsearch(hosts, sniff_on_start, sniff_on_failure, sniffer_timeout=60)
```

es 的实例是线程安全的，可以在多个线程之间共享。另外需要注意的是，对于长时间运行的脚本，最好开启 sniff, 这样可以适应集群的变化。

### 全局配置

#### 忽略错误

可以通过 ignore 参数指定忽略一些错误，不过最好不要这么搞，还是显式地使用 try 比较清晰明了。

```py
es.indices.create(index='test-index', ignore=400)
es.indices.delete(index='test-index', ignore=[400, 404])
```

#### 过滤结果

通过使用 filter_path 参数可以过滤结果。ES 返回的结果本来就很冗余，这个参数还是很有用的。`*` 表示通配符

```py
es.search(index='test-index', filter_path=['hits.hits._id', 'hits.hits._type']) # returns the _id and _type
es.search(index='test-index', fitler_path=['hits.hits._*']) # returns all fileds in hits
```

### 常用查询方法

es.method(index='', doc_type='', id='', zbody='', _source=True/False...)

#### es.count(body=None, index=None, ...)

返回匹配一个 query 的文档的数量

#### es.create(index, id, body, doc_type=None, ...)

插入一个新的文档，参数名字也都挺明确的。

#### es.update(index, id, body, doc_type=None)

根据一个 id 更新文档

#### es.index(index, id, body, doc_type=None, ...)

相当于 create or update

#### es.delete(index, id, doc_type=None)

根据 id 删除一个文档

#### es.exists(index, id, ...)

根据 id 判断一个文档是否存在。

#### es.get(index, id, _source=True, ...)

根据 id 返回一个文档。

#### es.search(body=None, index=None, _source=True, from_=x, size=10,)

最核心的方法了，搜索文档

### 索引管理方法

通常通过 es.indices 属性来访问索引相关的方法

#### es.indices.analyze(body=None, index=None,...)

使用索引指定的分词器对文本进行分析。

#### es.indices.create(index, body=None,...)

创建一个索引的 mapping

#### es.indices.delete(index...)

删除一个索引

#### es.indices.get_mapping(index)

返回一个索引的 mapping

#### es.indices.put_mapping(index, body, ...)

更新一个索引的 mapping

### 批量操作 

在 es 的 helpers 中提供了一个 bulk, 也就是批量的 API 用于批量操作。语法是：

```py
from elasticsearch.helpers import bulk, parallel_bulk 

bulk(es, actions)
```

其中 es 是一个 es 的客户端，而 actions 是一个数组，或者 iterable, 其中的每个元素是：

```json
{
  "_op_type": "delete", // index/create/delete/update, 默认是 index
  "_index": "index-name",  // 索引名字
  "_id": 42,
  "doc": {...}
}
```

### 异常

一般情况下，直接 catch 住基类错误就行了

- ImproperlyConfigured 
- ElasticsearchException
  - SerializationError, json 序列化错误
  - TransportError
    - ConnectionError 
    - NotFoundError, 文档不存在，对应 404
    - ConflictError, 文档和缩影冲突，对应 409
    - RequestError, 对应 400
    - AuthenticationError, 对应 401
    - AuthorizationError, 对应 403

## 参考

1. http://www.tianshangkun.com/2018/05/15/ElasticSearch%E7%9A%84%E6%90%AD%E5%BB%BA%E4%B8%8E%E6%95%B0%E6%8D%AE%E7%BB%9F%E8%AE%A1/
2. https://segmentfault.com/a/1190000017215854
3. https://www.elastic.co/blog/found-elasticsearch-mapping-introduction
4. https://medium.com/@ashish_fagna/getting-started-with-elasticsearch-creating-indices-inserting-values-and-retrieving-data-e3122e9b12c6
5. https://elasticsearch-py.readthedocs.io/en/master/api.html
6. https://www.elastic.co/blog/phrase-Queries-a-world-without-stopwords
7. https://www.elastic.co/guide/en/elasticsearch/reference/current/built-in-users.html#set-built-in-user-passwords
8. https://stackoverflow.com/questions/16712642/elasticsearch-enum-field
9. [smartcn vs ik](https://gist.github.com/qiulang/621ccd3e69e68536d9c5236c4b31aed8)
