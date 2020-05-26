# mysql 基础知识(7) - JSON 字段


ID: 180
Status: publish
Date: 2018-05-20 17:30:34
Modified: 2020-05-16 11:39:07


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
  &#039;ECMAScript 2015: A SitePoint Anthology&#039;,
  &#039;[&quot;JavaScript&quot;, &quot;ES2015&quot;, &quot;JSON&quot;]&#039;
);
```

使用一个 json 字符串作为值插入即可。或者你也可以使用 json 相关的函数来表示json。

# json 相关函数

## json path

```
-- returns &quot;SitePoint&quot;:
SELECT JSON_EXTRACT(
  &#039;{&quot;id&quot;: 1, &quot;website&quot;: &quot;SitePoint&quot;}&#039;, 
  &#039;$.website&#039;
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
  &quot;a&quot;: 1,
  &quot;b&quot;: 2,
  &quot;c&quot;: [3, 4],
  &quot;d&quot;: {
    &quot;e&quot;: 5,
    &quot;f&quot;: 6
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
-- returns [1, 2, &quot;abc&quot;]:
SELECT JSON_ARRAY(1, 2, &#039;abc&#039;);

-- returns {&quot;a&quot;: 1, &quot;b&quot;: 2}:
SELECT JSON_OBJECT(&#039;a&#039;, 1, &#039;b&#039;, 2);

-- returns [&quot;a&quot;, 1, {&quot;key&quot;: &quot;value&quot;}]:
SELECT JSON_MERGE(&#039;[&quot;a&quot;, 1]&#039;, &#039;{&quot;key&quot;: &quot;value&quot;}&#039;);

-- returns ARRAY:
SELECT JSON_TYPE(&#039;[1, 2, &quot;abc&quot;]&#039;);

-- returns OBJECT:
SELECT JSON_TYPE(&#039;{&quot;a&quot;: 1, &quot;b&quot;: 2}&#039;);

-- returns an error:
SELECT JSON_TYPE(&#039;{&quot;a&quot;: 1, &quot;b&quot;: 2&#039;);

-- returns 1:
SELECT JSON_VALID(&#039;[1, 2, &quot;abc&quot;]&#039;);
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
-- all books with the &#039;JavaScript&#039; tag:
SELECT * FROM &#x60;book&#x60; 
WHERE JSON_CONTAINS(tags, &#039;[&quot;JavaScript&quot;]&#039;);
```

json_search 用于选取字典中包含某个值的行

```
-- all books with tags starting &#039;Java&#039;:
SELECT * FROM &#x60;book&#x60; 
WHERE JSON_SEARCH(tags, &#039;one&#039;, &#039;Java%&#039;) IS NOT NULL;
```

### 用于 select 子句中的 json 函数

可以使用 json path 语法从得到的 json 文档中抽取出某个值。

## select 语句

要想在select语句中使用 json path 抽取元素可以使用下面的语法，也就是 `column->path`

```
SELECT
  name,
  tags-&gt;&quot;$[0]&quot; AS &#x60;tag1&#x60;
FROM &#x60;book&#x60;;
```

一个更复杂一点的例子：

id|name|profile
--|----|-------
1|Craig|{“twitter”: “@craigbuckler”,“facebook”: “craigbuckler”,“googleplus”: “craigbuckler”}
2|SitePoint|{“twitter”: “@sitepointdotcom”}

```
SELECT
  name, profile-&gt;&quot;$.twitter&quot; AS &#x60;twitter&#x60;
FROM &#x60;user&#x60;;
```

```
SELECT
  name, profile-&gt;&quot;$.twitter&quot; AS &#x60;twitter&#x60;
FROM &#x60;user&#x60;
WHERE
  profile-&gt;&quot;$.twitter&quot; IS NOT NULL;
```


REF:

1. https://www.sitepoint.com/use-json-data-fields-mysql-databases/