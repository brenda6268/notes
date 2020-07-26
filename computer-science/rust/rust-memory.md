# Rust 生命周期管理概述

wp_id: 169
Status: draft
Date: 2019-02-17 14:58:05
Modified: 2020-05-16 10:54:42

> 注意：本文适合有一定 C++ 基础的同学。

在 C++ 中使用智能指针，比如 unique_ptr ，可以大幅度减少管理内存的心智负担和出错概率。Rust 作为一门没有 GC 也没有 malloc 和 free 的语言，自然是继承了 C++ 智能指针的思想，并且更进一步，通过类型实现了内存管理。本文主要介绍下 Rust 中的 Box，Rc，RefCell 等类型。

周末花些时间把 Rust 生命周期又翻了一遍，终于能写出一个可以编译通过的程序了？。Rust 虽然学习曲线比较陡峭，但是掌握之后就发现这么设计确实是有道理的，尤其是对于编写正确的 C++ 程序也很有帮助。

本文对于每一个类型的讲解中我们会关注几个特征：指向内容是否可变、是否独占所有权、是否线程安全。最后给出一个链表的实现。

## 回顾下什么是内存泄露

在栈上使用变量总是内存安全的，每当函数退出的时候就会释放栈上的变量。但是有的变量的生命周期是要跨越一个函数的，这时候就需要再堆上分配内存。理想情况下，A 分配了内存，B 用完了，然后 B 来释放，没什么问题。但是往往会出现 A 分配了内存，然后对象被传来传去没有人去释放的情况，这时候就泄露了。

| 指针  |  所有权 |线程安全性|
| ------------ | ------------ |-----------|
| Box  |  唯一（编译时检查） |安全|
|Rc   | 共享  |不安全|
|Arc|共享| 安全|
|RefCell|唯一（运行时检查）|不安全|

## 可变与不可变

Rust 中使用 let 来绑定一个变量，默认是不可变的。也就是说默认就相当于 C++ 中 const 变量。但是实际上 C++ 中的 const 也只是只读而已。

```
let x = 5;
x = 6;  // 非法
```
如果想要更改一个变量的值，在声明的时候，应该加上 mut（每次写 let mut 的时候，我心里都是读作“让 TM 的”）

```
let mut = 5;
x = 6
```

## 借用

Rust 把 C++ 中的取指针运算符 (`&`) 明确为 borrow 语义，也就是把所有权借了出去。

```rust
struct Foo {
    x: i32,
}

fn main() {
    let foo = Foo { x: 42 };
    // 不可变借用（引用）
    let f = &foo;
    println!("{}", f.x);
    // 可变借用（引用）
    let f = &mut foo;
}
```

Rust 的编译器直接禁止了多个可变借用，所以从根本上避免了数据竞争（data race）

Rust 同样支持使用 `*` 来解引用，不过和 C++ 不同的是，使用 `*` 的时候会复制一份（copy 语义）。

Rust 中的 `.` 还会自动解引用，这样就方便多了

```rust
let f = Foo { value: 42 };
let ref_ref_ref_f = &&&f;
println!("{}", ref_ref_ref_f.value);
```

### copy 和 move 语义

如果一个类型实现了 copy 语义，那么当我们解引用的时候就会复制一份

Rust 的所有权规则可以总结如下：

1. Rust 只允许有一个可变引用或者多个不可变引用，但是不能同时存在两者。
2. 引用不能比所有者存活更长。

## 智能指针

rust 中直接内置了智能指针类型 Box, 如果想把一个对象放到堆上，直接用 Box 就行了：
```rust
Box::new(Foo { ... })
```

box 比较类似 C++ 中的 unique_ptr, 除此之外，还有 `std::rc::Rc` 类型的引用计数指针。同样是使用 `Rc::new` 方法创建一个新的对象。如果要在多线程环境中使用，应该使用 `std::rc::Arc` 指针，这个是类型安全的，其中的 a 就是 automic 的缩写。
RefCell 是另一种类型的智能指针，他会在运行时执行 rust 的生命周期检查，也就是只允许一个可变的引用。
## `Box<T>` 类型和 `Rc<T>` 类型

Box 基本就是 C++ 中的 `std::unique_ptr`。Box 默认情况下独占所有权，所以内部变量是可变的。

Rc 是 Reference Count 的缩写，也就是对变量进行引用计数，所以可以有多个变量同时指向同一个内部变量，基本可以理解为 C++ 中的 `std::shared_ptr`。

和 C++ 不一样的是，Rust 更加强调所有权的概念，既然 Rc 可能被多个变量持有，那么他就是不可变的，谁也不要改好了。

Box 指针的变量是独占的，我们可以改变 Box 内部的值，而 Rc 因为是共享的变量，不能改变 Rc 内部的值。

```rust
use std::rc::Rc;

fn main() {
    let mut a = Box::new(1);
    let mut b = Rc::new(1);

    *a = 2; // works
    *b = 2; // doesn"t
}
```

## `Rc<T>` 和 `Arc<T>` 的对比

`Arc<T>` 是 Atomic Reference Count 的缩写。这两者的区别也很简单，Arc 是线程安全的，而 Rc 不是线程安全的。

## Cell 和 RefCell 类型

这两个严格来说不能算智能指针，而是对值的一种包装类型。Cell 其实就是让不可变的类型是可变的，常用作 struct 的属性。Cell 要求被包装的类型是 Copy 的。

## `Rc<T>` 和 `RefCell<T>` 的对比

不同于 `Rc<T>` 的共享指针模式，RefCell 代表的是对数据的唯一所有权。实际上 Rc 和 RefCell 经常是连在一起用的，`Rc<RefCell<T>>`。

比如要实现一个链表：

## 参考文献

1. [Rust 学习笔记之内存管理](http://bitking.wang/2019/03/19/rust-memory.html)
2. [Rust 合适使用 Rc 和 Box](https://codeday.me/bug/20190303/755318.html)
3. [Rust 概览](https://www.infoq.cn/article/rust-core-components)
4. [Leak-free C++ by default](https://www.youtube.com/watch?v=JfmTagWcqoE)
5. https://www.reddit.com/r/rust/comments/4cvc3o/what_are_cell_and_refcell_used_for/
6. https://manishearth.github.io/blog/2015/05/27/wrapper-types-in-rust-choosing-your-guarantees/
7. [资源管理是个本质难题](https://yuheng.io/articles/resource-management-is-hard)
8. https://www.quora.com/What-do-C-C++-systems-programmers-think-of-Rust/answer/Mitchell-Nordine?srid=XCS&share=1
9. https://xr1s.me/2018/03/01/rust-learning-notes-for-cxx-programmer-part-one/
10. https://skyline75489.github.io/post/2017-7-27_rust_mm.html
11. https://xr1s.me/2018/03/01/rust-learning-notes-for-cxx-programmer-part-two/
12. https://xr1s.me/2018/03/01/rust-learning-notes-for-cxx-programmer-part-three/
13. https://tourofrust.com/00_en.html
14. https://stackoverflow.com/questions/55075458/understand-smart-pointers-in-rust
15. https://stackoverflow.com/questions/49377231/when-to-use-rc-vs-box
16. https://ricardomartins.cc/2016/06/08/interior-mutability