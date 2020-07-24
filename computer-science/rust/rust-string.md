Rust 字符串

Rust 的字符串字面量的类型是 `& 'static str`，也就是说指向静态内存的指针。

Rust 的字符串本身就是多行的。

Rust 的 raw string `r#"..."#`

可以直接使用 `include_str!` 来直接引入文件！

```rust
let 00_html = include_str!("00_en.html");
```

在 Rust 里面，len 不再是一个函数，而是一个方法。

```rust
let a = "hi 🦀";
println!("{}", a.len());
let first_word = &a[0..2];
let second_word = &a[3..7];
let _half_crab = &a[3..5]; // FAILS
```

rust 字符串的索引是按照 bytes 的，而不是按照字符的。而且当索引不合法的时候会直接 panic.

## string builder

rust 中没有 string builder 这样的类,而是直接使用 vector 来实现的.

```rust
fn main() {
    let helloworld = ["hello", " ", "world", "!"].concat();
    let abc = ["a", "b", "c"].join(",");
    println!("{}", helloworld);
    println!("{}",abc);
}
```

## 格式化输出

rust 中使用 `format!` 宏来实现格式化.

```rust
fn main() {
    let a = 42;
    let f = format!("secret to life: {}",a);
    println!("{}",f);
}
```

## 转化与解析

一般的类型都可以通过 `to_string` 方法来转化为字符串, 如果需要解析字符串可以使用泛型方法 `parse`

```rust
fn main() -> Result<(), std::num::ParseIntError> {
    let a = 42;
    let a_string = a.to_string();
    let b = a_string.parse::<i32>()?;
    println!("{} {}", a, b);
    Ok(())
}
```