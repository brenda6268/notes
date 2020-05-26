# MySQL “incorrect string value” error when save unicode string in Django


ID: 709
Status: publish
Date: 2017-06-07 08:47:00
Modified: 2017-06-07 08:47:00


# Why this happens?

You cannot store 4-byte characters in MySQL with the utf-8 character set.

# solution
```
#! /usr/bin/env python
import MySQLdb

host = "localhost"
passwd = "passwd"
user = "youruser"
dbname = "yourdbname"

db = MySQLdb.connect(host=host, user=user, passwd=passwd, db=dbname)
cursor = db.cursor()

cursor.execute("ALTER DATABASE `%s` CHARACTER SET 'utf8' COLLATE 'utf8_unicode_ci'" % dbname)

sql = "SELECT DISTINCT(table_name) FROM information_schema.columns WHERE table_schema = '%s'" % dbname
cursor.execute(sql)

results = cursor.fetchall()
for row in results:
    sql = "ALTER TABLE `%s` convert to character set DEFAULT COLLATE DEFAULT" % (row[0])
    cursor.execute(sql)
db.commit()
db.close()
```

Reference:

https://stackoverflow.com/questions/2108824