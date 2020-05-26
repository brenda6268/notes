# Sequel Pro cannot create a JSON value from a string with CHARACTER SET 'binary'


ID: 773
Status: publish
Date: 2019-10-15 12:03:31
Modified: 2019-10-15 12:03:31


> I had this problem dealing with exports made by Sequel Pro. I unchecked the Output BLOB fields as hex option and the problem went away. Visually inspecting the export showed legible JSON instead of binary.

导出数据的时候把 “Output BLOB fields as hex” 这个选项取消就可以了。

参考：https://stackoverflow.com/questions/38078119/mysql-5-7-12-import-cannot-create-a-json-value-from-a-string-with-character-set