# rust-lang for pythonistas


ID: 521
Status: draft
Date: 2017-11-18 03:38:00
Modified: 2020-05-16 11:55:44


上周终于对 Python 的 GIL 感到厌烦了，参见这篇：Python中不好的地方。本来打算看看 C++，但是正好在 Hacker News 上看到了 Mozilla 如何让 Firefox 变快的文章，感觉 rust 的 fairless with concureency 很吸引人，不如学习一下 rust-lang吧!

上次对 rust-lang 感兴趣的时候，rust 还不是很稳定，官方甚至说 API 可能会变，而且诸如 cargo 之类的都没有，而现在 rust
 的生态系统已经很繁荣了，而且能够在 firefox 这种久经考验的程序中使用也足以说明了 rust 的可用性。

之后以一个 pythoneer 的角度来谈下 rust，并且假定读者有一定的 C++ 功底。主要参考 《the rust programming language》这本书。

# cargo

rust 像 C/C++ 一样是一门编译型的语言，没有 gc。就像是 C/C++ 经常用 make 来编译一样，rust 也有自己的构建工具。

cargo 就相当于 python 的pip ＋ venv，或者说 C++ 的 make。而且因为 cargo 直接是官方钦点的，内置其中，所以比pip应该是更好用更强大。

要开始一个项目：

```
cargo new hello_world --bin
```

其中 `--bin` 的意思是我们要编译的结果是一个二进制文件，而不是一个库。

生成了一个目录

```
.
└── hello_world
    ├── Cargo.toml
    └── src
        └── main.rs

2 directories, 2 files
```

其中 `main.rs` 已经是 hello world 了。值得注意的是：

1. rust 函数使用 fn, Python使用 `def`
2. rust 像 C 一样需要分号结尾
3. rust 和 C 不一样的地方是，从语法上强行区分宏（println!），宏必须是叹号结尾。而 C 只是约定宏是大写。

直接执行`cargo run`，cargo编译并执行打印出hello world。

# 变量

rust 的变量拥有类型，当然像所有的新语言一样，rust支持类型推导，rust的默认类型还是const的，如果需要重新复制，需要显示地使用mut。rust还支持类似python的自动解包。

```
let const_var = 1;
const_var = 1; //gives an error
let mut mutable_var = 2;
mutable_var = 3; // ok
let (x, y) = (1, 2);
let a: i32 = 2;
```

rust 是块作用，而Python是函数作用与。

# 函数

rust 的函数参数需要生命类型，语法和 Python 3 的annotation 有点类似。

```
fn add(x: i32, y: i32) -&gt; i32 {
    x + y
}
```

rust 中没有返回值的函数称之为发散函数，类似于 C 中的void函数
```
fn diverge() -&gt; ! {
  panic!(&quot;not returning&quot;);
}
```

rust 可以把函数复制给变量，rust的语法比C简单了一万倍。

```
fn plus_one(i: i32) -&gt; i32 {
  i + 1
}

let f: fn(i32) -&gt; i32 = plus_one;

let f = plus_one;
```

# 类型

bool, char, i32, isize 等这些类型顾名思义，不再赘述。

## 数组

```
let a = [1, 2, 3];  // a: [i32: 3]
let mut m = [1, 2, 3]; // m: [i32: 3]
```

数组的类型是 [T; N], T表示类型， N是编译时常量。

需要注意的是，对于 [1,2,3], [1.0, 2.0, 3.0] 这两个值，Python 的 list 的类型就是 list，而在rust中则分别是 [i32:3] 和 [f64:3]两种类型。

可以用下标访问元素，使用a.len() 获取长度。值得注意的是，rust会进行下标合法性检查。


## Slice

就像是Python中的切片一样，不过使用`..`而不是`:`。


```
let a = [1, 2, 3, 4, 5];
let complete = &amp;a[..];
let middle = &amp;a[1..4];
```

类型是 `&[T]`。

## 字符串

跳过

## tuple

tuple 和 Python 的 tuple 语法上类似，但是 rust 是一门强类型的语言，所以tuple的类型并不是简单的tuple，比如说(1, 'hello'), 在python中的类型就是tuple，再没别的了，而在rust中而是 tuple of (int, str)这种。

# if and loops

## if

rust 的 if 并不复杂，像 Python一样不需要括号，但是像 C 一样需要 大括号。

```
if x == 5 {
    println!(&quot;x is five&quot;);
} else {
    println!(&quot;x is not five&quot;);
}

let y = if x == 5 { 10 } else {15};  // 像 python一样的三元表达式
```

## loops

loop 就像是 while true，但是 rust 推荐使用 loop。

和Python一样，rust 只提供了 for..in 循环。相应于 Python 的 range(5, 10)，在rust 中写作(5..10)。而且就像是len一样，enumerate是一个方法而不是全局函数。

```
for (idx, value) in (5..10).enumerate() {
  println!(&quot;index = {} and value = {}&quot;, idx, value);
}
```

# Ownership

Rust 的核心概念就是ownership。在 rust 中，有如下三条规则：

1. 在 rust 中每个值都对应了一个变量，称之为他的 owner。
2. 同时只能有一个 owner。
3. 当 owner 走到了作用域的结尾，这个值就会被释放。

## 生命周期

rust 中有一个类型叫做 String，相对于 str 类型， String 默认在堆上分配空间，而且是可变的。

```
let mut s = String::from(&quot;hello&quot;);

s.push_str(&quot;, world!&quot;); // push_str() appends a literal to a String

println!(&quot;{}&quot;, s); // This will print &#x60;hello, world!&#x60;
```

在这里，String s 的内存的释放类似于C++ 中的RAII模式，在走出作用域的时候，调用s的drop方法，释放内存。

## 赋值于函数调用默认是 move 的语义

```
let s = String::from(&quot;hello&quot;);
let v = s;    //相当于 C++ 的 std::move
println!(s)  // error
```

函数调用与返回也是类似的语义，不再赘述。这里带来的问题是，每次传递函数参数的时候都会把当前变量move走，所以总要记得把这个变量通过return再move回来。这时候我们需要引用。

## 借用

其实就相当于 C++ 的常量引用

```
fn calculate_length(s: &amp;String) -&gt; usize { // s is a reference to a String
    s.len()
} // Here, s goes out of scope. But because it does not have ownership of what
  // it refers to, nothing happens.
```

可变的引用也就相当于 C++ 中的普通引用

```
fn main() {
    let mut s = String::from(&quot;hello&quot;);

    change(&amp;mut s);
}

fn change(some_string: &amp;mut String) {
    some_string.push_str(&quot;, world&quot;);
}
```

什么是 data racing?

1. 两个或更多指针在同时访问同一篇内存
2. 至少有一个指针要写入数据
3. 没有同步机制

所以在 rust 中，在编译期间就会检查所有的引用，只有两种情况才允许编译通过：

1. 只有一个可变应用
2. 所有引用都是只读的

## 悬垂引用

rust 还会保证不会有悬垂引用。

# enum 

rust 的 enum 中的元素可以有不同的类型，而不是像C一样只能是int

## 后记

这两天看了一遍，感觉rust还是很激进的，从compiler角度把这些问题处理好了，并且没有gc，应该是下一代的Python，而Go则感觉更像是 Ruby，可能活过这一阵就算了