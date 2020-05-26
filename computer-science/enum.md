# 使用枚举还是常量表？


ID: 324
Status: draft
Date: 2017-05-30 08:16:00
Modified: 2020-05-16 12:00:48


Yifei's Notes

实际上还是使用枚举多一些，毕竟改代码方便。而要使用常量表存在数据库中的话，很可能造成多一两次数据库查询，没有必要。

lookup table wins for the most time

use enum when you choice is locked to be a few, such as gender: Male and Female, otherwise, lookup table

http://stackoverflow.com/questions/433490/lookup-tables-best-practices-db-tables-or-enumerations