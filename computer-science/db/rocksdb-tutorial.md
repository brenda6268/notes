# RocksDB 基础操作教程


wp_id: 578
Status: publish
Date: 2017-11-11 03:59:00
Modified: 2020-05-16 11:51:58


## 打开一个数据库

```
  #include <cassert>
  #include "rocksdb/db.h"

  rocksdb::DB* db;
  rocksdb::Options options;
  options.create_if_missing = true;
  options.error_if_exists = true;
  rocksdb::Status status = rocksdb::DB::Open(options, "/tmp/testdb", &amp;db);
  assert(status.ok());
  ...
```

通过options制定一些属性, 然后用 `rocksdb::DB::Open`打开. RocksDB 会把使用的配置保存在 `OPTIONS-xxxx` 文件中.

注意上面返回的那个status变量, 在RocksDB中所有会遇到错误的函数都会返回这个变量, 可以用来检查有没有出错.

```
   rocksdb::Status s = ...;
   if (!s.ok()) cerr << s.ToString() << endl;
```

关闭数据库, 只需要简单得把指针释放就可以了: `delete db`.

## 读写数据库

基本的Put, Get, Delete:

```
  std::string value;
  rocksdb::Status s = db->Get(rocksdb::ReadOptions(), key1, &amp;value);
  if (s.ok()) s = db->Put(rocksdb::WriteOptions(), key2, value);
  if (s.ok()) s = db->Delete(rocksdb::WriteOptions(), key1);
```

注意其中每次都检查了操作是否成功.

每次 Get 操作都会导致至少一次的memcpy, 如果不想要这种浪费的话, 可以使用 PinnableSlice 操作.

```
  PinnableSlice pinnable_val;
  rocksdb::Status s = db->Get(rocksdb::ReadOptions(), key1, &amp;pinnable_val);
```

## 原子操作

使用`WriteBatch`来构成一个原子性的操作. 什么是原子性操作总不用多说吧...原子操作不仅保证了原子性, 而且一般来说对性能也有帮助

```
  #include "rocksdb/write_batch.h"
  ...
  std::string value;
  rocksdb::Status s = db->Get(rocksdb::ReadOptions(), key1, &amp;value);
  if (s.ok()) {
    rocksdb::WriteBatch batch;
    batch.Delete(key1);
    batch.Put(key2, value);
    s = db->Write(rocksdb::WriteOptions(), &amp;batch);
  }
```

## 同步与异步读写

这块没看明白...

默认的是异步读写, 如果使用了`sync`这个标志, 那么就是同步读写了

```
  rocksdb::WriteOptions write_options;
  write_options.sync = true;
  db->Put(write_options, ...);
```

异步读写经常会比同步读写快上1000倍, 但是当机器down掉的时候, 会丢失最后的几个写入. 不过通常来说, 可以认为异步读写安全性也是够的.

除了可以使用异步读写以外, 还可以使用 `WriteBatch` 来批量读写.

## 并发

一个数据库同时只能被一个进程读写. 但是一个db实例的`Get`操作都是线程安全的, 而`WriteBatch`等操作可能需要其他一些同步机制

## Merge 操作符

待续

## Iterators

遍历所有的key

```
  rocksdb::Iterator* it = db->NewIterator(rocksdb::ReadOptions());
  for (it->SeekToFirst(); it->Valid(); it->Next()) {
    cout << it->key().ToString() << ": " << it->value().ToString() << endl;
  }
  assert(it->status().ok()); // Check for any errors found during the scan
  delete it;
```

遍历[start, limit)之间的值

```
  for (it->Seek(start);
       it->Valid() &amp;&amp; it->key().ToString() < limit;
       it->Next()) {
    ...
  }
  assert(it->status().ok()); // Check for any errors found during the scan
```

反向遍历

```
  for (it->SeekToLast(); it->Valid(); it->Prev()) {
    ...
  }
  assert(it->status().ok()); // Check for any errors found during the scan
```

## Snapshot(快照)

Snapshot 提供了当前系统在某一点的一个只读的状态表示.

```
  rocksdb::ReadOptions options;
  options.snapshot = db->GetSnapshot();
  ... apply some updates to db ...
  rocksdb::Iterator* iter = db->NewIterator(options);
  ... read using iter to view the state when the snapshot was created ...
  delete iter;
  db->ReleaseSnapshot(options.snapshot);
```

注意这里通过snapshot读到的都是在做snapshot那个时间点的数据库的值.

## Slice

上面提到的 `iter->key()` 和 `iter-value()` 的返回值都是 `rocksdb::Slice` 类型的. Slice 仅仅是一个包含了长度和指针的bytearray. 它本身并不储存值, 这样也就避免了拷贝.

Slice和string的互相转换:

```
   rocksdb::Slice s1 = "hello";

   std::string str("world");
   rocksdb::Slice s2 = str;

   std::string str = s1.ToString();
   assert(str == std::string("hello"));
```

未完待续...