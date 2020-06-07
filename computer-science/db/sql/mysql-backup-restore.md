# MySQL 备份与恢复


wp_id: 183
Status: publish
Date: 2017-06-15 17:50:04
Modified: 2020-05-16 11:43:06


# 基础使用

帮助命令很简单

```
Usage: mysqldump [OPTIONS] database [tables]
OR     mysqldump [OPTIONS] --databases [OPTIONS] DB1 [DB2 DB3...]
OR     mysqldump [OPTIONS] --all-databases [OPTIONS]
```

# 备份

`mysqldump -u root --password=xxx DB_NAME [TABLE_NAME] > backup.sql`

`--password` 可以直接在命令中使用密码

可以选择只 dump 一个数据库或者一个表。

# 恢复

`mysql -u root -p DB_NAME < backup.sql`

# 一行操作

```
mysqldump -u root -pPassword --all-databases | ssh user@new_host.host.com "cat - | mysql -u root -pPassword"
```

# 问题

如果直接备份所有数据库并恢复会更改 root 密码, 并且导致内部数据库不一致, 可以使用如下命令修复:

```
mysql_upgrade --force -uroot -p
```

参考:

1. https://stackoverflow.com/questions/43846950/column-count-of-mysql-user-is-wrong-expected-42-found-44-the-table-is-probabl