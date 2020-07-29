# sqlite3 和在 Python 中的使用教程

<!--
ID: fa794597-6a81-4fae-81a1-74b0a0a22468
Status: publish
Date: 2018-04-04T05:17:00
Modified: 2020-05-16T11:32:32
wp_id: 672
-->

Yifei's notes:

所谓的事务、锁、存储过程、外键等等不适合互联网公司的业务场景，而更适合于“企业级”“IOE”这些应用。

# sqlite3

% sqlite3 DATABASE

```
.databases	show databases connected to
.dump TABLE	dump table in SQL format
.import FILE ?TABLE?	import SQL data into table
.indices ?TABLE?	show indices of table
.mode MODE	set output mode(csv, column
.read FILE	excute FILE
.schema ?TABLE?	show create statement
.restore  ?DB? FILE	restore db from file
.headers ON|OFF	show headers
```

## 美化输出

让 sqlite 的输出更美观，使用 `.mode column` 和 `.headers on` 两个命令

```
sqlite> select * from foo;
234|kshitiz|dba.se

sqlite> .mode column
sqlite> select * from foo;
234         kshitiz     dba.se

sqlite> .headers on
sqlite> select * from foo;
bar         baz         baf
----------  ----------  ----------
234         kshitiz     dba.se
```

## 导入导出 csv

导出
```
sqlite> .mode csv   -- use ".separator SOME_STRING" for something other than a comma.
sqlite> .headers on 
sqlite> .out file.dmp 
sqlite> select * from MyTable;
```

导入

```
sqlite> .mode csv
sqlite> .import CSV_FILE TABLE_NAME
```

## 备份还原

sqlite3 DATABASE .dump > backup.sql
sqlite3 DATABASE < backup.sql

或者

```
sqlite3> .read backup.sql
sqlite3> .dump backup.sql
```

# 在 Python 中使用 SQLite

首先连接到数据库，获得 connection 对象，然后再获得 cursor，使用 cursor 来执行 sql 语句并获取结果。

## 连接

```
import sqlite3

conn = sqlite3.connect("database.db")  # connections
cursor = conn.cursor()  # get cursor
cursor.execute("CREATE TABLE books (id int primary key, name text)")
cursor.execute("INSERT INTO books (name) VALUES (" sophie"s choice")")
cursor.execute("INSERT INTO books (name) VALUES ("the bible")")
conn.commit()  # always remember to commit
cursor.execute("SELECT * FROM books")

conn.close()
```

或者使用 with 语句

```
with sqlite3.connect("db") as conn:
    cursor = conn.cursor()
    # cursor executes
```

## 构建语句

```
# fabricating statement
cursor.execute("select from books where name = ?", ("the bible",)) 
# NOTE the param must be a sequence

# You could also use named placeholders
cursor.execute("insert into books (name) values (:name)", {name: "the bible"})
```

## 获取数据

有两种方式:

使用 fetchone, fetchmany(n), fetchall

```
r = c.execute("SELECT id FROM stocks WHERE name = "MSFT"")
id = r.fetchone()[0]
```

直接迭代返回结果

```
for row in c.execute("SELECT * FROM stocks ORDER BY price"):
    print row[0], row[1], row["id"], row["name"]
```

注意结果每行是一个 tuple 或者一个 dict，即使 select 了一个元素，结果也是 tuple。

## 其他

lastrowid

This read-only attribute provides the rowid of the last modified row. It is only set if you issued a INSERT statement using the execute()method. For operations other than INSERT or when executemany() is called, lastrowid is set to None.