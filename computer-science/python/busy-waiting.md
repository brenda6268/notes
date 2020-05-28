# 忙等待


wp_id: 684
Status: draft
Date: 2017-07-27 23:34:00
Modified: 2020-05-16 11:46:49


```
while True:
    pass 
```

this is busy waiting

```
while True:
    time.sleep(10)
```

this is not busy waiting, bucause cpu are free to do other things, and only need trivial cpu cycles

http://stackoverflow.com/questions/529034/python-pass-or-sleep-for-long-running-processes

busy waiting is considered as anti-pattern, but using it in spinning-lock is ok

should use select if we need to wait for something

https://en.wikipedia.org/wiki/Busy_waiting