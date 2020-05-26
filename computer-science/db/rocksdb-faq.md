# RocksDB 常见问题


ID: 574
Status: publish
Date: 2017-11-11 03:34:00
Modified: 2020-05-16 11:51:49


## RocksDB 会抛出异常吗?

不会, RocksDB会返回一个Status表示成功或者失败, 但是RocksDB并没有捕获STL中的异常, 比如bad_alloc这种

## 基础操作是线程安全的吗?

是的

## 可以使用多个进程(process)同时读写 RocksDB 吗?

不可以, 当然只读模式随意