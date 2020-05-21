https://clickhouse.tech/docs/en/


clickhouse 是一个分析型列式数据库。这种数据库一般不支持事务。

为什么列存储数据库更快？

1. 按列存储，需要扫描的数据很少
2. 使用向量化指令
3. 代码生成，吞吐大。