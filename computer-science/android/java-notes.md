# Java Notes


ID: 525
Status: publish
Date: 2017-05-30 13:46:00
Modified: 2017-05-30 13:46:00


内部类
OuterClassName.InnerClassName
内部类可以直接访问其外围对象的成员，而不需要任何特殊条件
OuterClass.this OuterClass.new  

匿名内部类非常有用。 new ClassName() {} 创建一个继承自ClassName的匿名类的对象

嵌套类是指使用了static class 的内部类

java中不允许变量隐藏

只有类成员才会默认初始化，普通变量不会

int x = a.f()
其中，消息是f(), 对象是a,面向对象就是「给对象发消息」

java中不允许将其他类型用做bool值

java会为你提供默认构造器（无参构造器）

无法通过返回值来重载函数

静态块

static {
    i = 47;
}

可变参数列表
doGET(Object... args)

默认访问权限是包访问权限

.java 文件编译生成 .class 文件，jar文件是.class 文件的打包

使用import时，默认去CLASSPATH 查找对应的包

enum


enum Color {
    GREEN,
    RED,
    BLUE
}


annotations

@Override
@Deprecated
@SurpressWarnings


Concurrency

class MyRunnable implements Runnable {}
Thread t = new Thread(new Runnable())

AtomicInteger AtomicLong AtomicReference


Oracle Java is more stable than OpenJDK, they are baisclly the same, you can think oracle java as a bugfix version of OpenJDK

资料

learnxinyminutes
Java for c++ programmers http://pages.cs.wisc.edu/~hasti/cs368/JavaTutorial/
Effecitve Java

坑1

每个文件一个public类, 要求类的名称必须和文件名一样
当然还可以定义一些其他的非 public 的类
javac MyClass.java  生成 MyClass.class 等其他一些文件, 每个类对应一个 class 文件
java MyClass // 这里没有 class 后缀

坑2

数组	int[] numbers = {1, 2, 3, 4, 5, 6, 7, 8, 9, 0}; // 未指定元素会被初始化
ArrayList	
LinkedList	

.length 属性
for 语句
for (int i : numbers) {
    // 
}

使用 System.arraycopy 来复制数组

坑3

switch语句
java 中的 switch 语句和 c 一样, 依然是 fall-through, 在 java 7 中可以 switch string 了

坑4

类型转换: Integer.parseInt, Interger.toString

坑5

static block
Java has no implementation of static constructors, but has a static block that can be used to initialize class variables (static variables). 
This block will be called when the class is loaded.

static {
        className = "Bicycle";
    }

坑6

构造器可以调用另一个构造器,  使用 this, 还可以使用 super 调用父类的构造器
java 只能单继承, 但是可以实现多个接口, 接口中的方法不能有定义

坑7

不能使用==来判断对象(包括字符串)是否相等, 这样只能检测是否指向同一位置.

坑8 - IO

System.out.println

坑9 - 类型

原始类型	数字型
引用类型	数组和类

所有类都是 Object 的子类

 坑10 - Java.lang

String	字符串类
length	 长度
equals	 相等
toLowerCase/toUpperCase	

包装类	
Integer	
Boolean	
Double	

坑11 - Package

使用 package name; 来声明包, 所有的源文件要放在 name 这个文件夹下
可以使用 import package.class 或者 import package.* 来导入包
CLASSPATH 存放 package 的根目录

坑12 - 异常

     try {
       // statements that might cause exceptions
       // possibly including function calls
    } catch ( exception-1 id-1 ) {
       // statements to handle this exception 
    } catch ( exception-2 id-2 ) {
       // statements to handle this exception 
    .
    .
    .
    } finally {
       // statements to execute every time this try block executes
    }

try {
        return 0; // 被覆盖
    } finally {
        return 2;
    }
尽量避免在 try...catch...finally 中使用控制转移语句

                +--------+
                | Object |
                +--------+
		        |
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

checked 和 unchecked exception, RuntimeException 通常是指 unchecked exception
实际上，对于自己编写的异常类来讲，推荐默认的是继承RuntimeException，除非有特殊理由才继承Exception。 C#中没有Checked Exception的概念，这种推荐的做法等于是采用了C#的设计理念：把是否捕获和何时捕获这个问题交给使用者决定，不强制使用者。当然，如果某些情况 下明确提醒捕获更加重要还是可以采用Checked Exception的。对于编写一个方法来讲，“是否在方法上声明一个异常”这个问题比“是否采用Checked Exception”更加重要。

坑13 - OO
Each superclass method (except its constructors) can be either 
	• inherited, or 
	• overloaded, or 
	• overridden 
inherited: If no method with the same name is (re)defined in the subclass, then the subclass has that method with the same implementation as in the superclass. 
overloaded: If the subclass defines a method with the same name, but with a different number of arguments or different argument types, then the subclass has two methods with that name: the old one defined by the superclass, and the new one it defined. 
overridden: If the subclass defines a method with the same name, and the same number and types of arguments, then the subclass has only one method with that name: the new one it defined. 
使用 super 调用基类的构造器，使用 this 调用自身其他的构造器，如果没有调用基类的构造器，会隐式调用基类的默认构造器

Recall that every class extends Object. So you might wonder which methods of Object you should consider overriding when you define a new class. There are four methods that often should be overridden: 
	1. toString 
	2. equals 
	3. hashCode 
	4. clone 
public String toString(): Returns a String representation of the object. It is used, for example, by System.out.print to print an object. The default version of toString is not very useful, so you should override this method whenever you want to provide a String representation of your class objects. 
public boolean equals(Object ob): Returns true iff the object (pointed to by "this") and ob are the same. The default version uses pointer equality; i.e., it returns true only if "this" and "ob" contain the same address. You may want to override this method to provide a more liberal notion of equality. For example, the String class overrides equals so that it returns true for two Strings that contain the same sequence of characters. 
public int hashCode(): Returns an integer for this object suitable for use as a hash code (e.g., for use with the Hashtable class defined in javil.util). This method should be overridden whenever the equals method is, so that hashCode returns the same value for two "equal" objects. 
protected Object clone(): Returns a copy of this object (note that no constructor is called for the new object). The default version just copies the values of all fields (i.e., a "shallow" copy). That is probably not what you want when your class has fields that contain pointers (i.e., arrays or classes). So in that case you should override the clone method to do a deep copy -- clone all pointer fields. 
Cloning
To permit your object to be cloned you must declare that your object implements the Cloneable interface. (See the notes on INTERFACES.) For example: 
	public class List implements Cloneable { 
		private Object items[]; // a pointer field! 
		... 
	} 
If you forget to do this, an attempt to clone will cause the exception CloneNotSupportedException to be thrown. 

坑14 - casting
java 需要显式转换类型
Assume that we have the following declarations of function f and variables h1 and h2: 
	public static void f( RaceHorse r ) { ... } 
	Horse h1 = new RaceHorse(); 
	Horse h2 = new Horse(); 
Now consider the following three calls to f: 
	1. f(h1); // compile-time error (missing cast) 
	2. f( (RaceHorse)h1 ); // fine! h1 really does point to a RaceHorse 
	3. f( (RaceHorse)h2 ); // runtime error (bad cast) h2 points to a Horse 

静态方法和成员变量并没有 dynamic dispatching
可以使用 super.xxx()调用父类已经被重载的方法

坑15 - Interface