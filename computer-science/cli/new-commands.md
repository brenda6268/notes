# 几个新一代命令行工具


wp_id: 61
Status: publish
Date: 2019-06-15 14:49:23
Modified: 2020-05-16 11:00:18


新一代命令行工具的特点是语法简单，符合直觉。他们大多使用 rust 或者 go 编写。

## sd

sd 可以替代 sed。sd 是使用 rust 编写的，所以使用的正则引擎和你在 JS 和 Python 中熟悉的正则引擎是一致的，也就不需要各种奇奇怪怪的转义了。sd 还具有字符串模式，也就是关闭正则表达式，这也避免了一些转义的工作量。

### 安装

```bash
# 首先安装 rust，如果没有安装的话
~$ curl https://sh.rustup.rs -sSf | sh
~$ cargo install sd
```

### 使用

```bash
# 和 sed 的对比：
sd: sd before after
sed: sed s/before/after/g

# 字符串模式, -s 开启，可以看到括号就是括号
> echo 'lots((([]))) of special chars' | sd -s '((([])))' ''
lots of special chars

# 默认是正则模式
> echo 'lorem ipsum 23   ' | sd '\s+$' ''
lorem ipsum 23

# 使用正则分组
> echo 'cargo +nightly w
```

## choose

用于替代 cut 和 awk（一部分）
https://github.com/theryangeary/choose