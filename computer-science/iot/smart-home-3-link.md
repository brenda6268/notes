# 智能家居折腾记（3）—— 链接其他设备


ID: 440
Status: draft
Date: 2018-05-07 02:39:00
Modified: 2020-05-16 11:38:48


要想让设备都连接起来，目前有几种种协议可以考虑：WiFi、zigbee、蓝牙（mesh）、NB-IoT、LoRa。

先说 Wifi，WiFi 是一个中心节点，带宽比较高，但是同时支撑的设备比较少，大概在几十个。

nbiot 是窄带物联网的缩写，就是直接利用移动运营商的网路，因此不需要网关。如名字所言，带宽也很低。

参考：

1. [在物联网中，你是否看好Zigbee的前景，低功耗Wifi以及蓝牙4.0（低功耗蓝牙）呢？](https://www.zhihu.com/question/19898414)
2. [物联网解决方案，一个基于 Wi-Fi、一个基于 ZigBee，两者的优势和劣势有哪些？](https://www.zhihu.com/question/22898725)
3. [NB-IOT/LoRa/Zigbee无线组网方案对比](https://blog.csdn.net/robert_tina/article/details/78864790)