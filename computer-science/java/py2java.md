# Python 程序员的 Java 快速教程

<!--
ID: 7616826a-533a-4b44-ba61-047239262d39
Status: publish
Date: 2017-05-30T13:46:00
Modified: 2017-05-30T13:46:00
wp_id: 525
-->

和 Python 一样，Java 同样是一个面向对象的语言，甚至更进一步的说，Java 是一个只有面向对象范式的语言。Java 是一个比较正常的语言，甚至可以说正常到无聊。

## 变量和类型

像其他语言一样，Java 中也有 int/double/char 这些类型。但是 Java 有一个神坑：没有 uint64 类型，只有 signed int。不过相比 JavaScript 没有 long int 类型来说还是不算太坑吧。这个甚至影响到了 Thrift，为了兼容 Java，也不提供 uint64 类型。

- 除了基础类型之外，Java 还提供了一些封装类型 Integer/Double 等。
- Java 中不允许变量隐藏
- Java 中不允许将其他类型用做 bool 值，也就是 `if (1)` 是不合法的。
- 类型转换：Integer.parseInt, Interger.toString
- instanceof 运算符相当于 Python 的 isinstance 函数。
- Java 中没有 const 关键字，统一使用 final。
- Java 的修饰符有 public/protected/default/private 几种类型，一般来说，只用 public 和 private，另外两个不要用。sychonized 修饰符实际上是一个锁。
- Java 中的 true 和 false 是小写。
- Java 的循环和 C++ 完全一样。除此之外，还增加了 `foreach` 循环，类似于 C++ 11 中增加的。if 语句也和 C++ 完全一样。switch 语句也完全一样。
- 常用的数学函数都位于 java.lang.Math 包中。

### 相等比较

Java 一个特别坑爹的地方：大多数对象应该使用 `.equals` 比较，而不能使用 `==` 比较，因为 `==` 比较的是他们是否是同一个对象，而不是比较值。

就连内置的 String 对象都需要使用 `.equals` 比较。

另外，使用 `.equals` 的话还会遇到对象是否是 null 的问题，这时候可以使用 `Object.equals(a, b)` 来比较。

### 变量的作用域

```java
public class Variable {
    static int allClicks=0;    // 类变量
    String str="hello world";  // 实例变量
    public void method(){
        int i =0;  // 局部变量
    }
}
```

### 类型转换

java 需要显式转换类型
Assume that we have the following declarations of function f and variables h1 and h2: 

```java
public static void f( RaceHorse r ) { ... } 
Horse h1 = new RaceHorse(); 
Horse h2 = new Horse(); 
```

Now consider the following three calls to f: 

1. f(h1); // compile-time error (missing cast) 
2. f((RaceHorse)h1); // fine! h1 really does point to a RaceHorse 
3. f((RaceHorse)h2); // runtime error (bad cast) h2 points to a Horse 

静态方法和成员变量并没有 dynamic dispatching
可以使用 super.xxx() 调用父类已经被重载的方法

### 传值还是传引用

Java 中所有的对象都是传递的值，但是这个值是对象的地址，所以实际上是「传引用」的语义。包括原生数组在内，在函数中改变这个对象的属性都会影响到实参。

需要注意的是：在不少其他语言中，原生数组都是值传递的。

```java
public static void changeContent(int[] arr) {
   // If we change the content of arr.
   arr[0] = 10;  // Will change the content of array in main()
}

public static void changeRef(int[] arr) {
   // If we change the reference
   arr = new int[2];  // Will not change the array in main()
   arr[0] = 15;
}

public static void main(String[] args) {
    int [] arr = new int[2];
    arr[0] = 4;
    arr[1] = 5;

    changeContent(arr);
    System.out.println(arr[0]);  // Will print 10.. 

    changeRef(arr);
    System.out.println(arr[0]);  // Will still print 10.. 
                                 // Change the reference doesn't reflect change here..
}
```

### enum

```java
enum Color {
    GREEN,
    RED,
    BLUE
}
```

### 字符串

Java 的字符串和 Python 的字符串也类似，附带的方法也基本都有对应的，只是 Java 的名字更长一些。

在需要组合字符串的情形下，建议使用 StringBuilder 和 StringBuffer。其中 StringBuilder 不是线程安全的，但是速度要快一些。

```java
StringBuffer sBuffer = new StringBuffer("菜鸟教程官网：");
sBuffer.append("www");
sBuffer.append(".runoob");
sBuffer.append(".com");
System.out.println(sBuffer);  
```

## 容器类型

Java 的数组和 C++ 中的类似，但是语法上更加明晰，适应人的思维一些。需要注意的是数组也是「传引用」的。

```Java
double[] myList;         // 首选的方法
double myList[];         //  效果相同，但不是首选方法，兼容 C++
dataType[] arrayRefVar = new dataType[arraySize];
dataType[] arrayRefVar = {value0, value1, ..., valuek};
array.length  // 返回数组的长度
```

`java.util.Arrays` 中包含了一些 Array 的实用方法：fill, sort, binarySearch, equals 等等。

除了原生数组以外，Java 中常用的容器有：ArrayList, LinkedList, HashSet, TreeSet, HashMap, TreeMap, Stack。他们都在 `java.util` 中。至于他们的实现和时间复杂度显而易见都可以通过名字推测出来了，这里不再赘述。

容器类型使用了泛型，和 C++ 中的泛型基本没啥区别，后面再讲。

```java
List<String> list = new ArrayList<String>();
list.add("Hello");
list.add("World");
list.add("HAHAHAHA");
Iterator<String> ite=list.iterator();
while (ite.hasNext()) {
    System.out.println(ite.next());
}
```

遍历一个字典

```java
Map<String, String> map = new HashMap<String, String>();
map.put("1", "value1");
map.put("2", "value2");
map.put("3", "value3");

System.out.println("通过 Map.entrySet 遍历 key 和 value");
for (Map.Entry<String, String> entry : map.entrySet()) {
    System.out.println("key= " + entry.getKey() + " and value= " + entry.getValue());
}
```

## 函数

Java 中没有独立的函数，函数必须依附于类存在。

Java 中没有 `**kwargs` 这种字典参数，但是可以使用 `type... vals` 这种方式。一般的语言中也都只支持这一种方式。

## OO

- Java 中所有类都是 Object 的子类
- Java 会为你提供默认构造器（无参构造器），和 C++ 一样，不写构造函数也没啥问题。
- 只有类成员才会默认初始化，普通变量不会
- 匿名内部类非常有用。 new ClassName() {} 创建一个继承自 ClassName 的匿名类的对象
- 嵌套类是指使用了 static class 的内部类
- Java 中的类只能继承一个父类，也就是单根继承。使用 extends 关键字。但是一个类可以实现多个接口，接口中只能有函数签名，而不能有具体实现。
- 可以使用 super 和 this 分别调用父类和子类的方法。使用 super(args) 来调用父类的构造函数。
- 使用 super 调用基类的构造器，使用 this 调用自身其他的构造器，如果没有调用基类的构造器，会隐式调用基类的默认构造器
- 内部类：OuterClassName.InnerClassName. 内部类可以直接访问其外围对象的成员，而不需要任何特殊条件：OuterClass.this OuterClass.new  
- override 是子类和父类之间的同一个方法的关系。overload 是类中同名函数的不同参数签名对应的不同版本。但是无法通过返回值来重载函数

```java
int x = a.f()
```

其中，消息是 f(), 对象是 a, 面向对象就是「给对象发消息」

当定义自己的类型的时候，最好事先下面这几个方法：

1. toString 
2. equals 
3. hashCode 
4. clone 

`public String toString()`: Returns a String representation of the object. It is used, for example, by System.out.print to print an object. The default version of toString is not very useful, so you should override this method whenever you want to provide a String representation of your class objects. 
`public boolean equals(Object ob)`: Returns true iff the object (pointed to by "this") and ob are the same. The default version uses pointer equality; i.e., it returns true only if "this" and "ob" contain the same address. You may want to override this method to provide a more liberal notion of equality. For example, the String class overrides equals so that it returns true for two Strings that contain the same sequence of characters. 
`public int hashCode()`: Returns an integer for this object suitable for use as a hash code (e.g., for use with the Hashtable class defined in javil.util). This method should be overridden whenever the equals method is, so that hashCode returns the same value for two "equal" objects. 
`protected Object clone()`: Returns a copy of this object (note that no constructor is called for the new object). The default version just copies the values of all fields (i.e., a "shallow" copy). That is probably not what you want when your class has fields that contain pointers (i.e., arrays or classes). So in that case you should override the clone method to do a deep copy -- clone all pointer fields. 
Cloning

To permit your object to be cloned you must declare that your object implements the Cloneable interface. (See the notes on INTERFACES.) For example: 

```java
public class List implements Cloneable { 
    private Object items[]; // a pointer field! 
    ... 
} 
```

If you forget to do this, an attempt to clone will cause the exception CloneNotSupportedException to be thrown. 

### static block

Java has no implementation of static constructors, but has a static block that can be used to initialize class variables (static variables). 
This block will be called when the class is loaded.

```java
static {
    className = "Bicycle";
}
```

## 泛型

Java 支持泛型，就像 C++ 里一样，用 `<T>` 来表示。Java 泛型是使用类型擦除来实现的，所以算是不很完备吧，不过比没有强多了。

TODO: `<?>` 是什么意思呢？

## 包和 import

Java 中没有 `from x import y` 的语法，而只有 `import xxx`。import 之后会默认使用最后一个名字作为导入的名字，而 Python 中必须依然写完整的路径名。

使用 import 时，默认去 $CLASSPATH 查找对应的包

### 项目结构

可以参考 maven 的标准结构。

### 编译

```sh
javac MyClass.java # 生成 MyClass.class 等其他一些文件，每个类对应一个 class 文件
java MyClass # 这里没有 class 后缀
```

.java 文件编译生成 .class 文件，jar 文件是。class 文件的打包

使用 package name; 来声明包，所有的源文件要放在 name 这个文件夹下
可以使用 import package.class 或者 import package.* 来导入包
CLASSPATH 存放 package 的根目录


## 异常

```java
try{
  // 程序代码
}catch（异常类型 1 异常的变量名 1){
  // 程序代码
}catch（异常类型 2 异常的变量名 2){
  // 程序代码
}finally{
  // 程序代码
}
```

Java 中比较坑爹的一点是要求异常 (Checked Exception) 也是函数签名的一部分。如果想要避免在函数定义中加入 throws XXXException 的话，必须把所有抛出的 checked exception
全都捕获，偷懒的话，可以 catch(Exception e)。

从语义上来说，checked exception 是可以恢复的错误，而其他则是运行时错误。

尽量避免在 try...catch...finally 中使用控制转移语句

```
                +--------+
                | Object |
                +--------+
                    |
              +-----------+
              | Throwable |
              +-----------+
                /         \
               /           \
          +-------+      +-----------+
          | Error |      | Exception |
          +-------+      +-----------+
            /  |  \        / |        \
            \________/	  \______/    	\
            +------------------+
unchecked	 checked	| RuntimeException |
            +------------------+
            /   |    |      \
            \_________________/
					   
					   unchecked
```

checked 和 unchecked exception, RuntimeException 通常是指 unchecked exception

实际上，对于自己编写的异常类来讲，推荐默认的是继承 RuntimeException，除非有特殊理由才继承 Exception。 C#中没有 Checked Exception 的概念，这种推荐的做法等于是采用了 C#的设计理念：把是否捕获和何时捕获这个问题交给使用者决定，不强制使用者。当然，如果某些情况 下明确提醒捕获更加重要还是可以采用 Checked Exception 的。对于编写一个方法来讲，“是否在方法上声明一个异常”这个问题比“是否采用 Checked Exception”更加重要。

## 多线程

Java 中使用一个 Runnable 来表示一个可以独立调度的单元。Runnable 需要实现 void run() 函数

```java
class MyRunnable implements Runnable {}
Thread t = new Thread(new Runnable())
```

AtomicInteger AtomicLong AtomicReference

## 日期处理

使用 java.util.Date 类来表示一个日期，需要注意的是 Java 的时间戳是毫秒级的，Python 是秒级别的。

如果要格式化打印时间，需要使用：`java.text.SimpleDateFormat`。需要注意的是，这里使用的格式化方式和 Python 略微不同，不过也很好理解

```java
import java.text.SimpleDateFormat
Date now = new Date();
SimpleDateFormat ft = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
System.out.println("当前时间为：" + ft.format(now));
ft.Parse("2020-05-30 10:38:00") // 解析时间
```

尤其注意其中，`M` 表示的是月份，而 `m` 表示的是分钟，这点和 Python 是反过来的。`s` 表示秒，`S` 表示毫秒。

上面的 java.util.Date 有一些历史问题，所以在 java8 中又提供了 java.time 这个 API。

## lambda 表达式

```java
(args) -> {statements;}
```

## 正则

特别坑的一点是：Java 中没有 raw string，也就是正则表达式中的 `\` 都必须写成 `\\`。

```java
Pattern pattern = Pattern.compile(Pattern.quote("\r\n?|\n"));
```

## 注解

Java 的注解和 Python 的装饰器长得非常像，但是确实完全不一样的东西。注解有三种类型：

1. 给编译器的提示。比如说忽略某些错误。
2. 编译时或者部署时的处理。一些软件可以通过解析注解来生成文档等。
3. 运行时处理。

Annotation 更像是一个规范化的注释。而不会像 Python 装饰器那样改变程序的行为。

### 内置注解

@Deprecated，已废弃的方法
@Override，覆盖方法
@SuppressWranings，忽略错误

## JDK 选择

Oracle Java is more stable than OpenJDK, they are baisclly the same, you can think oracle java as a bugfix version of OpenJDK

## 参考

1. https://softwareengineering.stackexchange.com/questions/162643/why-is-clean-code-suggesting-avoiding-protected-variables
2. https://www.baeldung.com/java-checked-unchecked-exceptions
3. https://stackoverflow.com/questions/1256667/raw-strings-in-java-for-regex-in-particular
4. http://maven.apache.org/guides/introduction/introduction-to-the-standard-directory-layout.html
5. https://docs.oracle.com/javase/tutorial/java/annotations/
6. https://stackoverflow.com/questions/513832/how-do-i-compare-strings-in-java
7. https://learnxinyminutes.com
8. Java for c++ programmers http://pages.cs.wisc.edu/~hasti/cs368/JavaTutorial/
9. *Effecitve Java*
10. https://stackoverflow.com/questions/40480/is-java-pass-by-reference-or-pass-by-value
11. https://stackoverflow.com/questions/12757841/are-arrays-passed-by-value-or-passed-by-reference-in-java