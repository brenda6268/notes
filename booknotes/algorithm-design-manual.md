# 《算法设计与分析基础》笔记


ID: 344
Status: publish
Date: 2018-06-22 05:46:00
Modified: 2020-05-16 11:10:37


http://blog.csdn.net/wangyunyun00/article/details/23464359

差值查找

折半查找这种查找方式，还是有改进空间的，并不一定是折半的！
mid = （low+high）/ 2, 即 mid = low + 1/2 * (high - low);
改进为 下面的计算机方案（不知道具体过程）：
mid = low + (key - a[low]) / (a[high] - a[low]) * (high - low)，
也就是将上述的比例参数1/2改进了，根据关键字在整个有序表中所处的位置，让mid值的变化更靠近关键字key，这样也就间接地减少了比较次 数。