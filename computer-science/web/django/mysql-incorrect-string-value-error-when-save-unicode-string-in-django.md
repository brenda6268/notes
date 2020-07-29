# MySQL “incorrect string value” error when save unicode string in Django

<!--
ID: 763214f2-29c6-4616-9e82-07c0b8c81ca1
Status: publish
Date: 2017-06-07T08:47:00
Modified: 2017-06-07T08:47:00
wp_id: 709
-->

## Why this happens?

You cannot store 4-byte characters in MySQL with the utf-8 character set.

## solution
```py
#!/usr/bin/env python
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