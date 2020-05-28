# 如何破解被 JS 加密的数据


wp_id: 463
Status: publish
Date: 2018-07-15 04:32:00
Modified: 2020-05-16 11:17:26


由于网页和JavaScript都是明文的，导致很多API接口都直接暴露在爬虫的眼里，所以好多
网站选择使用混淆后的 JavaScript 来加密接口。其中有分为两大类：

1. 通过 JavaScript 计算一个参数或者 Cookie 作为接口的签名验证
2. 返回的数据是加密的，需要使用 JavaScript 解密

不过总的来说，这两种加密的破解思路都是一样的。

1. 找到相关的网络请求。如果找不到，清空缓存，尝试触发
2. 打断点找到相关代码，可以是 ajax 断点或者 js 断点。或者直接看网络请求的
   initiator
3. 逐层分析，找到加密函数
4. 使用 node 执行js代码获得数据

# 具体步骤

有空了再写。。

参考：

1. [中国天气质量网返回结果加密的破解](https://cuiqingcai.com/5024.html)
2. [破解 Google 翻译的token](https://zhuanlan.zhihu.com/p/32139007)
3. [JavaScript 生成 Cookie](https://github.com/jhao104/spider/tree/master/PyV8%E7%A0%B4%E8%A7%A3JS%E5%8A%A0%E5%AF%86Cookie)
4. [常见加密算法](http://liehu.tass.com.cn/archives/1016)