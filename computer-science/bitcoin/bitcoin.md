# 比特币相关技术调研


ID: 716
Status: publish
Date: 2018-04-04 05:28:00
Modified: 2020-05-16 11:32:59


# 挖矿

比特币的挖矿算法是CPU密集型的，所以可以使用特殊的硬件，比如 FPGA 或者 ASIC 来加速。后续的好多加密货币，比如ETH 等，都特意选择了不是CPU密集型的算法，从而避免这种使用特殊硬件挖矿造成的不公平。[挖矿硬件的发展][1]

比特币的挖矿算法就核心来言就是下面几句：

```
while (1)
 HDR[kNoncePos]++;
 IF (SHA256(SHA256(HDR)) &lt; (65535 &lt;&lt; 208)/ DIFFICULTY) return;
```

monero 使用了适合于现代CPU的AES算法，参见[这里][2]

# 货币

USDT：风险就在于这家公司随时可能跑路。。
Siacoin: 用于分布式文件存储的货币，但是因为加密算法被比特大陆做出了矿机，所以价格一路狂泻。。(2018-02-04)
Filecoin: 
比特股：https://www.zhihu.com/question/28812361
比特股还衍生出了 bitcny 和 bitusd 等货币。国内可以使用鼓鼓钱包

https://chainnews.com/articles/768752760963.htm

# 问题

比特币和以太币的确认速度都特别慢，比特币在 7笔每秒，以太币在15笔每秒

石墨烯技术

区块链技术

在区块链中存储数据

In 2013, a feature was introduced into the Bitcoin protocol that allows us to do just that: create a special kind of transaction (called an OP_RETURN transaction) inside which you can embed tiny amounts of data, 40 bytes, in transactions. Originally it was intended to be used for attaching contextual information to Bitcoin transactions, such as shipping information. A more creative way of using the feature is to create the smallest possible transaction (0.00000001 BTC, or a satoshi, plus the transaction fees) and embed whatever information you want that can fit inside it. 比如你可以把一个文件的hash存在这个文件中，那么就可以证明在某一个时间点，这个文件是存在的


[1]: http://cseweb.ucsd.edu/~mbtaylor/papers/Taylor_Bitcoin_IEEE_Computer_2017.pdf

[2]: https://monero.stackexchange.com/questions/1110/where-can-i-find-a-description-of-the-cryptonight-hash-algorithm

[3]: http://joel.mn/post/104755282493/the-shared-data-layer-of-the-blockchain
