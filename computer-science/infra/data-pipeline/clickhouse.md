# ClickHouse

<!--
ID: f976c512-c6d1-4d55-bb4e-0458aba0ecb8
Status: draft
Date: 2020-05-28T14:09:32
Modified: 2020-05-28T14:09:32
wp_id: 1047
-->

https://clickhouse.tech/docs/en/


clickhouse 是一个分析型列式数据库。这种数据库一般不支持事务。

为什么列存储数据库更快？

1. 按列存储，需要扫描的数据很少
2. 使用向量化指令
3. 代码生成，吞吐大。