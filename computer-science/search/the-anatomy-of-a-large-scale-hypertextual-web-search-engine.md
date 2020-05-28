# 读《The Anatomy of a large-scale hypertextual Web search engine》


wp_id: 449
Status: publish
Date: 2018-04-13 05:48:00
Modified: 2020-05-16 11:35:40


Google 在1997年的论文[1], 到现在(2017)的话, 已经有二十年的历史了, 然而对于编写一个小的搜索引擎, 依然有好多具有指导意义的地方.

The Anatomy of a large-scale hypertextual Web search engine 这篇论文应该是一片总结性质的论文, 而且论文并没有多少的关于数据结构等的实现细节. 只是大体描绘了一下架构.

# Google的算法

首先, Google大量使用了在超文本也就是网页中存在的结构, 也就是锚文本和链接. 还有就是如何有效的处理在网页上, 所有人都可以任意发布任何文字的问题, Google在这片文章里给的解决方案是PageRank.

在20年前, 主要问题是, 网页已经开始快速增长, 然而当时的所有搜索引擎给出的结果只是搜索结果的数量也增长了, 却没能把最相关的结果放在首页. 因为人们并不会因为给出结果多而去多看几页, 所以这样的结果是不可取的. 在设计Google的过程中, Google还考虑了随着web规模的增长, 会对现有的体系造成的影响以及如何应对.

Google 还表达了对当时的搜索引擎都是商业化的, 因而一些诸如用户查询之类的结果无法共学术应用的情况表达了不满. (呵呵, Google这不是打自己的脸么)

对于 PageRank 算法, 提到了简单的公式:

![](https://ws1.sinaimg.cn/large/006tKfTcly1fqazehy4zdj30im02mmxd.jpg)

其中Tx表示的是指向A页面的所有页面, C表示的是一个页面上所有的外链. 对于这个公式的解释是这样的. 假设有一个随机的浏览者, 他不断的点击网页中的链接, 从不点后退, 直到他感到烦了, 然后在随机的拿一个网页开始点击. 其中d就表示了这个人会感到烦了的概率. 这样造成的结果就是如果一个网页有很多的的外链指向他的话, 他就有很大的机会获得比较高的PR, 或者如果一个很权威的站点指向的他的话, 也有很大机会获得比较高的PR.

对于锚文本, 大多数网站都是把他和所在的页联系起来, Google还把锚文本以及PR值和它指向的页面联系起来.

# Google的架构

其实这部分才是我最感兴趣的地方. 之所以今天会抽出时间来阅读这篇论文, 主要就是想写个小爬虫, 然后发现写来写去, 太不优雅了, 才想起翻出Google的论文读一读.

## Google整体架构

![](https://ws2.sinaimg.cn/large/006tKfTcly1fqazes7038j30gn0iitbl.jpg)

Google的架构非常的模块化, 基本上可以看到整个图, 就知道每个模块是负责做什么的. 大概分成了几个部分: 爬虫(下载器), indexer, barrel, sorter, 和(searcher)前端服务. 

其中

1. 爬虫负责下载网页, 其中每一个url都会有一个唯一的docID.
2. indexer负责解析网页中的单词, 生成hit记录, 并产生前向索引. 然后抽出所有的链接.
3. URLResolver会把indexer生成的锚文本读取并放到锚文本和链接放到索引中, 然后生成一个docID -> docID 的映射数据库. 这个数据库用来计算PageRank.
4. sorter根据indexer生成的正向索引, 根据wordID建立反向索引. 为了节省内存, 这块是inplace做的. 并且产生了wordID的列表和偏移
5. searcher负责接收用户的请求, 然后使用DumpLexicon产生的lexicon和倒排和PageRank一起做出响应.


## 用到的数据结构

由于一个磁盘寻道就会花费 10ms 的时间(1997), 所以Google几乎所有的数据结构都是存在大文件中的. 他们实现了基于固定宽度ISAM, 按照docID排序的document索引, 索引中包含了当前文件状态, 指向repository的指针, 文件的校验和, 不同的统计信息等. 变长信息, 比如标题和url存在另一个文件中. (YN: SSD对这个问题有什么影响呢)

hitlist指的是某个单词在谋篇文档中出现的位置, 字体, 大小写等信息. Google手写了一个htilist的编码模式, 对于每个hit花费2byte

barrel中存放按照docID排序存放document


## 模块

### 爬虫

爬虫又分为了两个部分, URLServer 负责分发URL给Crawler. Crawler 是分布式的, 有多个实例, 负责下载网页. 每获得一个URL的时候, 都会生成一个docID. Google使用了一个URLServer 和 3个Crawler. 每一个Crawler大概会维持300个连接, 可以达到每秒钟爬取100个网页. 并且使用了异步IO来管理事件.

#### DNS

Google指出爬虫的一个瓶颈在于每个请求都需要去请求DNS. 所以他们在每一个Crawler上都设置了DNS 缓存.


YN: 对于HTTP 1.1来说, 默认连接都是keep-alive的, 对于URLServer分发连接应该应该同一个域名尽量分发到同一个crawler上, 这样可以尽量避免建立连接的开销.


indexer会把下载到的网页分解成hit记录,每一个hit记录了单词, 在文档中的位置, 和大概的字体大小和是否是大写等因素. indexer还会把所有的链接都抽取出来, 并存到一个anchor文件中. 这个文件保存了链接的指向和锚文本等元素.

## rank

Google并没有手工为每一个因素指定多少权重, 而是设计了一套反馈系统来帮助我们调节参数.

# 结果评估

Google认为他们的搜索能够产生最好的结果的原因是因为使用了PageRank. Google在9天内下载了2600万的网页, indexer的处理能力在 54qps, 其中

# 拓展

query cacheing, smart disk allocation, subindices

链接合适应该重新抓取, 何时应该抓取新连接

使用了NFS, 性能有问题

## YN:

如何判定为一个hub也 -> 识别列表
hub页的链接产出率 -> 根据一个列表页是否产生新连接来动态的调整hub页的抓取频率

[1] http://infolab.stanford.edu/~backrub/google.html