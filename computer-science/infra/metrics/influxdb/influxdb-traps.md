# influxdb 排坑记

<!--
ID: 54fc4ecc-50ae-4310-b0e0-ea453a0a9a63
Status: publish
Date: 2018-10-30T19:01:00
Modified: 2020-05-16T11:26:12
wp_id: 748
-->

# 相同点覆盖

> Duplicate points

> A point is uniquely identified by the measurement name, tag set, and timestamp. If you submit Line Protocol with the same measurement, tag set, and timestamp, but with a different field set, the field set becomes the union of the old field set and the new field set, where any conflicts favor the new field set.

相同的 measurement，tagset 和 timestamp 的数据会覆盖

解决方法：

1. 提高时间精度
2. 增加一个tag来标识不同的点
3. 预处理数据 ✔️

# 每个点的 tag 数量

opentsdb 限制为每个点 8 个 tag

influxdb 限制不明确，最好也不要太多

## 在设计数据库是需要考虑的是，同一类型的字段作为 tag key 还是 tag value？

两种情况分别为：

```
time        key1 key2 key3
1500000000  true true true
1500000001  true false false
```

```
time        key   value
1500000000  _key1 true
1500000000  _key2 true
1500000000  _key3 true
1500000001  _key1 true
1500000001  _key2 false
1500000001  _key3 false
```

假设某个类型的字段可选值为 k 个，而一个用有 n 个这样的字段。如果作为 tag key，那么可能数据库的 series 复杂度是 O(k^n)。而作为 tag value，那么数据库的复杂度是 O(k * n)。也就是第二种的 series 复杂度大大降低。

但是对于第二种方法，效果就是打的点更多。第一种方法打点 m 个的时候，第二种需要 m * n 个。

另外考虑对于 down sampling 的友好性，虽然第二种造成点更多，但是在进行 down sampling 的时候有更好的压缩效率。

https://docs.influxdata.com/influxdb/v1.2/concepts/schema_and_data_layout/#don-t-have-too-many-series

# max-values-per-tag 限制

每个 tag 可选值也有限制，不能超过10万，tag用于标识点，而不是用于存储数据，如果需要存储数据，应该使用 fields。

比如：

- 域名：可选范围很大
- 邮箱：可选范围几乎无限大
- UUID

# max-series-per-database 限制

tagset 的定义：每一个点的 tag key 和 tag value 的组合
series 的定义：使用同一个 measurement，retention policy，tagset 组合的点的集合

每一个数据库中的 series 的数量不能超过 100 万

以上连个限制的原因在于，influxdb 为每个 series 建立了索引并且常驻内存，如果过大

# tag 只能存储字符串


一般来说，在 tag 中应该存储的是 enum 的值，而不是任意的字符串。

# 推荐配置

https://docs.influxdata.com/influxdb/v1.6/concepts/schema_and_data_layout/

如果想要使用 group by，推荐使用 tags
如果需要使用函数（mean，sum）， 只有 fields 才能
如果需要使用数字，只有 fields 才能

# 硬件配置

https://docs.influxdata.com/influxdb/v1.6/guides/hardware_sizing/