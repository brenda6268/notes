# SDE 面试问题储备

<!--
ID: ba213c53-05c8-45d4-811c-a12823f8c090
Status: publish
Date: 2019-06-15T18:13:07
Modified: 2020-05-16T10:56:20
wp_id: 128
-->

## 前提

- English is a MUST.
    文艺复兴以降，西方积累了几百年的知识不是一朝一夕就能超越的。即使我们现在在某些方面已经取得了优势，也应该虚心学习。阅读英文文档是对个人能力的极大提升。
- 如果只会一门语言，大大减分，尤其是只会 Java
    一个合格的程序员工作中可能只使用一种主力语言，但是不应该故步自封，停留在一个语言的一个非常不好的征兆。尤其是 Java 程序员，好多都对外界的知识完全不了解。Java 是一门优秀的语言，但是很多其他语言也都有各自的优点。

## 综合型问题

- 如何实现一个服务器？[用 python 理解服务器模型](https://www.textarea.com/zhicheng/yong-python-lijie-fuwuqi-moxing-shang-566/)
- 统计 Redis 中每个 Key 占用的空间大小
- 设计一个翻页系统。使用 select * from table limit 10 offset 10 翻页有什么问题 [参考](https://mp.weixin.qq.com/s?__biz=MzAwNjY3MjgzOA==&mid=2477610597&idx=1&sn=a02927f603b49213e983bd040e7af9f8)
- 如何实现 adblock plus 的过滤算法
- 敏感词过滤算法
- 简单设计一下群聊或者微博的 feed。推和拉各有什么优缺点？
- http 请求的实现？http 代理的原理如何？https 代理呢？

## 数据库

### LSM 和 B+树各有什么优缺点？什么是为读优化，什么是为写入优化
### 用数据库的自增 ID 来作为唯一 ID 有什么问题呢？使用 UUID 呢？

1. 使用 limit offset。实现非常简单，但是当页码越来越大的时候，查询会越来越慢
2. 记录 id，每次查询都按条件 where id > x 过滤。缺点是需要记录中间状态。

## 前端

- 虚拟 DOM 如何实现？虚拟 DOM 的 diff 算法如何实现

## 智商鉴定题

- int main() 和 void main() 的区别是什么？哪种是对的？