# Python 标准的 DB API

Date: 2020-01-20

DB API 2.0(PEP 249) 是 Python 给数据库驱动定义的一个规范。sqlite 和 mysql 的客户端都遵守这个规范。

connect 方法连接数据库，返回一个 Connection 对象。

## 错误体系

```
StandardError
|__Warning
|__Error
   |__InterfaceError
   |__DatabaseError
      |__DataError
      |__OperationalError
      |__IntegrityError
      |__InternalError
      |__ProgrammingError
      |__NotSupportedError
```

## Connection 对象

.close() 方法。关闭连接
.commit() 方法。提交一个事务
.rollback() 方法。回滚一个事务
.cursor() 方法。返回一个游标。

## Cursor 对象

cursor.rowcount 返回上一次 execute 后产生的行数

.close() 关闭游标

.execute(stmt, params) 执行一个方法

.executemany(stmt, list of params)

.fetchone() 返回一条记录，如果没有，返回 None

.fetchmany(size) 返回多条记录

.fetchall() 返回所有记录

cursor 对象还支持直接遍历
