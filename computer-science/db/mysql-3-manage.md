# mysql 基础知识(3) - 创建修改表和权限


ID: 176
Status: publish
Date: 2017-11-12 17:02:50
Modified: 2020-05-16 11:52:44


## 创建数据库

```
CREATE DATABASE db_name
    [[DEFAULT] CHARACTER SET charset_name]
    [[DEFAULT] COLLATE collation_name]

ALTER DATABASE db_name
    [[DEFAULT] CHARACTER SET charset_name]
    [[DEFAULT] COLLATE collation_name]
```

## 创建表?

```
CREATE TABLE table_name (
    field_name type is_null default options,
    ...
    PRIMAR KEY (id),
    INDEX/KEY index_name (field_name),
) ENGINE=InnoDB;
 
// 注意：KEY is normally a synonym for INDEX
```

设定 auto_increment

注意 mysql 的关键字是 auto_increment, 而 sqlite 的是 autoincrement

```
CREATE TABLE(...) AUTO_INCREMENT=xxx;
```

更改已经存在的表

```
ALTER TABLE SET AUTO_INCREMENT=xxx;
```
 
## 数据类型

### 字符串

字符串分两种，定长和变长，MySQL处理定长数据比变长数据快得多。CHAR属于定长类型，VARCHAR和TEXT属于变长类型。

* CHAR的长度为1-255，默认为1，使用CHAR(n)指定长度
* VARCHAR为0-255，使用VARCHAR(n)指定长度
* TEXT为65536，MEDIUMTEXT为16k，LONGTEXT为4GB

![](http://ws3.sinaimg.cn/large/006tNc79ly1ft17mebw0kj31900n6wkx.jpg)

### 数字

注意数字后面跟的数字，例如INT(5)，并不是限制数字的存储长度，而是限制数字的展示长度（显示时填充0）！可以使用UNSIGNED指定为非负值，默认为signed

![](http://ws4.sinaimg.cn/large/006tNc79ly1ft17lhmrv7j30wk0fswh3.jpg)

### 日期

使用DATETIME，不要使用TIMESTAMP，防止2038年溢出

![](http://ws4.sinaimg.cn/large/006tNc79ly1ft17luawbtj312w09kabw.jpg)

### tips

#### 创建 modify_time/update_time 字段时使用自动更新时间

```
&#x60;modify_time&#x60; timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
```

#### 设计表要注意每个字段的正交性，不要出现一个字段表示“xx且xx”的状态。

 
## 更新表

```
rename table &#039;old_name&#039; to &#039;new_name&#039;
```

添加一列，其中的 COLUMN 关键字是 optional 的。

```
ALTER TABLE table_name ADD COLUMN field_name type;
```

更新某个字段的数据类型

```
Alter TABLE &#x60;tableName&#x60; MODIFY COLUMN &#x60;ColumnName&#x60; datatype(length);
```

比如说：

```
Alter TABLE &#x60;tbl_users&#x60; MODIFY COLUMN &#x60;dup&#x60; VARCHAR(120);
```

### 重命名一列

需要注意的是数据类型也需要带上

```
alter table &#x60;user&#x60; change &#x60;name&#x60; &#x60;first_name&#x60; varchar(128) default null;
```

添加不同类型的索引

```
ALTER TABLE table_name ADD INDEX index_name (column_list)

ALTER TABLE table_name ADD UNIQUE index_name (column_list)

ALTER TABLE table_name ADD PRIMARY KEY index_name (column_list)
```

需要注意的是 mysql 索引的最大长度是 255，也就是在 VARCHAR(255) 以上的列是不能添加索引的，一个改进方法就是另外添加一列存储这一列的 hash 值。

## 删除字段

删除索引

```
alter table TABLENAME drop index xxxx
```

------------------之前笔记的分割线------------------------
 
 
## 组合索引
 
如果有一个组合索引(col_a,col_b,col_c)
 
下面的情况都会用到这个索引：

```
col_a = &quot;some value&quot;;
col_a = &quot;some value&quot; and col_b = &quot;some value&quot;;
col_a = &quot;some value&quot; and col_b = &quot;some value&quot; and col_c = &quot;some value&quot;;
col_b = &quot;some value&quot; and col_a = &quot;some value&quot; and col_c = &quot;some value&quot;;
```

对于最后一条语句，mysql会自动优化成第三条的样子
 
下面的情况就不会用到索引：

```
col_b = &quot;aaaaaa&quot;;
col_b = &quot;aaaa&quot; and col_c = &quot;cccccc&quot;;
```