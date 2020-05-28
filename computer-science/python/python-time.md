# Python time 模块


wp_id: 680
Status: publish
Date: 2018-04-30 14:40:00
Modified: 2020-05-16 11:38:00


时间戳，struct_time 可以被认为是一个表示时间的整数序列，一共9项对应于 C 中对应的数据结构，注意其中不包含时区信息

函数 | 说明
----|----
time.time | 	获取当前时间戳，即 GMT 的 epoch 秒数
time.clock()|获取进程时间，即从进程开始执行的时间
time.sleep() |停止当前线程若干秒
time.strftime|产生可读时间字符串 
time.strptime |parse time
time.strftime()/time.mktime()/time.asctime() | 均接受 struct_time 作为参数
time.gmtime()/time.localtime()/time.strptime() | 返回的是对应时间的struct_time


# time.time vs time.clock

time.clock measures the cpu time spent, if you code does heavy IO or GPU computing, the result is WRONG， time.time is not precise but works all the time~