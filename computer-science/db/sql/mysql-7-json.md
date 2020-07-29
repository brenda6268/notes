# mysql 基础知识(7) - JSON 字段

<!--
ID: 59d027f7-fe5f-4c25-9840-1aace2f85741
Status: publish
Date: 2018-05-20T17:30:34
Modified: 2020-05-16T11:39:07
wp_id: 180
-->

在前公司的时候，大家习惯在每个表加一个 extra 字段来表示一些额外的字段，然后在 ORM 中使用的时候再解析出来，方便了扩展字段，但是缺点也很明显，extra 字段只能读取而无法进行查询。MySQL 5.7 终于支持了 json 字段，相当于加入了一些 NoSQL 的特性，这样就可以很方便得查询了。

# json 字段的使用

建表：

```
CREATE TABLE &#x60;book&#x60; (
  &#x60;id&#x60; mediumint(8) unsigned NOT NULL AUTO_INCREMENT,
  &#x60;title&#x60; varchar(200) NOT NULL,
  &#x60;tags&#x60; json DEFAULT NULL,
  PRIMARY KEY (&#x60;id&#x60;)
) ENGINE=InnoDB;
```

直接使用 json 类型就可以了。注意 json 字段不可以作为主键，不可以作为外键，不过既然是 json 字段了，谁会这么做呢。。

插入：

```
INSERT INTO &#x60;book&#x60; (&#x60;title&#x60;, &#x60;tags&#x60;)
VALUES (
  "ECMAScript 2015: A SitePoint Anthology",
  "["JavaScript", "ES2015", "JSON"]"
);
```

使用一个 json 字符串作为值插入即可。或者你也可以使用 json 相关的函数来表示json。

# json 相关函数

## json path

```
-- returns "SitePoint":
SELECT JSON_EXTRACT(
  "{"id": 1, "website": "SitePoint"}", 
  "$.website"
);
```

json path 的语法，用 $ 开头，然后跟着下面的选择器:

* `.` 点后面跟着跟着一个字典里的名字, 比如 $.website
* `[N]` 表示数组里的第 N 个元素
* `.[*]` 表示选择字典里的所有元素
* `[*]` 表示选择数组里的所有元素
* `prefix**suffix` 表示以 prefix 开头，suffix 结尾的所有路径

举个栗子

```
{
  "a": 1,
  "b": 2,
  "c": [3, 4],
  "d": {
    "e": 5,
    "f": 6
  }
}
the following paths:

$.a returns 1
$.c returns [3, 4]
$.c[1] returns 4
$.d.e returns 5
$**.e returns [5]
```

## 构造、修改 json 的函数

函数都比较简单，看注释就明白了。

```
-- returns [1, 2, "abc"]:
SELECT JSON_ARRAY(1, 2, "abc");

-- returns {"a": 1, "b": 2}:
SELECT JSON_OBJECT("a", 1, "b", 2);

-- returns ["a", 1, {"key": "value"}]:
SELECT JSON_MERGE("["a", 1]", "{"key": "value"}");

-- returns ARRAY:
SELECT JSON_TYPE("[1, 2, "abc"]");

-- returns OBJECT:
SELECT JSON_TYPE("{"a": 1, "b": 2}");

-- returns an error:
SELECT JSON_TYPE("{"a": 1, "b": 2");

-- returns 1:
SELECT JSON_VALID("[1, 2, "abc"]");
```

还有其他一些函数，可以查看文档：

* JSON_SET(doc, path, val[, path, val]...) —
inserts or updates data in the document
* JSON_INSERT(doc, path, val[, path, val]...) —
inserts data into the document
* JSON_REPLACE(doc, path, val[, path, val]...) —
replaces data in the document
* JSON_MERGE(doc, doc[, doc]...) —
merges two or more documents
* JSON_ARRAY_APPEND(doc, path, val[, path, val]...) —
appends values to the end of an array
* JSON_ARRAY_INSERT(doc, path, val[, path, val]...) —
inserts an array within the document
* JSON_REMOVE(doc, path[, path]...) —
removes data from the document.

## 查询 json 函数

### 用于 where 子句中的函数

json_contains 用于选取数组中包含某个元素的行

```
-- all books with the "JavaScript" tag:
SELECT * FROM &#x60;book&#x60; 
WHERE JSON_CONTAINS(tags, "["JavaScript"]");
```

json_search 用于选取字典中包含某个值的行

```
-- all books with tags starting "Java":
SELECT * FROM &#x60;book&#x60; 
WHERE JSON_SEARCH(tags, "one", "Java%") IS NOT NULL;
```

### 用于 select 子句中的 json 函数

可以使用 json path 语法从得到的 json 文档中抽取出某个值。

## select 语句

要想在select语句中使用 json path 抽取元素可以使用下面的语法，也就是 `column->path`

```
SELECT
  name,
  tags->"$[0]" AS &#x60;tag1&#x60;
FROM &#x60;book&#x60;;
```

一个更复杂一点的例子：

id|name|profile
--|----|-------
1|Craig|{“twitter”: “@craigbuckler”,“facebook”: “craigbuckler”,“googleplus”: “craigbuckler”}
2|SitePoint|{“twitter”: “@sitepointdotcom”}

```
SELECT
  name, profile->"$.twitter" AS &#x60;twitter&#x60;
FROM &#x60;user&#x60;;
```

```
SELECT
  name, profile->"$.twitter" AS &#x60;twitter&#x60;
FROM &#x60;user&#x60;
WHERE
  profile->"$.twitter" IS NOT NULL;
```


REF:

1. https://www.sitepoint.com/use-json-data-fields-mysql-databases/