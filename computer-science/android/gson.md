# 使用 Gson 解析 json 文档


ID: 532
Status: publish
Date: 2018-04-04 05:56:00
Modified: 2020-05-16 11:33:16


解析 json 有两种流派：


1. event-driven json parse: iterate the document, not loading all into memory
2. document-based json parse: load the full document into memory once for all.

在 Python 中可以很容易的解析json文件，Python 中的 json.loads 是 document-based。而在 java 中可以使用 event-driven的。个人感觉这种 event-driven 的解析方式是多此一举，json本来定位就是小型的数据传输和配置存储，如果生成了一个很大的 json，应该考虑换用xml了。

在 Java 中需要生成和 JSON 文档意义对应的 JavaBean 文件，这样才能解析到 Java Class。

把你的 json 文件的例子首先编写好，然后可以通过这个网站生成 JavaBean：http://www.jsonschema2pojo.org/

![](https://ws2.sinaimg.cn/large/0069RVTdly1fu2lsahbklj31880ni77y.jpg)

在 Android Studio build.gradle 文件中添加依赖：

```
dependencies {
  compile &#039;com.google.code.gson:gson:2.3.1&#039;
}
```

解析

```
package com.example;

import com.google.gson.annotations.Expose;
import com.google.gson.annotations.SerializedName;

public class Example {

@SerializedName(&quot;foo&quot;)
@Expose
private String foo;

public String getFoo() {
    return foo;
}

public void setFoo(String foo) {
    this.foo = foo;
}

}
```

```
Gson gson = new Gson();

String json = &quot;{\&quot;foo\&quot;: \&quot;bar\&quot;}&quot;;
Example example = gson.fromJson(json, Example.class);
// 解析：JavaBean对象 = gson.fromJson(json, JavaBean.class);
```



参考资料：

1. http://www.jianshu.com/p/b87fee2f7a23