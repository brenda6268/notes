# Go 语言数据库教程


wp_id: 728
Status: publish
Date: 2018-04-04 04:10:00
Modified: 2020-05-16 11:31:41


在学习 Go 的过程中重新思考了数据库相关的一些知识，之前认为数据库的驱动就是应该有一个 conn 对象表示连接， 然后再有一个 cursor 对象来具体操作。但是 Go 完全没有这么来，而是直接生成一个 db 对象来操作，开始觉得不适应，然而后来我也实在想不起来为什么需要用两个对象了。

另外，为什么要用 ORM 呢？之前用 Django 的ORM比较多，因为生成后台非常方便，而且自己对 SQL 也不是很熟悉，对数据库的操作基本上都在使用这个ORM。然而，现在感觉到如果想要自己的代码性能比较高的话，自己手工写 SQL 几乎是不可避免的，而且 SQL 其实也没有那么吓人。

Go语言中的 `database/sql` 包提供了一个数据库的访问接口，但是对于不同的数据库，还需要不同的驱动。

一些常见的数据库的驱动参见这里：http://golang.org/s/sqldrivers。

# 连接数据库

```
db, err := sql.Open(driver, dataSourceName)
```

这里值得注意的有两点

1. Go语言中不像其他语言一样，除了 connection 对象之外还有 cursor 对象，golang 里面很简单，直接用db对象操作就好了。
2. Open 函数并不会去真的链接数据库，直到第一条语句才会去链接，如果想检测是否连接成功，可以使用:

```
if err := db.Ping(); err != nil {
  log.Fatal(err)
}
```

# 执行语句

使用 `db.Exec` 方法

```
result, err := db.Exec(
	"INSERT INTO users (name, age) VALUES ($1, $2)",
	"gopher",
	27,
)
```

result 类型定义如下：

```
type Result Interface {
    LastInsertId()
    RowAffcted()
}
```

# 查询

```
rows, err := db.Query(
    "SELECT NAME FROM  users WHERE age = $1",
    age
)

if err != nil {
    log.Fatal(err)
}

for rows.Next() {
    var name string
    if err := rows.Scan(&amp;name); err != nil {
        log.Fatal(err)
    }
    fmt.Printf("%s is %d old\n", name, age)
}

if err := rows.Err(); err != nil {
    log.Fata(err)
}
```

Row 有一个方法 Scan，而 Rows 中常用的两个方法是 Next 和 Err

如果查询结果只有一列的话，使用 QueryRow 方法。

```
var age int64
row := db.QueryRow("SELECT age FROM users WHERE name = $1", name)
err := row.Scan(&amp;age)
```

当然像其他所有的语言一样，可以预编译语句然后执行。

```
age := 27
stme, err := db.Prepare("SELECT name FROM users WHERE age = $1")
if err != nil {
    log.Fatal(err)
}
rows, err := stmt.Query(age)
defer stmt.Close()
```

# 事务（Transaction）

```
tx, err := db.Begin()
if err != nil {
    log.Fatal(err)
}
...
tx.Commit() 
// or tx.Rollback()
```


# 处理 null

如果一列可能为 null 的话，那么传递个Scan的参数就不应该是对应的基础类型，而应该是对应的包含null的复合类型

```
var name NullString
err := db.QueryRow("SELECT name FROM names WHERE id = $1", &amp;name)
if name.Valid {
   // 使用 name.String 访问
} else {
  //
}
```

除此之外还包含了其他几种 Null 复合值，NullBool、NullFloat64、NullInt64。可以使用对应的参数访问

# 使用 sqlite3

```
% go get github.com/mattn/go-sqlite3
```

```
import (
    "database/sql"
    _ "github.com/mattn/go-sqlite3"
)

db, err := sql.Open("sqlite3", "./foo.db")
```

# sqlx

待续