# Rust 面向对象编程

严格来说，rust 是不支持面向对象编程的，因为 rust 中不支持继承。

rust 中方法和数据结构的定义是分开的。数据结构使用 struct 定义，而方法使用 impl 关键字。rust 中使用 `pub` 关键字代表 public, 比较简练。

```rust
struct SeaCreature {
    pub name: String,
    noise: String,
}

impl SeaCreature {
    pub fn get_sound(&self) -> &str {
        &self.noise
    }
}

fn main() {
    let creature = SeaCreature {
        noise: String::from("blub"),
    };
    println!("{}", creature.get_sound());
}
```

和 Python 一样，rust 的方法也必须显式指定参数 `self`. 不过，显然 rust 中我们需要使用引用，也就是 `&self` 或者 `&mut self`.

## 接口

rust 中的接口叫做 `trait`, 当我们定义一个类的时候，可以实现某个接口。但是和 Java 等语言的接口不同的是，`trait` 中也可以有实现，而不只是空接口。而且虽然 struct 不能继承，trait 确是可以继承的

```r ust
trait MyTrait {
    fn foo(&self);
    ...
}

impl MyTrait for MyStruct { 
    fn foo(&self) {
        ...
    }
    ... 
}
```

## 泛型

在函数的泛型中,还可以约束泛型的类型

```rust
fn my_function(foo: impl Foo) {
    ...
}

// 或者
fn my_function<T>(foo: T)
where
    T:Foo
{
    // ...
}
```