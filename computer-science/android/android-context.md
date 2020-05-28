# 安卓开发中的Context


wp_id: 544
Status: publish
Date: 2017-11-15 05:29:00
Modified: 2020-05-16 11:54:46


在安卓当中，Context几乎是无处不在的，每一个Activity是一个Context，每一个Service也是一个Context。

但是如果你新起了一个线程的话，你需要显式地把Context传递进去。

比如下面的例子：

```java
public class DumpLocationLog extends Thread {
    LocationManager lm;
    LocationHelper loc;
    public DumpLocationLog(Context context) {
        loc = new LocationHelper();
        lm = (LocationManager) context.getSystemService(Context.LOCATION_SERVICE);
    }
    public void run() {
        lm.requestLocationUpdates(LocationManager.GPS_PROVIDER, 1000L, 500.0f, loc);
    }
}
```

然后使用这个线程的时候，把this，也就是一个context的实例传递进去

`new DumpLocationLog(this);`



if you are in a fragment, use getAcitvity()


if you are in an anoynmous onclicklistener, `this` is MainActivity.this